class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]

  has_many :ideausers
  has_many :ideas, :through => :ideausers
  has_many :features, :through => :ideas
  has_many :subfeatures, :through => :features
  has_many :ideamessages
  belongs_to :group
  has_many :invitedusers
  has_many :settings
  has_many :sent_notifications, class_name: "Notification", foreign_key: "sender_id"
  has_many :received_notifications, class_name: "Notification", foreign_key: "receiver_id"

  #Google Authentication
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
      if user
        return user
      else
        registered_user = User.where(:email => access_token.info.email).first
        if registered_user
          return registered_user
        else
          #Retrieve the signupcode from Admin
          returnedsignups = Setting.retrieve_adminvalues("Join Secret")

          #The @signupcode is used to Create the user below (Otherwise it would not validate on create)
          returnedsignups.each do |i|
            @signupcode = i.value
          end

          @user = User.create(username: data["name"],
            provider:access_token.provider,
            email: data["email"],
            uid: access_token.uid ,
            password: Devise.friendly_token[0,20] ,
            #Need to figure out how to prompt for this
            signupcode: @signupcode,
            #Setting status to 1 means the user has been created, but has not given a signupcode to continue
            status: 1,
            imageurl: data["image"]
          )

          #Calls onboarding method
          onboarduser(@user)
          return @user
        end
     end
  end

  #Create a virtual attribute to accept as a parameter for users
  attr_accessor :signupcode

  #Basic validation
  #Validates uniqueness of the username
  validates :username, uniqueness: { case_sensitive: false }

  def self.signupcodes
    #Retrieve sign up code from Admin
    @joinsecret = Array.new
    secretresults = Setting.retrieve_adminvalues("Join Secret")

    #Iterate through sign up codes and add to array
    secretresults.each do |i|
      @joinsecret << i.value
    end
    return @joinsecret
  end

  #Ensures the signupcode is entered correctly (this will need to be looked at after deployment)
  validates :signupcode, :inclusion => { :in => signupcodes, :message => "Not a valid sign up code"}

  def group_usernames
  	users = User.all.map {|i| [i.username, i.id]}
  end

  def self.search_users(email)
    User.where("email = ?",email)
  end

  def self.return_userinfo(user_id)
    User.where("id = ?", user_id)
  end

  def self.return_ideausers(idea_id)
    User.joins(:ideausers).where("ideausers.idea_id = ?",idea_id).select("username","role","email","ideausers.id","imageurl")
  end

  def self.onboarduser(user)
    #Adds the user to any ideas based on any outstanding invites

      #search all ideas a user has been invited to prior to sign-up
      @allideas = Inviteduser.return_ideasforgivenuser(user.email)

      #iterate through the ideas and add the user to each idea 
      @allideas.each do |i|
        Ideauser.create(:user_id => user.id, :idea_id => i.idea_id, :role => i.role)
      end

    #Adds the user to his/her own group on creation to support Group level settings

      #Create Group
      group = Group.new

      #Assign Group Name
      group.name = user.username + "'s group"

      #Generate random secret code to join
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      group.joinsecret = (0...25).map { o[rand(o.length)] }.join

      #Save the group
      group.save

      #Update the user with a group id
      user.group_id = group.id

      user.save

    #Creates initial settings for the user at the Group level
      #Find user account
      @onboarduser = User.find_by_id(user.id)

      #Find group by user
      @onboardgroup = user.group

      #Initial subfeature categories for a given user (Should eventually be modified by Admin to be dynamic)
      @initialsettings = Setting.retrieve_adminvalues(nil)

      #Create new instance
      @initialsettings.each do |i|
        case i.settingtype
        when "Subfeature Category"
          initalsetting = Setting.create(:settingtype => i.settingtype, :value => i.value, :user_id => user.id, :group_id => @onboardgroup.id)
        when "Idea Type"
          ideatype = Ideatype.create(:name => i.value, :active => true, :group_id => @onboardgroup.id)
        end
      end
  end
end

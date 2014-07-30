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
          user = User.create(username: data["name"],
            provider:access_token.provider,
            email: data["email"],
            uid: access_token.uid ,
            password: Devise.friendly_token[0,20] ,
            #Need to figure out how to prompt for this
            signupcode: 'joinme'
          )
        end
     end
  end

  #Create a virtual attribute to accept as a parameter for users
  attr_accessor :signupcode

  #Basic validation
  #Validates uniqueness of the username
  validates :username, uniqueness: { case_sensitive: false }

  #Retrieve sign up code from Admin
  @joinsecret = Array.new
  secretresults = Setting.retrieve_adminvalues("Join Secret")

  #Iterate through sign up codes and add to array
  secretresults.each do |i|
    @joinsecret << i.value
  end

  #Ensures the signupcode is entered correctly
  validates :signupcode, :inclusion => { :in => @joinsecret, :message => "Not a valid sign up code"}

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
    User.joins(:ideausers).where("ideausers.idea_id = ?",idea_id).select("username","role","email","ideausers.id")
  end
end

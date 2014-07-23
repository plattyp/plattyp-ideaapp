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
  def self.from_omniauth(auth)
    if user = User.find_by_email(auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid
      user
    else
      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.username = auth.info.name
        user.email = auth.info.email
        user.avatar = auth.info.image
      end
    end
  end

  #Create a virtual attribute to accept as a parameter for users
  attr_accessor :signupcode

  #Basic validation
  #Validates uniqueness of the username
  validates :username, uniqueness: { case_sensitive: false }

  #Ensures the signupcode is entered correctly
  validates :signupcode, :inclusion => { :in => ['joinme'], :message => "Not a valid sign up code"}

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

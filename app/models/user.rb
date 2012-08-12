class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :authentication_keys => [ :name ]
#         :openid_authenticatable #Don't feel like dealing with this

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :name
  before_create :de_guest
  after_create :welcome_mail

  has_many :posts
  has_one :ban
  has_and_belongs_to_many :watched_posts, :class_name => 'Post', :uniq => true

  validates :name, :presence => true
  validates :name, :uniqueness => true
  validate :check_email_ban

  def email_changed?
    false
  end

  private
  def de_guest
    self.guest_user = false
    true
  end

  def welcome_mail
    BoardMailer.welcome_email(self).deliver
  end

  def check_email_ban
    if Ban.find_ban(:email => self.email)
      errors[:email] << "is banned."
    end
  end
end

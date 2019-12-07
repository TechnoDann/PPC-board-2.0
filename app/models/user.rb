# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [ :name ]
#         :openid_authenticatable #Don't feel like dealing with this

  before_create :de_guest

  has_many :posts, dependent: :restrict_with_exception
  has_one :ban, dependent: :nullify
  has_and_belongs_to_many :watched_posts, -> { distinct }, :class_name => 'Post'

  validates :name, :presence => true
  validates :name, :uniqueness => true
  validates_length_of :name, :maximum => 80
  validate :check_email_ban

  attr_accessor :antispam
  validate :check_antispam_question, on: :create

  def email_changed?
    false
  end

  private
  def de_guest
    self.guest_user = false
    true
  end

  def after_confirmation
    BoardMailer.welcome_email(self).deliver_now
  end

  def check_email_ban
    if Ban.find_ban(:email => self.email)
      errors[:email] << "is banned."
    end
  end

  def check_antispam_question
    unless self.antispam.upcase == "PPC"
      errors[:antispam] << "Invalid answer"
    end
  end
end

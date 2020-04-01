class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Name, email and message must not be empty
  validates :name, :email, presence: true

  # Regex validating a correct Email address (constant)
  EMAIL_REGEX = %r{\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\Z}.freeze

  # The email must follow the format specified by the regex
  validates :email, format: {with: EMAIL_REGEX, message: I18n.t('email_validation_feedback') }, uniqueness: true

  # A user may sent many emails
  has_many :sent_mails
  has_many :discussions, :class_name => 'Discussion', :foreign_key => 'owner_id', :dependent => :destroy

  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id', :dependent => :destroy
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'recipient_id', :dependent => :destroy

  has_many :events

  has_many :friendships
  has_many :accepted_friendships, -> {where status: 'accepted'}, :class_name => "Friendship"
  has_many :requested_friendships, -> {where status: 'requested'}, :class_name => "Friendship"
  def has_requested?(user_id, friend_id)
    friendships.find user_id, friend_id
  end
  has_many :pending_friendships, -> {where status: 'pending'}, :class_name => "Friendship"
  has_many :friends, :through => :accepted_friendships
  has_many :requested_friends, :through => :requested_friendships, :source => :friend
  has_many :pending_friends, :through => :pending_friendships, :source => :friend

  mount_uploader :image, ImageUploader
end

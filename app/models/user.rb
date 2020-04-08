class User < ApplicationRecord
  secret_key = Rails.application.credentials.key
  attr_encrypted :encrypted_date_of_birth, key: secret_key, marshal:true
  attr_encrypted :encrypted_is_female, key: secret_key, marshal:true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :is_signed_in, inclusion: [true, false]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
  after_create :notify_pusher

  # Name, email and message must not be empty
  validates :name, :email, presence: true

  # Regex validating a correct Email address (constant)
  EMAIL_REGEX = %r{\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\Z}.freeze

  # The email must follow the format specified by the regex
  validates :email, format: {with: EMAIL_REGEX, message: I18n.t('email_validation_feedback') }, uniqueness: true

  def notify_pusher # add this method
    Pusher.trigger('activity', 'login', self.as_json)
  end

  def as_json(options={}) # add this method
    super(
        only: [:id, :email]
    )
  end

  # A user may sent many emails
  has_many :sent_mails
  has_many :discussions, :class_name => 'Discussion', :foreign_key => 'owner_id', :dependent => :destroy

  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id', :dependent => :destroy
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'recipient_id', :dependent => :destroy

  has_many :events
  has_many :personal_messages, dependent: :destroy
  has_many :authored_conversations, class_name: 'Conversation', foreign_key: 'author_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'receiver_id'
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

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end
end

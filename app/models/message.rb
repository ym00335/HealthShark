class Message < ApplicationRecord
  validates :sender, :recipient, :content, presence: true

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  belongs_to :discussion, optional: true
end

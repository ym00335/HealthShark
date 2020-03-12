class Message < ApplicationRecord
  # Scope for finding the messages before a specific data and for (optional) a specific discussion
  scope :by_date_and_discussion_id, -> (date, discussion_id) {
    if discussion_id != nil
      where('created_at < ? AND discussion_id = ?', date, discussion_id).order(created_at: :asc)
    else
      where('created_at < ? AND discussion_id IS NULL', date).order(created_at: :asc)
    end
  }

  validates :sender, :recipient, :content, presence: true

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  belongs_to :discussion, optional: true # optional as it might be a global message
end

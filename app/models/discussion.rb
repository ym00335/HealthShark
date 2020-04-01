class Discussion < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :messages, :dependent => :destroy

  mount_uploader :image, ImageUploader
end

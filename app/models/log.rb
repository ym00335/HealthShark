class Log < ApplicationRecord
  belongs_to :user
  validates_presence_of :meal, :calories
end

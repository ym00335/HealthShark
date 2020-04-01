class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  def self.request(user, friend)
    sent = Friendship.where :status => 'pending'
    requested = Friendship.where :status => 'requested'
    unless user == friend && user.status == sent && friend.status == requested
      transaction do
        create(:user => user, :friend => friend, :status => 'pending')
        create(:user => friend, :friend => user, :status => 'requested')
      end
    end
  end

  def self.accept(user, friend)
    transaction do
      updated_at = Time.now
      accept_one_side(user, friend, updated_at)
      accept_one_side(friend, user, updated_at)
    end
  end

  def self.breakup(user, friend)
    friendship1 = Friendship.find_by(user_id: user, friend_id: friend)
    friendship2 = Friendship.find_by(user_id: friend, friend_id: user)
    friendship1.destroy
    friendship2.destroy
  end

  private
  def self.accept_one_side(user, friend, updated_at)
    request = find_by(user_id: user, friend_id: friend)
    request.status = 'accepted'
    request.updated_at = updated_at
    request.save!

  end
end

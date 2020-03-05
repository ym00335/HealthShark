class ChatController < ApplicationController
  before_action :authenticate_user!
  include ActionController::Live

  caches_action :index, expires_in: 1.minute

  def index
    @messages_count = Message.count
    @messages = Message.order(created_at: :asc).last(5)
  end

  def subscribe

  end


  def self.get_chat_image_url_from_user(user)
    if user.image.present?
      user.image.url
    else
      ActionController::Base.helpers.asset_url('default-user-img.png', type: :image)
    end
  end
end

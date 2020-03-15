class GlobalChatController < ApplicationController
  before_action :authenticate_user!
  include ActionController::Live


  def index
    # The count of all global chat messages
    @messages_count = Message.where("discussion_id IS NULL").count

    # The last 5 of the global chat messages
    @messages = Message.where("discussion_id IS NULL").order(created_at: :asc).last(5)
  end

  def subscribe
    # Needed for subscribing to the WebSocket Channel
  end


  def self.get_chat_image_path(user)
    # Get the path of a user image or the default one if the user does not hava an image
    if user.image.present?
      user.image.url
    else
      ActionController::Base.helpers.asset_url('default-user-img.png', type: :image)
    end
  end
end

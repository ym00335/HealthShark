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
end

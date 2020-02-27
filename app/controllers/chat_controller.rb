class ChatController < ApplicationController
  before_action :authenticate_user!
  include ActionController::Live


  def index
    @messages = Message.order(created_at: :asc).all
  end

  def subscribe

  end
end

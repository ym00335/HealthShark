class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, except: [:index]
  before_action :check_participating!, except: [:index]

  def index
    @conversations = Conversation.participating(current_user).order('updated_at DESC')
  end

  def show
    @personal_message = PersonalMessage.new

    @personal_messages = @conversation.personal_messages.where("conversation_id = ?", @conversation.id).order(created_at: :asc)

    @personal_messages_count = @conversation.personal_messages.count

  end

  private
    def set_conversation
      @conversation = Conversation.find_by(id: params[:id])
    end

    def check_participating!
      redirect_to root_path unless @conversation && @conversation.participates?(current_user)
    end
end
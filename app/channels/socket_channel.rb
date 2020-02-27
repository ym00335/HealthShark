class SocketChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def chat(data)
    message = Message.new(sender: current_user, recipient: current_user, content: data['message'])
    if message.save
      ActionCable.server.broadcast "chat", message_content: data['message'],
                                  user_name: message.sender.name, received_at: message.created_at.strftime("%T %d/%m/%y")
    end
  end
end

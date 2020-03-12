class SocketChannel < ApplicationCable::Channel
  def subscribed
    stream_from "global_chat"
    stream_from "get_previous_messages#{current_user.id}"
end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def global_chat(data)
    message = Message.new(sender: current_user, recipient: current_user, content: data['message'])
    if message.save
      ActionCable.server.broadcast "global_chat", message_content: data['message'], user_name: message.sender.name,
                                   user_image: GlobalChatController.get_chat_image_url(message.sender),
                                   action: "global_chat", received_at: message.created_at.strftime("%T %d/%m/%y")

    end
  end

  def get_previous_messages(data)
    messages = Message.where("created_at < ? AND discussion_id IS NULL", DateTime.strptime(data['before'], '%T %d/%m/%y')).order(created_at: :asc).last(5)

    dto = { action: "get_previous_messages", are_there_more: Message.where("created_at < ?",
                                                                         DateTime.strptime(data['before'], '%T %d/%m/%y'))
                                                                  .count > messages.length, messages: [] }
    messages.each do |message|
      obj = {message_content: message.content, user_name: message.sender.name,
             user_image: GlobalChatController.get_chat_image_url(message.sender),
             received_at: message.created_at.strftime("%T %d/%m/%y")}
      dto[:messages].push(obj)
    end
    ActionCable.server.broadcast "get_previous_messages#{current_user.id}", dto
  end
end

class SocketChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat"
    stream_from "getPreviousMessages_#{current_user.id}"
end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def chat(data)
    message = Message.new(sender: current_user, recipient: current_user, content: data['message'])
    if message.save
      ActionCable.server.broadcast "chat", message_content: data['message'], user_name: message.sender.name,
                                   received_at: message.created_at.strftime("%T %d/%m/%y"), action: "chat"
    end
  end

  def getPreviousMessages(data)
    messages = Message.where("created_at < ?", DateTime.strptime(data['before'], '%T %d/%m/%y')).order(created_at: :asc).last(5)

    dto = { action: "getPreviousMessages", are_there_more: Message.where("created_at < ?", 
                                                                         DateTime.strptime(data['before'], '%T %d/%m/%y'))
                                                                  .count > messages.length, messages: [] }
    messages.each do |message|
      obj = {message_content: message.content,
             user_name: message.sender.name, received_at: message.created_at.strftime("%T %d/%m/%y")}
      dto[:messages].push(obj)
    end
    ActionCable.server.broadcast "getPreviousMessages_#{current_user.id}", dto
  end
end

class SocketChannel < ApplicationCable::Channel
    def subscribed
    stream_from "global_chat" #global chat transmitted messages channel
    stream_from "discussion_chat#{params['discussion_id']}"  #discussion chat transmitted messages (specific discussino)
    stream_from "get_previous_global_messages#{current_user.id}" #request previous global messages (specific user)
    stream_from "get_previous_disc_messages#{current_user.id}" #request previous discussion messages (specific user)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def global_chat(data)
    # Create a new message in the database with the current user as both sender
    # and receiver
    message = Message.new(sender: current_user, recipient: current_user, content: data['message'])

    # try to save the message and if successful -> send to all listening users
    if message.save
      ActionCable.server.broadcast "global_chat", message_content: data['message'], user_name: message.sender.name,
             user_image: GlobalChatController.get_chat_image_path(message.sender),
             action: "global_chat", received_at: message.created_at.strftime("%T %d/%m/%y")

    end
  end

    def discussion_chat(data)
      # Create a new message in the database with the current user as both sender
      # and receiver and specific discussion id
      message = Message.new(sender: current_user, recipient: current_user,
                            discussion_id: data['discussion_id'], content: data['message'])

      # Try to save the message and if successful
      # resend to all users listening for the specific discussion
      if message.save
        ActionCable.server.broadcast "discussion_chat#{params['discussion_id']}", message_content: data['message'], user_name: message.sender.name,
                                     user_image: GlobalChatController.get_chat_image_path(message.sender),
                                     action: "discussion_chat", received_at: message.created_at.strftime("%T %d/%m/%y")

      end
    end

  def get_previous_global_messages(data)
    # get the 5 requested messages before the specific date
    messages = Message.by_date_and_discussion_id(DateTime.strptime(data['before'], '%T %d/%m/%y'), nil).last(5)

    # Create a data transfer object for the messages "packet"
    # If there are more messages -> set are_there_more flag so thet the arrow is displayed in front-end
    dto = { action: "get_previous_global_messages", are_there_more: Message
             .by_date_and_discussion_id(DateTime.strptime(data['before'], '%T %d/%m/%y'), nil)
             .count > messages.length, messages: [] }

    # Add all messages' content in the DTO
    messages.each do |message|
      obj = {message_content: message.content, user_name: message.sender.name,
             user_image: GlobalChatController.get_chat_image_path(message.sender),
             received_at: message.created_at.strftime("%T %d/%m/%y")}
      dto[:messages].push(obj)
    end

    # Broadcast the dto to the specific user
    ActionCable.server.broadcast "get_previous_global_messages#{current_user.id}", dto
  end

  def get_previous_disc_messages(data)
    # Extract all messages from the db before the date and for the specific discussion
    # and take only the last 5 of them
    messages = Message.by_date_and_discussion_id(DateTime.strptime(data['before'], '%T %d/%m/%y'),
             data['discussion_id']).last(5)

    # Create a Data Transfer Object to be transmitted via the Action Cable (WebSocket)
    dto = { action: "get_previous_disc_messages", are_there_more: Message
             .by_date_and_discussion_id(DateTime.strptime(data['before'], '%T %d/%m/%y'),
              data['discussion_id']).count > messages.length, messages: [] }

    # Add the contents for each message ands its owner
    messages.each do |message|
      obj = {message_content: message.content, user_name: message.sender.name,
             user_image: GlobalChatController.get_chat_image_path(message.sender),
             received_at: message.created_at.strftime("%T %d/%m/%y")}
      dto[:messages].push(obj)
    end

    # Broadcast the dto via the WebSocket
    ActionCable.server.broadcast "get_previous_disc_messages#{current_user.id}", dto
  end
end

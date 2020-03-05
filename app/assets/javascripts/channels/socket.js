$(document).ready(() => App.socket = App.cable.subscriptions.create("SocketChannel", {
    connected() {
    // Called when the subscription is ready for use on the server
    },

    disconnected() {
    // Called when the subscription has been terminated by the server
    },

    received(data) {
        // Check the type of action and perform it
        if (data.action === "chat"){
            addMessageContainerOnBottomChat(data, true);
        } else if (data.action === "get_previous_messages") {
            addMessageContainersOnTopOfChat(data.messages, data.are_there_more);//attachPreviousMessages(data);
        }

    },

    chat(message){
        this.perform("chat", { message: message });
    },

    getPreviousMessages(date){
        this.perform("get_previous_messages", { before: date });
    }

}));

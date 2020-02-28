$(document).ready(() => App.socket = App.cable.subscriptions.create("SocketChannel", {
    connected() {
    // Called when the subscription is ready for use on the server
    },

    disconnected() {
    // Called when the subscription has been terminated by the server
    },

    received(data) {
        if (data.action === "chat"){
            addMessageContainerOnBottomChat(data, true);
        } else if (data.action === "getPreviousMessages") {
            console.dir(data)
            addMessageContainersOnTopOfChat(data.messages, data.are_there_more);//attachPreviousMessages(data);
        }

    },

    chat(message){
        this.perform("chat", { message: message });
    },

    getPreviousMessages(date){
        this.perform("getPreviousMessages", { before: date });
    }

}));

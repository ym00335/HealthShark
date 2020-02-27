$(document).ready(() => App.socket = App.cable.subscriptions.create("SocketChannel", {
    connected: function() {
    // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
    // Called when the subscription has been terminated by the server
    },

    received: (data) => addMessageContainerInChat(data, true),

    chat: function(message) {
        return this.perform("chat", { message: message } );
    }

}));

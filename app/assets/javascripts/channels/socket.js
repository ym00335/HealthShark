App.socket = App.cable.subscriptions.create("SocketChannel", {
    connected: function() {
    // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
    // Called when the subscription has been terminated by the server
    },

    received: function(data) {
        console.dir(data)
        if ($("body").attr("data-username") === data.user_name) {
            $('#chat').append($('<div class="row justify-content-end mb-1">')
                .append($('<div class="message-sent col-xl-6 col-lg-7 col-md-8 col-sm-9">')
                    .text(data.message_content+ " sent by " + data.user_name + " on " + data.received_at)));
        } else {
            $('#chat').append($('<div class="row mb-1">')
                .append($('<div class="message-received col-xl-6 col-lg-7 col-md-8 col-sm-9">')
                    .text(data.message_content+ " sent by " + data.user_name + " on " + data.received_at)));
        }
        $("#chat").animate({ scrollTop: $('#chat').prop("scrollHeight")}, 1000);
    },

    chat: function(message) {
        return this.perform("chat", { message: message } );
    }

});

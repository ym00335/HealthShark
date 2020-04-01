$(document).ready(() => {
    const linkPaths = location.pathname.split('/');

    if (!((linkPaths.length === 2 && linkPaths[1] === 'global_chat') ||
        (linkPaths.length === 3 && linkPaths[1] === 'discussions' && linkPaths[2].match(/^\d+$/)))) {
        return;
    }

    // If the user is in a discussion - extract the discussion id by a hidden discussion-id input
    const discussion_id = $('#discussion-id');

    // Create a connection object
    let connection = {
        channel: "SocketChannel"
    };

    // If the message is for a discussion -> add the discussion_id to the socket
    // for the back-end to distinguish thet the message is for a discussion
    if (discussion_id.val()) {
        connection.discussion_id = discussion_id.val();
    }

    App.socket = App.cable.subscriptions.create(connection, {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            // Check the type of action and perform it, if the current page is the appropriate one
            if (data.action === "global_chat" && location.pathname.split('/').length === 2 && location.pathname.split('/')[1] === 'global_chat') {
                addMessageContainerOnBottomChat(data, true);
            } else if (data.action === "get_previous_global_messages") {
                addMessageContainersOnTopOfChat(data.messages, data.are_there_more);
            } else if (data.action === "discussion_chat") {
                addMessageContainerOnBottomChat(data, true, true);
            } else if (data.action === "get_previous_disc_messages") {
                addMessageContainersOnTopOfChat(data.messages, data.are_there_more);
            }

        },

        global_chat(message){
            this.perform("global_chat", { message: message });
        },

        getPreviousGlobalMessages(date){
            this.perform("get_previous_global_messages", { before: date });
        },

        discussion(message, discussion_id) {
            this.perform("discussion_chat", { message: message, discussion_id: discussion_id });
        },

        getPreviousDiscussionMessages(date, discussion_id) {
            this.perform("get_previous_disc_messages", { before: date, discussion_id: discussion_id });
        }

    })
});

/**
 * Add on click listeners for the Send Message button and on enter click for
 * the Message input field
 */
$(document).ready(() => {
    let $message = $('#message');
    let $sendMesssageBtn = $('#send-button');
    // Add onclick listener
    $sendMesssageBtn.click(sendMessage);

    // Add on enter binding
    $message.bind("enterKey",sendMessage);
    $message.keyup(function(e){
        if(e.keyCode === 13)
            $(this).trigger("enterKey");
    });

    /**
     * Send a message through the websocket
     * @param e
     */
    function sendMessage(e){
        if ($message.val()) {
            App.socket.chat($message.val());
        }
    }
});

/**
 * Add a message container on the bottom of the currently displayed ones.
 * @param message message object
 * @param shouldScroll do we have to scroll to the bottom of the chat container
 */
function addMessageContainerOnBottomChat(message, shouldScroll) {
    // Append the new message in the end of the chat with animation and a scrolling callback
    $('#chat').append(createChatMessage(message).hide().show(600, () => {
        if (shouldScroll) {
            // Scroll to the bottom with animation
            $("#chat").animate({ scrollTop: $('#chat').prop("scrollHeight")}, 1500);
        }
    }));
}

/**
 * Requests for more messages send in the past to be displayed to the user.
 */
function requestMoreMessages() {
    // Hide the arrow calling the method
    $('#up-arrow').hide();

    // Show the loader
    $('#loader-container').show();

    // Get the first displayed message
    const firstMessage = $("#chat").children()
        .filter((index, element) => element.classList.contains('message-box'))[0];

    // Get its date and send it through the socket
    const firstMessageDate = $(firstMessage).children()[1].firstChild.innerText;
    App.socket.getPreviousMessages(firstMessageDate);
}

/**
 * Add a message container on top of the currently displayed ones.
 * @param messages messages objects
 * @param are_there_more are there more in the server
 */
function addMessageContainersOnTopOfChat(messages, are_there_more) {
    for (const message of messages.reverse()) {
        // For each message -> create message container and prepend with animation
        createChatMessage(message).insertAfter($('#up-arrow')).hide().show('slow');
    }

    // Hide loading
    $('#loader-container').hide();

    // If there are more messages show to arrow-up
    if (are_there_more) {
        $('#up-arrow').show();
    }
}

/**
 * Create a chat message HTML fragment
 * @param message the message object
 * @returns {jQuery.fn.init|jQuery|HTMLElement} the newly created HTML fragment using jQuery
 */
function createChatMessage(message) {
    for (const key in message) {
        // Decode all encoded characters, because $.text will decode them again
        if (!message.hasOwnProperty(key)) continue;
        message[key] = htmlDecode(message[key]);
    }
    const $messageBox = $('<div class="row mb-2 message-box">');

    const $messageContentRow = $('<div class="col-12">');
    const $messageContent = $('<div class="col-lg-7 col-md-8 col-sm-9" style="margin-bottom: 0;">');
    $messageContent.text(message.message_content);
    $messageContentRow.append($messageContent);

    $messageBox.append($messageContentRow);

    const $dataContentRow = $('<div class="col-12">');
    const $dataContent = $('<div style="font-size: 10pt">').text(message.received_at);
    $dataContentRow.append($dataContent);

    $messageBox.append($dataContentRow);

    // Check whether the current user sent the message or they were the one who received it
    if ($("body").attr("data-username") === message.user_name) {
        $messageContent.addClass("float-right");
        $dataContent.addClass("float-right");
        $messageContent.addClass("message-sent")
            .append('<hr style="margin: 10px 0 0 0"/><small><img src="/send-by.png" height="25px" alt="sent by"> you</small>');
    } else {
        $messageContent.addClass("message-received")
            .append(`<hr style="margin: 10px 0 0 0"/><small><img src="/receive-by.png" height="25px" alt="receive by"> ${message.user_name}<small>`);
    }

    return $messageBox;
}


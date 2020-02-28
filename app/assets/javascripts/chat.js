// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

/*window.setInterval(function(){
    App.socket.chat();
}, 500);*/

$(document).ready(() => {
    let $message = $('#message');
    let $sendMesssageBtn = $('#send-button');
    $sendMesssageBtn.click(sendMessage);

    $message.bind("enterKey",sendMessage);
    $message.keyup(function(e){
        if(e.keyCode === 13)
            $(this).trigger("enterKey");
    });

    function sendMessage(e){
        if ($message.val()) {
            App.socket.chat($message.val());
        }
    }

    $("#chat").animate({ scrollTop: $('#chat').prop("scrollHeight")}, 1000);
});

function addMessageContainerOnBottomChat(data, shouldScroll) {
    for (var key in data) {
        if (!data.hasOwnProperty(key)) continue;
        data[key] = htmlDecode(data[key]);
    }
    const $messageBox = $('<div class="row mb-2">');

    const $messageContentRow = $('<div class="col-12">');
    const $messageContent = $('<div class="col-lg-7 col-md-8 col-sm-9" style="margin-bottom: 0;">');
    $messageContent.text(data.message_content);
    $messageContentRow.append($messageContent);

    $messageBox.append($messageContentRow);

    const $dataContentRow = $('<div class="col-12">');
    const $dataContent = $('<div style="font-size: 10pt">').text(data.received_at);
    $dataContentRow.append($dataContent);

    $messageBox.append($dataContentRow);

    if ($("body").attr("data-username") === data.user_name) {
        $messageContent.addClass("float-right");
        $dataContent.addClass("float-right");
        $messageContent.addClass("message-sent")
            .append('<hr style="margin: 10px 0 0 0"/><small><img src="/send-by.png" height="25px" alt="sent by"> you</small>');
    } else {
        $messageContent.addClass("message-received")
            .append(`<hr style="margin: 10px 0 0 0"/><small><img src="/receive-by.png" height="25px" alt="receive by"> ${data.user_name}<small>`);
    }

    $('#chat').append($messageBox);
    if (shouldScroll) {
        $("#chat").animate({ scrollTop: $('#chat').prop("scrollHeight")}, 100);
    }
}

function requestMoreMessages(arrow) {
    $('#up-arrow').hide();
    $('#loader-container').show();
    const firstMessage = $("#chat").children()
        .filter((index, element) => element.id !== "up-arrow" && element.id !== "loader-container"
            && element.type !== "text/javascript")[0];
    const firstMessageDate = $(firstMessage).children()[1].firstChild.innerText;
    App.socket.getPreviousMessages(firstMessageDate);
}

function addMessageContainersOnTopOfChat(messages, are_there_more) {
    for (const message of messages.reverse())
    {
        for (const key in message) {
            if (!message.hasOwnProperty(key)) continue;
            message[key] = htmlDecode(message[key]);
        }
        const $messageBox = $('<div class="row mb-2">');

        const $messageContentRow = $('<div class="col-12">');
        const $messageContent = $('<div class="col-lg-7 col-md-8 col-sm-9" style="margin-bottom: 0;">');
        $messageContent.text(message.message_content);
        $messageContentRow.append($messageContent);

        $messageBox.append($messageContentRow);

        const $dataContentRow = $('<div class="col-12">');
        const $dataContent = $('<div style="font-size: 10pt">').text(message.received_at);
        $dataContentRow.append($dataContent);

        $messageBox.append($dataContentRow);

        if ($("body").attr("data-username") === message.user_name) {
            $messageContent.addClass("float-right");
            $dataContent.addClass("float-right");
            $messageContent.addClass("message-sent")
                .append('<hr style="margin: 10px 0 0 0"/><small><img src="/send-by.png" height="25px" alt="sent by"> you</small>');
        } else {
            $messageContent.addClass("message-received")
                .append(`<hr style="margin: 10px 0 0 0"/><small><img src="/receive-by.png" height="25px" alt="receive by"> ${message.user_name}<small>`);
        }

        $messageBox.insertAfter($('#up-arrow'));
    }

    $('#loader-container').hide();

    if (are_there_more) {
        $('#up-arrow').show();
    }
}


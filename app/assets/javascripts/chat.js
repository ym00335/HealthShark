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


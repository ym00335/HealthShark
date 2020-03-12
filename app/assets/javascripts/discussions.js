// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
/**
 * Add on click listeners for the Send Message button and on enter click for
 * the Message input field
 */
$(document).ready(function()  {
    let $message = $('#message');
    let $sendMesssageBtn = $('#send-button');
    // Add onclick listener
    $sendMesssageBtn.click(sendMessage);

    // Add on enter binding
    $message.bind("enterKey", sendMessage);
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
            //App.socket.discussion(, $message.val());
            $message.val("");
        }
    }
});
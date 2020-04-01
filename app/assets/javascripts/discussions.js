/**
 * Add on click listeners for the Send Message button and on enter click for
 * the Message input field
 */
$(document).ready(function()  {
    // If it is not for the discussions -> return
    const linkPaths = location.pathname.split('/');

    if (!(linkPaths.length === 3 && linkPaths[1] === 'discussions' && linkPaths[2].match(/^\d+$/))) {
        return;
    }

    let $message = $('#message');
    let $sendMesssageBtn = $('#send-button');

    // Add onclick listener for the button to send the message
    $sendMesssageBtn.click(sendMessage);

    // Add on enter binding to send the message
    $message[0].addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });

    /**
     * Send a message through the websocket for the specific discussion
     */
    function sendMessage(){
        if ($message.val()) {
            App.socket.discussion($message.val(), $('#discussion-id').val());
            $message.val("");
        }
    }
});
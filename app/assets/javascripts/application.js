// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require bootstrap-sprockets
//= require cookiealert
//= require jquery_ujs
//= require_tree .

$(document).ready(() => {
    //Show cookie notice.
    showCookieNotice();

    // Remove alerts after 2 seconds
    window.setTimeout(function() {
        $alerts = $(".alert").filter((index, element) => {
            return !element.classList.contains('cookiealert');
        });

        $alerts.fadeTo(500, 0).slideUp(500, function(){
            $(this).remove();
        });
    }, 2000);

    //Set current navigation link on header
    $('ul li[controller=' + location.pathname.split("/")[1] + '] a')[0].classList.add('active')
});

// Validates notebook, note and quick_note in the Front-end
function validateForm() {
    // Extract the values of the form elements
    let currentPath = location.pathname.split("/")[1];
    currentPath = currentPath.substring(0, currentPath.length - 1)

    const title = $(`#${currentPath}_title`).val();
    let content;

    // Because the content column in notebooks is called description.
    if($(`#${currentPath}_content`).length){
        content = $(`#${currentPath}_content`).val();
    } else if($(`#${currentPath}_description`).length){
        content = $(`#${currentPath}_description`).val();
    }
    
    let isCorrect = true;

    // Specify the errors in the front end
    if (!title) {
        $('#title-error').text('Title must not be empty!');
        isCorrect = false;
    } else {
        $('#title-error').text('');
    }

    if(!content || typeof content === "undefined") {
        $('#content-error').text('Content must not be empty!');
        isCorrect = false;
    } else {
        $('#content-error').text('');
    }

    // Either submit the form or make the button clickable after half a second.
    if (isCorrect) {
        $('form')[0].submit();
    } else{
        $('.invalid-feedback').css('display', 'block');
        setTimeout(() =>{
            $('input[type=submit]').removeAttr('disabled');
        }, 500);
    }

    return isCorrect;
}

function addMessageContainerInChat(data) {
    let $messageBox = $('<div class="row mb-2">');

    let $messageContentRow = $('<div class="col-12">');
    let $messageContent = $('<div class="col-lg-7 col-md-8 col-sm-9" style="margin-bottom: 0;">');
    $messageContent.text(data.message_content);

    $messageContentRow.append($messageContent);

    $messageBox.append($messageContentRow);

    let $dataContentRow = $('<div class="col-12">');
    let $dataContent = $('<div style="font-size: 10pt">').text(data.received_at);
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
    $("#chat").animate({ scrollTop: $('#chat').prop("scrollHeight")}, 1000);
}





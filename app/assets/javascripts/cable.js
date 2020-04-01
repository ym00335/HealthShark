// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

/**
 * Creates the WebSocket objects
 */
(function () {
    this.App || (this.App = {});

    const linkPaths = location.pathname.split('/');

    if (!((linkPaths.length === 2 && linkPaths[1] === 'global_chat') ||
        (linkPaths.length === 3 && linkPaths[1] === 'discussions' && linkPaths[2].match(/^\d+$/)))) {
        return;
    }

    App.cable = ActionCable.createConsumer('/chatcable');

}).call(this);

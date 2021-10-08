import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('ok')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
   console.log(data)
    $('#icon-badge-'+data.receiver_id).html("")
    $('#icon-badge-'+data.receiver_id).append(data.count)

  }
});

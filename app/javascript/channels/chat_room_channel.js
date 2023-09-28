import consumer from "channels/consumer";

export default function createRoom({ connected, disconnected, received }) {
  return consumer.subscriptions.create("ChatRoomChannel", {
    connected() {
      if (connected) {
        connected();
      } else {
        // Called when the subscription is ready for use on the server
        console.log("connected");
      }
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (received) {
        received(JSON.stringify(data));
      } else {
        // Called when there's incoming data on the websocket for this channel
        console.warn("received data");
      }
    },

    sendMessage(messageBody) {
      this.perform("foobar", messageBody);
    },
  });
}

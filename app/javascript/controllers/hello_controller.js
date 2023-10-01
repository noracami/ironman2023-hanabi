import { Controller } from "@hotwired/stimulus";
import chat_room_channel from "channels/chat_room_channel";
import {
  receivedFromUser,
  receivedFromWorld,
} from "controllers/receive_wrapper";

export default class extends Controller {
  static targets = ["title"];

  connect() {
    this.titleTarget.textContent = "hello controller loaded";
    this.channel = chat_room_channel({
      connected: this.connected.bind(this),
      received: this.received.bind(this),
    });
  }

  connected() {}

  received(data) {
    const { message, uuid, role, nickname } = JSON.parse(data);
    if (role === null || role === undefined) {
      console.warn("role is missing");
      return;
    }

    let insertElement;

    switch (role) {
      case "player":
        insertElement = receivedFromUser({ message, uuid, nickname });
        break;

      case "lobby":
        insertElement = receivedFromWorld(message);
        break;

      default:
        break;
    }

    this.element.insertAdjacentElement("beforeend", insertElement);
  }

  sendMessage(messageBody) {
    this.channel.sendMessage(messageBody);
  }

  ping_the_room() {
    this.sendMessage({
      nickname: "Paul",
      body: "This is a cool chat app.",
    });
  }

  join_the_room({ params: { roomId } }) {
    this.channel.joinGame({
      nickname: "Paul",
      roomId,
    });
  }
}

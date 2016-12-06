<template>
  <div class="my-app">
    <h1>Vuechat</h1>
    <ul v-for="message in messages">
      <li>
        <small>{{message.received_at}}</small>: {{message.body}}
      </li>
    </ul>
    <input type="text" v-model="message" v-on:keyup.13="sendMessage">
  </div>
</template>

<script>
import {Socket} from "phoenix"
export default {
  data() {
    return {
      socket: null,
      channel: null,
      messages: [],
      message: ""
    }
  },
  methods: {
    sendMessage() {
      this.channel.push("new_msg", { body: this.message })
      this.message = ''
    },
    connectToChat() {
      this.socket = new Socket("/socket", {params: {token: window.userToken}}),
      this.socket.connect()

      this.channel = this.socket.channel("room:lobby", {});
      this.channel.on("new_msg", payload => {
        payload.received_at = Date();
        this.messages.push(payload);
      });

      this.channel.join()
        .receive("ok", response => { console.log("Joined successfully", response) })
        .receive("error", response => { console.log("Unable to join", response) })
    }
  }
}
</script>

<style lang="sass">
.my-app {
  margin-left: auto;
  margin-right: auto;

  width: 800px;
  h1 {
    text-align: center;
  }
}
</style>

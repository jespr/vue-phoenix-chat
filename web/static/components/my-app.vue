<template>
  <div class="my-app">
    <h1>Vuechat</h1>
    <div class="user-details" v-if="enterName">
      <label>Please enter your name:</label><br>
      <input type="text" v-model="username">
      <button v-on:click="connectToChat">Next</button>
    </div>
    <div class="messages" v-else>
      <ul v-for="message in messages">
        <li>
          <small>{{message.received_at}}</small>: <strong>{{message.username}}</strong>: {{message.body}}
        </li>
      </ul>
      <strong>{{username}}:</strong><br/>
      <input type="text" v-model="message" v-on:keyup.13="sendMessage">
    </div>
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
      message: "",
      username: "",
      enterName: true
    }
  },
  methods: {
    sendMessage() {
      this.channel.push("new_msg", { body: this.message })
      this.message = ''
    },
    connectToChat() {
      this.enterName = false
      this.socket = new Socket("/socket", {params: {username: this.username}}),
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

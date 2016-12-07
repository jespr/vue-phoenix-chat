<template>
  <div class="my-app">
    <h1>Vuechat</h1>
    <div class="user-details" v-if="enterName">
      <label>Please enter your name:</label><br>
      <input type="text" v-model="username">
      <button v-on:click="connectToChat">Next</button>
    </div>
    <div class="messages" v-else>
      Online users:
      <ul v-for="user in users">
        <li>
          {{user.user}} ({{user.online_at}})
        </li>
      </ul>
      Messages:
      <ul v-for="message in messages">
        <li>
          <small>{{message.received_at}}</small>: <strong>{{message.username}}</strong>: {{message.body}}
        </li>
      </ul>
      <p>
        <strong>{{username}}:</strong><br/>
        <input type="text" placeholder="What do you have to say?" v-model="message" v-on:keyup.13="sendMessage">
      </p>
    </div>
  </div>
</template>

<script>
import {Socket, Presence} from "phoenix"
export default {
  data() {
    return {
      socket: null,
      channel: null,
      messages: [],
      message: "",
      username: "",
      enterName: true,
      users: []
    }
  },
  methods: {
    sendMessage() {
      this.channel.push("new_msg", { body: this.message })
      this.message = ''
    },
    connectToChat() {
      let presences = {}
      this.enterName = false
      this.socket = new Socket("/socket", {params: {username: this.username}}),
      this.socket.connect()

      this.channel = this.socket.channel("room:lobby", {});
      this.channel.on("new_msg", payload => {
        payload.received_at = Date();
        this.messages.push(payload);
      });

      this.channel.on("presence_state", state => {
        presences = Presence.syncState(presences, state)
        this.assignUsers(presences)
      })

      this.channel.on("presence_diff", diff => {
        presences = Presence.syncDiff(presences, diff)
        this.assignUsers(presences)
      })

      this.channel.join()
        .receive("ok", response => { console.log("Joined successfully", response) })
        .receive("error", response => { console.log("Unable to join", response) })
    },
    assignUsers(presences) {
      let formatTimestamp = (timestamp) => {
        timestamp = parseInt(timestamp)
        let date = new Date(timestamp)
        return date.toLocaleTimeString()
      }
      this.users = Presence.list(presences, (user, {metas: metas}) => {
        return { user: user, online_at: formatTimestamp(metas[0].online_at) }
      })
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

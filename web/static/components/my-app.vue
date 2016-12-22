<template>
  <div class="my-app">
    <div class="user-details" v-if="enterName">
      <h1>Vuechat</h1>
      <label>Please enter your name:</label><br>
      <input type="text" v-model="username">
      <button v-on:click="connectToChat">Next</button>
    </div>
    <div id="main-container" v-else>
      <div id="users-list">
        <h3>Online</h3>
        <ul>
          <transition-group name="user-appear">
            <li v-for="user in users" v-bind:key="user.user">
              {{user.user}} ({{user.online_at}})
            </li>
          </transition-group>
        </ul>
      </div>
      <div id="messages-list">
        <ul>
          <transition-group name="message-appear">
            <li v-for="message in messages" v-bind:key="message">
              <div class="message-metadata">
                <span class="username">{{message.username}}</span>
                <span class="received-at">{{message.received_at}}</span>
              </div>

              {{message.body}}
            </li>
          </transition-group>
        </ul>
      </div>
      <div id="your-message">
        <input type="text" placeholder="What do you have to say?" v-model="message" v-on:keyup.13="sendMessage">
      </div>
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
  h1 {
    text-align: center;
  }

  #main-container {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    display: flex;
    overflow: hidden;
  }

  #users-list {
    background-color: #008bdf;
    width: 250px;
    height: 100vh;
    overflow-y: scroll;

    h3 {
      font-size: 0.9em;
      margin-left: 10px;
      color: rgba(255, 255, 255, 0.7);
    }

    ul {
      list-style: none;
      padding-left: 20px;
      color: rgba(255, 255, 255, 0.9);

      li {
        &.user-appear-enter-active, &.user-appear-leave-active {
          transition: all .2s
        }

        &.user-appear-enter, &.user-appear-leave-active {
          opacity: 0;
          transform: translateX(-15px);
        }
      }
    }
  }

  #messages-list {
    padding-top: 20px;
    padding-left: 20px;
    overflow-y: scroll;
    flex: 1;

    ul {
      list-style: none;
      padding: 0;

      li {
        padding: 5px 0;

        &.message-appear-enter-active, &.message-appear-leave-active {
          transition: all .2s
        }

        &.message-appear-enter, &.message-appear-leave-active {
          opacity: 0;
          transform: translateY(20px);
        }

        .message-metadata {
          .username {
            font-weight: bold;
          }

          .received-at {
            color: rgba(0, 0, 0, 0.4);
            margin-left: 5px;
            font-size: 0.9em;
          }
        }
      }
    }
  }

  #your-message {
    position: fixed;
    bottom: 0;
    left: 250px;
    right: 0;
    background: rgba(255, 255, 255, 0.95);
    padding: 15px;

    input {
      width: 100%;
      padding: 5px 8px;
      border-radius: 3px;
      outline: 0;
      border: 1px solid #ddd;
    }
  }
}
</style>

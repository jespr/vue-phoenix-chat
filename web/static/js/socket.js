import {Socket} from "phoenix"
import Vue from 'vue'
import MyApp from "../components/my-app.vue"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Create the main component
Vue.component('my-app', MyApp)

// And create the top-level view model:

new Vue({
  el: '#app',
  mounted() {
    this.channel = socket.channel("room:lobby", {});
    this.channel.on("new_msg", payload => {
      payload.received_at = Date();
      this.messages.push(payload);
    });

    this.channel.join()
      .receive("ok", response => { console.log("Joined successfully", response) })
      .receive("error", response => { console.log("Unable to join", response) })
  },
  data() {
    return {
      channel: null,
      messages: []
    }
  },
  render(createElement) {
    return createElement(MyApp, {})
  }
});

export default socket

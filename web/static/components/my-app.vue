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
export default {
  data() {
    return {
      message: ""
    }
  },
  computed: {
    messages() {
      return this.$parent.messages
    }
  },
  methods: {
    sendMessage() {
      this.$parent.channel.push("new_msg", { body: this.message })
      this.message = ''
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

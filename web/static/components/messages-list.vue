<template>
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
</template>

<script>
export default {
  computed: {
    messages() {
      return this.$store.state.messages
    }
  }
}
</script>

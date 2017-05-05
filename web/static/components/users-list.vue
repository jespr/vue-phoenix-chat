<template>
  <div id="users-list">
    <h3>Online</h3>
    <ul>
      <transition-group name="user-appear">
        <li v-for="user in users" v-bind:key="user.name">
          {{user.name}} ({{user.online_at}})
        </li>
      </transition-group>
    </ul>
  </div>
</template>

<script>
export default {
  computed: {
    users() {
      let formatTimestamp = (timestamp) => {
        timestamp = parseInt(timestamp)
        let date = new Date(timestamp)
        return date.toLocaleTimeString()
      }
      return this.$store.state.users.map(function(user) {
        return { name: user.name, online_at: formatTimestamp(user.online_at) }
      })
    }
  }
}
</script>

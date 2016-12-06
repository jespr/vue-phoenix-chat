import "phoenix_html"
import Vue from 'vue'
import MyApp from "../components/my-app.vue"

Vue.component('my-app', MyApp)

new Vue({
  el: '#app',
  render(createElement) {
    return createElement(MyApp, {})
  }
});


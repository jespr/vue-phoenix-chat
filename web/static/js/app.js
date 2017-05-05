import "phoenix_html"
import Vue from 'vue'
import MyApp from "../components/my-app.vue"
import store from "./store.js"

// Create the main component
Vue.component('my-app', MyApp)

// And create the top-level view model:
new Vue({
  el: '#app',
  store,
  render(createElement) {
    return createElement(MyApp, {})
  }
});


import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/main.css'
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome"
import { library } from "@fortawesome/fontawesome-svg-core"
import { faHeart } from "@fortawesome/free-solid-svg-icons"

library.add(faHeart)
// Vue.jsアプリが動くときに、このmain.jsが最初に読み込まれます。
// Vueインスタンスが生成
createApp(App).use(router).component("font-awesome-icon", FontAwesomeIcon).mount('#app')



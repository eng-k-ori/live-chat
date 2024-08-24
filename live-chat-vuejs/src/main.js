import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

// Vue.jsアプリが動くときに、このmain.jsが最初に読み込まれます。
// Vueインスタンスが生成
createApp(App).use(router).mount('#app')

import { createRouter, createWebHistory } from 'vue-router'
import Welcome from '@/views/Welcome.vue'
import Chatroom from '@/components/Chatroom.vue'

const routes = [
  {
    // /にアクセスすると、Welcome.vueが表示
    path: '/',
    // ページの名前。他のページからこの/にリダイレクトさせたい時などに必要になります。
    name: 'Welcome',
    component: Welcome
  },
  {
    path: '/chatroom',
    name: 'Chatroom',
    component: Chatroom
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router

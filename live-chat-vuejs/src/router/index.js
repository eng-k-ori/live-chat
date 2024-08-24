import { createRouter, createWebHistory } from 'vue-router'
import Welcome from '@/views/Welcome.vue'

const routes = [
  {
    // /にアクセスすると、Welcome.vueが表示
    path: '/',
    name: 'Welcome',
    component: Welcome
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router

<template>
  <div>
    <h2>ログイン</h2>
    <form @submit.prevent="login">
      <!-- v-model:データと入力フォームの内容を連動 -->
      <input type="email" required placeholder="メールアドレス" v-model="email">
      <input type="password" required placeholder="パスワード" v-model="password">
      <div class="error">{{ error }}</div>
      <button>ログインする</button>
    </form>
    Eメール：{{ email }}
  </div>
</template>

<script>
import axios from 'axios'

export default {
  emits: ['redirectToChatRoom'],
  data () {
    return {
      email: '',
      password: '',
      error: null
    }
  },
  methods: {
    async login() {
      try {
        this.error = null
        const res = await axios.post('http://localhost:3001/auth/sign_in', {
          email: this.email,
          password: this.password,
          }
        )
        if (!res) {
          throw new Error('メールアドレスかパスワードが違いますよ')
        }
        if (!this.error) {
          this.$emit('redirectToChatRoom')
        }
        console.log({ res })
        return res
      } catch (error) {
        console.log({ error })
        this.error = 'メールアドレスかパスワードが違います'
      }
    }
  }
}
</script>

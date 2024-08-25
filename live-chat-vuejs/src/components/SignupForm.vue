<!-- ======= 👇 ここから追加する ======= -->
<template>
  <div>
    <h2>アカウントを登録</h2>
    <form @submit.prevent="signUp">
      <input type="text" required placeholder="名前" v-model="name">
      <input type="email" required placeholder="メールアドレス" v-model="email">
      <input type="password" required placeholder="パスワード" v-model="password">
      <input type="password" required placeholder="パスワード（確認用）" v-model="passwordConfirmation">
      <div class="error">{{ error }}</div>
      <button>登録する</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios'
import setItem from '../auth/setItem'

export default {
  emits: ['redirectToChatRoom'],
  data () {
    return {
      name: '',
      email: '',
      password: '',
      passwordConfirmation: '',
      error: null
    }
  },
  methods: {
    async signUp () {
      try {
        const res = await axios.post('http://localhost:3001/auth', {
          name: this.name,
          email: this.email,
          password: this.password,
          password_confirmation: this.passwordConfirmation
          }
        )
        // APIリクエストが成功したが、期待したレスポンスが返ってこなかった場合にエラーを投げる
        if (!res) {
          throw new Error('アカウントを登録できませんでした（resなし）')
        }
        if (!this.error) {
          setItem(res.headers, res.data.data.name)
          this.$emit('redirectToChatRoom')
        }
        console.log({ res })
        return res
      // tryブロック内で発生するすべてのエラーをキャッチして処理する。
      } catch (error) {
        this.error = 'アカウントを登録できませんでした'
      }
    }
  }
}
</script>
<!-- ======= 👆 ここまで追加する ======= -->

<!-- /*
@          @@          @@          @@          @@          @@          @@          @@          @
1
この部分は、tryブロック内で発生するすべてのエラーをキャッチして処理する。例えば、ネットワークエラー、サーバーがダウ
ンしている、またはthrow new Errorで投げられたエラーなどが該当する。
catchブロックでエラーメッセージを設定し、ユーザーにエラー情報を表示する。
------------------------------------------------------------------------------------------------
if (!res)はレスポンスの内容そのものをチェックしているが、catch (error)は全体的なエラー処理を行う。
================================================================================================
throw new Error('アカウントを登録できませんでした（resなし）')が発火すると、このエラーメッセージ自体は
JavaScriptのエラーオブジェクトとして作成され、catch (error)ブロックでキャッチされる。
しかし、catch (error)ブロックでは、このエラーオブジェクトの内容をそのままユーザーに表示するのではなく、
this.errorに'アカウントを登録できませんでした'という汎用的なエラーメッセージをセットしている。その結果、実際にユー
ザーに表示されるのは、throw new Errorで投げられたメッセージではなく、catchブロック内で設定されたエラーメッセージ
となる。
*/ -->

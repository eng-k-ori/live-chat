<template>
  <form>
    <!-- Enterキーが押されたらhandleSubmitメソッドが実行。.preventは、Enterキーを押すと画面がリロードしてしまうため、それを防ぐために追加 -->
    <textarea
      placeholder="メッセージを入力してEnterを押してください"
      v-model="message"
      @keypress.enter.prevent="handleSubmit"
    ></textarea>
  </form>
</template>

<script>
export default {
  // handleSubmit内ではChatroom.vueのconnectCableというメソッドを実行
  emits: ['connectCable'],
  data () {
    return {
      message: ''
    }
  },
  methods: {
    handleSubmit () {
      // 1
      this.$emit('connectCable', this.message)
      // 入力されたメッセージを初期化
      this.message = ''
    }
  }
}
</script>

<style scoped>
  form {
    margin: 10px;
  }
  textarea {
    width: 100%;
    max-width: 100%;
    margin-bottom: 6px;
    padding: 10px;
    box-sizing: border-box;
    border: 0;
    border-radius: 20px;
    font-family: inherit;
    outline: none;
  }
</style>

<!-- /*
@          @@          @@          @@          @@          @@          @@          @@          @
1
親コンポーネントのメソッドを実行することができる$emitメソッドは、第２引数でデータを渡すことができます。
今回は入力されたメッセージを親コンポーネントのChatroom.vueに送りたいので、this.messageを渡しています。
*/ -->
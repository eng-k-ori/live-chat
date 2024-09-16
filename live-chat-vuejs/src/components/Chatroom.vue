<template>
  <div class="container">
      <Navbar />
      <!-- ChatWindow.vueにmessagesを渡す -->
      <ChatWindow @connectCable="connectCable" :messages="messages" />
      <!-- connectCableを実行できるように@connectCable="connectCable"を追加 -->
      <NewChatForm @connectCable="connectCable" />
  </div>
</template>

<script>
import Navbar from '../components/Navbar'
import ChatWindow from '../components/ChatWindow'
import NewChatForm from '../components/NewChatForm'
import axios from 'axios'
// Vue.jsでAction Cableを使用するためのライブラリ
import ActionCable from 'actioncable'


export default {
  // components:で、どの子コンポーネントがテンプレート内で使えるかを指定。インポートされたモジュールをVueに教える。
  components: { Navbar, ChatWindow, NewChatForm },
  data () {
    return {
      // dataプロパティでmessages（オブジェクトが複数入る配列）を定義
      messages: [],
    }
  },
  methods: {
    async getMessages () {
      try {
        const res = await axios.get('http://localhost:3001/messages', {
          headers: {
            uid: window.localStorage.getItem('uid'),
            "access-token": window.localStorage.getItem('access-token'),
            client:window.localStorage.getItem('client')
          }
        })
        if (!res) {
          new Error('メッセージ一覧を取得できませんでした')
        }
        // レスポンスをmessagesに代入
        this.messages = res.data
      } catch (err) {
        console.log(err)
      }
    },
    // 子コンポーネントからmessageデータが引数として渡されてきます。
    connectCable (message) {
      // this.messageChannelと接続し、Railsのreceiveメソッドを実行するように指定
      this.messageChannel.perform('receive', {
        message: message,
        email: window.localStorage.getItem('uid')
      })
    },
  },
  // 1
  mounted() {
    // Ruby on RailsのAction Cableとコネクションを確立
    const cable = ActionCable.createConsumer('ws://localhost:3001/cable')
    // RoomChannelという名前のチャンネルと常時接続状態
    this.messageChannel = cable.subscriptions.create('RoomChannel', {
      // Action CableのChannelとのコネクションが確立したときに実行したいメソッドを記述
      connected: () => {
        this.getMessages()
      },
      // Action Cableから何らかのデータが送られてきた時に実行するメソッド
      received: () => {
        this.getMessages()
      }
    })
  },
  // 「インスタンスが削除される（「ページを移動したり、ブラウザを閉じる時」）前」に実行されるメソッド
  beforeUnmount () {
    // コネクションを削除
    this.messageChannel.unsubscribe()
  },
}
</script>

<style scoped>
</style>

<!-- /*
@          @@          @@          @@          @@          @@          @@          @@          @
1
mounted
Vue.jsの「ライフサイクルフック」の一つです。「ライフサイクル」とはブラウザ画面が表示されるまでの過程のことだと考え
てください。「ライフサイクルフック」は、ライフサイクルの過程でそれぞれ呼び出されるメソッドのことです。
------------------------------------------------------------------------------------------------
ライフサイクルフックにはcreated、mounted、beforeMount、beforeUnmountなどがあり、それぞれのライフサイクルフッ
クは実行されるタイミングが異なります。
mountedの場合は、ページが読み込まれHTMLが表示される直前に実行されるメソッドです。
------------------------------------------------------------------------------------------------
今回はメッセージ一覧取得のメソッドgetMessagesをページが表示される直前に実行させたいため、mounted内に記載していま
す。

*/ -->
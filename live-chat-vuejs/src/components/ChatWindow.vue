<!-- template部分では、Vue.jsがexport defaultで定義されたデータ（propsやdata）を使用して、HTMLを生成・描画する。 -->
<template>
  <div class="chat-window">
    <div v-if="messages" class="messages">
      <ul v-for="message in messages" :key="message.id">
        <!-- 1 動的にclass内の文字を変更 -->
        <li :class="{ received: message.email !== uid, sent: message.email === uid }">
          <span class="name">{{ message.name }}</span>
          <!-- どのメッセージがダブルクリックされたのかをメッセージのIDを引数として渡す -->
          <div class="message" @dblclick="handleLike(message)">
            {{ message.content }}
            <!-- メッセージの後ろにいいねの数を表示 messageのlikesが0個より大きい数字であれば表示する-->
            <div v-if="message.likes.length" class="heart-container">
              <!-- ハートアイコンを表示するフォント -->
              <font-awesome-icon icon="heart" class="heart" />
              <span class="heart-count">{{ message.likes.length }}</span>
            </div>
          </div>
          <span class="created-at">{{ message.created_at }}前</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

// export default の中に定義された props や data は、template 内で使われるデータの元となっている
export default {
  // ChatWindowでも親コンポーネントChatroomのメソッドconnectCableが使用できる
  emits: ['connectCable'],
  // 親コンポーネントからデータを受け取るにはpropsを使用します
  props: ['messages'],
  data () {
    return {
      uid: localStorage.getItem('uid')
    }
  },
  methods: {
    handleLike (message) {
      for (let i = 0; i < message.likes.length; i++) {
        const like = message.likes[i]
        // likeがもつemailとuidが一緒かどうか比較
        if (like.email === this.uid) {
          this.deleteLike(like.id)
          return
        }
      }
      this.createLike(message.id)
    },
    async createLike (messageId) {
      try {
        // 1
        const res = await axios.post(`http://localhost:3001/messages/${messageId}/likes`, {},
          {
            headers: {
              uid: this.uid,
              "access-token": window.localStorage.getItem('access-token'),
              client: window.localStorage.getItem('client')
            }
          })

        if (!res) {
          new Error('いいねできませんでした')
        }
        this.$emit('connectCable')
      } catch (error) {
        console.log(error)
      }
    },
    async deleteLike(likeId) {
      try {
        const res = await axios.delete(`http://localhost:3001/likes/${likeId}`,
          {
            headers: {
              uid: this.uid,
              "access-token": window.localStorage.getItem('access-token'),
              client: window.localStorage.getItem('client')
            }
          })

        if (!res) {
          new Error('いいねを削除できませんでした')
        }
        this.$emit('connectCable')
      } catch (error) {
        console.log(error)
      }
    },
  },
}
</script>

<style scoped>
  .chat-window {
    background: white;
    padding: 30px 20px;
    border-bottom: 1px solid #eee;
  }
  ul {
    list-style: none;
    margin: 0;
    padding: 0;
  }
  ul li {
    display:inline-block;
    clear: both;
  }
  .received .message {
    background: #eee;
    padding: 10px;
    display: inline-block;
    border-radius: 30px;
    margin-bottom: 2px;
    max-width: 400px;
  }
  .received {
    float: left;
  }
  .sent {
    float: right;
  }
  .sent .message {
    background: #677bb4;
    color: white;
    padding: 10px;
    display: inline-block;
    border-radius: 30px;
    margin-bottom: 2px;
    max-width: 400px;
  }
  .name {
    position: relative;
    margin-right: 6px;
    display: block;
    font-size: 13px;
  }
  .created-at {
    display: block;
    color: #999;
    font-size: 12px;
    margin-bottom: 20px;
    margin-left: 4px;
  }
  .messages {
    max-height: 400px;
    overflow: auto;
  }
  .message {
    position: relative;
  }

  .heart-container {
    background: white;
    position: absolute;
    display: flex;
    justify-content: space-around;
    align-items: center;
    border-radius: 30px;
    min-width: 25px;
    border-style: solid;
    border-width: 1px;
    border-color: rgb(245, 245, 245);
    padding: 1px 2px;
    z-index: 2;
    bottom: -7px;
    right: 0px;
    font-size: 9px;
  }
  .heart {
    color: rgb(236, 29, 29);
  }
  .heart-count {
    color: rgb(20, 19, 19);
  }
  .received .message::selection {
    background: #eee;
  }
  .sent .message::selection {
    background: #677bb4;
  }
</style>

<!-- /*
@          @@          @@          @@          @@          @@          @@          @@          @
1
const res = await axios.post(`http://localhost:3000/messages/${messageId}/likes`, {},
なぜ空のオブジェクトが記述されているのでしょうか？
これは 「POSTメソッドの時にヘッダー情報を付与するときは第３引数にする」 というAxiosの仕様があるためです。
もし空のオブジェクトを削除し第２引数としてそのままヘッダー情報を記述すると、Axiosに「これは第２引数なのでパラメタ情
報だ。第３引数がないのでヘッダー情報は付与されていない。」と判断されます。
そしてRuby on Rails側にこの情報が送られると、「ヘッダー情報が付与されていないので、認証ができない」とエラーが返っ
てきてしまいます。
このようなAxiosの仕様があるため、POSTメソッドを実行するときに限り、第３引数にヘッダー情報を渡すために、第２引数に
空のオブジェクト（{}）を記述しています。
*/ -->
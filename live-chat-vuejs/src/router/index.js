import { createRouter, createWebHistory } from 'vue-router'
import Welcome from '@/views/Welcome.vue'
import Chatroom from '@/components/Chatroom.vue'
import useValidate from '../auth/validate'

// validateメソッドを使用できる様になります。
const { validate, error } = useValidate()
// 1 任意の名前でいい
// eslint-disable-next-line no-unused-vars
const requireAuth = async (to, from, next) => {
  // uid・client・access-tokenのどれかがnullの場合は、ログインしていないと判断
  const uid = window.localStorage.getItem('uid')
  const client = window.localStorage.getItem('client')
  const accessToken = window.localStorage.getItem('access-token')
  if (!uid || !client || !accessToken) {
    console.log('ログインしていません')
    // 2 ウェルカムページにリダイレクト
    next({ name: 'Welcome' })
    // requireAuthの処理をここで終わらせたいので、最後にreturn
    return
  }
  // uid・client・access-tokenのいずれもnullではない場合はここの処理が実行
  await validate()
  // error.valueに値が入っている場合、エラーが発生したと判断し、ウェルカムページにリダイレクト
  if (error.value) {
    console.log('認証に失敗しました')
    next({ name: 'Welcome' })
  } else {
    // error.valueがnullの場合はエラーが発生していないと判断し、チャットルームページへリダイレクト
    next()
  }
}

// Welcomeへの遷移時に発火
const noRequireAuth = async (to, from, next) => {
  const uid = window.localStorage.getItem('uid')
  const client = window.localStorage.getItem('client')
  const accessToken = window.localStorage.getItem('access-token')

  // uid・client・access-tokenの全てがnullの場合は、ウェルカムページへリダイレクト
  if (!uid && !client && !accessToken) {
    next()
    return
  }
  // 既にログインしているかどうかを確認し、ログインしていればChatroomページにリダイレクト
  await validate()
  if (!error.value) {
    next({ name: 'Chatroom' })
  } else {
    next()
  }
}

const routes = [
  {
    // /にアクセスすると、Welcome.vueが表示
    path: '/',
    // ページの名前。他のページからこの/にリダイレクトさせたい時などに必要になります。
    name: 'Welcome',
    component: Welcome,
    beforeEnter: noRequireAuth
  },
  {
    path: '/chatroom',
    name: 'Chatroom',
    component: Chatroom,
    beforeEnter: requireAuth
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router

/*
@          @@          @@          @@          @@          @@          @@          @@          @
1
requireAuthで呼ばれるメソッドは、to・from・nextの3つの引数が自動で渡されます。toは次に表示されるページのルート
です。今回はウェルカムページからチャットルームページに移動するので、チャットルームページがtoになります。
fromはtoのページにアクセスしようとしている元のページです。今回は、ウェルカムページがfromです。
最後に、nextはそのページにアクセスさせるか、他のページへリダイレクトさせるかなどを操作するためのメソッドです。

################################################################################################
2
`next`
Vue Routerの「ナビゲーションガード」におけるメソッドで、ルート（ページ）の遷移を制御するために使用される。
このメソッドを使用して、特定のルートへのアクセスを許可したり、別のルートにリダイレクトさせたり、またはアクセスを完
全にブロックしたりすることができる。
------------------------------------------------------------------------------------------------
`next`は、以下のような引数を取ることができる：
1. **オブジェクト（ルート名など）**: 例として`next({ name: 'Welcome' })`のように、特定のルートオブジェクトを
引数に取る。この場合、指定された名前のルートにリダイレクトする。
2. **文字列（URLパス）**: 例として`next('/login')`のように、文字列としてパスを指定することで、そのパスにリダイ
レクトすることができる。
3. **なし**: 引数を与えずに`next()`を呼び出すと、現在のルートへの遷移をそのまま進行させる。特にリダイレクトや別の
アクションを行いたくない場合に使用する。
具体的には、このコードでnext()が呼び出されると、ユーザーが/chatroomというパスにアクセスしようとしたとき、特にエラ
ーやリダイレクトの条件がなければ、そのままChatroom.vueコンポーネントが表示される。このように、next()を使うことで、
ナビゲーションガードが正常に通過したことを示し、予定通りのページ遷移が行われる。
------------------------------------------------------------------------------------------------
*/
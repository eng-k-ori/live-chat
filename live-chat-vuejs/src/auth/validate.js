import axios from 'axios'
import { ref } from 'vue'
// 1
const error = ref(null)

const validate = async () => {
  // 最初にerrorを初期化。.valueで中身にアクセス。
  error.value = null
  // ローカルストレージからuid・access-token・clientを取得する
  const uid = window.localStorage.getItem('uid')
  const client = window.localStorage.getItem('client')
  const accessToken = window.localStorage.getItem('access-token')

  // Ruby on RailsのAPIと通信し、セッションの有効期限が切れていないか確認する
  try {
    // 2 devise token authに初期で用意されているvalidate_tokenというAPI
    const res = await axios.get('http://localhost:3001/auth/validate_token', {
      headers: {
        uid: uid,
        'access-token': accessToken,
        client: client
      }
    })
    if (!res) {
      throw new Error('認証に失敗しました')
    }
  } catch (err) {
    // error.valueに「認証に失敗しました」を代入
    error.value = '認証に失敗しました'
    // エラーが発生した場合はローカルストレージのデータを全て削除
    window.localStorage.removeItem('uid')
    window.localStorage.removeItem('access-token')
    window.localStorage.removeItem('client')
    window.localStorage.removeItem('name')
  }
}

// validateメソッドを実行し、実行結果を返します。
const useValidate = () => {
  // errorをrouter/index.jsから読み取れる様にする必要があり、返す値にerrorを追加
  return { error, validate }
}

export default useValidate

/*
@          @@          @@          @@          @@          @@          @@          @@          @
1
リアクティブとは、「その値が監視され、変更が検知される状態のこと」を指します。
例えば、validate内でエラーが発生し、変数errorに値が代入された時に、このvalidateを読み込んでいるsrc/router/index.js内でも、
errorの値を即座に読み取れる様になります。
refを使ったリアクティブな値の管理時は、最初に値を代入しておく必要があります。そのため、ref(null)と記述し、nullを
代入しています。
################################################################################################
2
const res = await axios.get('http://localhost:3000/auth/validate_token', {
`validate_token`
Devise Token Authで提供されているAPIエンドポイントで、ユーザーの認証トークンの有効性を確認するためのメソッド。
このメソッドを使用して、クライアントが持っているトークンがまだ有効であり、セッションが維持されているかを確認できる。
------------------------------------------------------------------------------------------------
通常、HTTPリクエストのヘッダーとして以下の3つのトークン情報を引数として取る：
- `uid`: ユーザーの一意の識別子
- `access-token`: ユーザーの認証トークン
- `client`: クライアント識別子
------------------------------------------------------------------------------------------------
`validate_token`エンドポイントに対してリクエストが送信されると、サーバーは以下の処理を行う：
1. ヘッダー内の`uid`、`access-token`、`client`を取得。
2. これらの情報がデータベース内の記録と一致するか確認。
3. トークンが有効かつセッションが有効な場合、サーバーは200 OKのレスポンスを返す。このレスポンスにはユーザーの情報
が含まれる。
4. トークンが無効、またはセッションが失効している場合、サーバーは401 Unauthorizedのレスポンスを返す。
------------------------------------------------------------------------------------------------
使用ケース
`validate_token`は、主に以下のようなケースで使用される：
- **ページ遷移時の認証確認**: SPA（Single Page Application）などで、ユーザーがページ間を移動する際に、現在の
セッションが有効であるか確認するために使用する。
- **アプリケーションの初期化時**: アプリケーションが初期化される際に、ユーザーが既にログインしているかを確認し、セ
ッションが有効であればそのままアプリケーションを利用できるようにするために使用される。
================================================================================================
validate_tokenメソッドとvalidatableモジュールは、直接的な関係はない。validate_tokenは、既に作成されたセッシ
ョンとそのトークンが有効かどうかを確認するためのメソッドであり、ユーザーの認証トークンの有効期限や状態を確認する。
一方、validatableはユーザーがサインアップやログインする際に、その情報が適切であるかをチェックするためのモジュール。
したがって、validate_tokenは認証の維持や検証に関わり、validatableは認証の前段階でのデータの正確性に関わる。
*/

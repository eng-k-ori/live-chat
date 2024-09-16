class MessagesController < ApplicationController
  before_action :authenticate_user!, only: ["index"]
  # メッセージの一覧取得機能
  def index
    # 1 ActiveRecord::Relationオブジェクト
    # 4 n+1問題 messages = Message.all
    messages = Message.includes(:user, [likes: :user])
    puts "messages:#{messages.inspect}"
    messages_array = messages.map do |message|
      # 2 この部分はrubyのハッシュ。id: message.id などの形式でキーと値を対応。このように書ける。
      {
        id: message.id,
        user_id: message.user.id,
        name: message.user.name,
        content: message.content,
        email: message.user.email,
        created_at: message.created_at,
        likes: message.likes.map { |like| { id: like.id, email: like.user.email }  }
      }
    end
    # 3 配列（各要素はハッシュ）、ハッシュの各ペアをJSONオブジェクト（JSON形式）へ変換
    render json: messages_array, status: :ok
  end
end

=begin
@          @@          @@          @@          @@          @@          @@          @@          @
1
messages は ActiveRecord::Relation オブジェクトであり、これはデータベースから取得したレコードの集合を表現する
特別なオブジェクト。純粋な配列やハッシュとは異なり、データベースに対するクエリ結果を保持し、さらに追加の操作（フィル
タリング、ソートなど）を行うためのメソッドも提供している。

################################################################################################
2
messageがlikesレコードを持っている場合は、下記のようなデータが返ってきます。

[
  {
      "id": 1,
      "user_id": 1,
      "name": "Momoko",
      "content": "0番目のメッセージです！",
      "email": "test@test.com",
      "created_at": "2021-06-26T14:32:31.174Z",
      # messageがlikesレコードを持っていない場合は、 "likes": []のように、空の配列が返ってきます。
      "likes": [
          {
            "id": 2,
            "email": "test@test.com"
          },
      ]
  }
]


################################################################################################
3
ActiveRecord::Relation は配列のように扱える機能を持っているため、map メソッドを使って messages をループ処理
できる。map を使うと、messages 内の各 Message オブジェクトに対して何らかの操作を行い、その結果を新しい配列にし
て返すことができる。

################################################################################################
4
N＋１問題とは
メッセージの一覧、それに紐づくユーザ・いいね情報の一覧を取得するのに40回ほどSQLが発行されます。
メッセージをN個とすると、下記のように1 + N回のSQLを発行する必要があります。

・メッセージ一覧を取得するSQLを１回
・メッセージに紐づくユーザを取得するSQLをN回
・メッセージに紐づくいいねを取得するSQLをN回
・いいねに紐づくユーザを取得するSQLをN回

このように、紐付く元の側のデータが増えるに従い、１回の処理で大量のSQLの発行量が増えることを「N＋１問題」と呼びます。

N＋１問題が起こることで、処理に時間が掛かりページ遷移が遅くなってしまうというなどの弊害が起こります。

日常生活で例えるなら、スーパーのレジで、商品を1点ずつお会計しているような状態です。１点ずつお会計する分、時間も労力
もかかってしまいます。
------------------------------------------------------------------------------------------------
参考：【Ruby on Rails】N+1問題ってなんだ？
https://qiita.com/massaaaaan/items/4eb770f20e636f7a1361
================================================================================================
Message.includes(:user, [likes: :user])と直しました。

最初の:userの部分：メッセージに紐づくユーザの一覧を取得
likes:の部分：メッセージに紐づくいいねの一覧を取得
２つ目の:userの部分：likes:に紐づくユーザの一覧を取得
今回のように、いいねとさらにいいねに紐付くユーザ一覧を取得したい場合、[likes:, :user]のように、配列を使用して一度にデータを取得します。

includesメソッドを使用することで、他のテーブルのレコードも一度に取得することができます。
今回は、メッセージ一覧を取得するときに、ユーザといいねも一緒に取得する、という書き方をしています。
=end
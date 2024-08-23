class MessagesController < ApplicationController
  before_action :authenticate_user!, only: ["index"]
  # メッセージの一覧取得機能
  def index
    # 1 ActiveRecord::Relationオブジェクト
    messages = Message.all
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
    # 3　配列（各要素はハッシュ）、ハッシュの各ペアをJSONオブジェクト（JSON形式）へ変換
    render json: messages_array, status: 200
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
=end
Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }

  resources :messages, only: ['index']

  # 1
  resources :messages, only: ['index'] do
    # messages/:id/likes。idはメッセージのIDで、どのメッセージにいいねをつけるのか判定するために必要
    member do
      resources :likes, only: ['create']
    end
  end

  # 2 /likes/:idというルートになります。createメソッドとは異なりmessageのidは不要
  resources :likes, only: ['destroy']
end

=begin
@          @@          @@          @@          @@          @@          @@          @@          @
1
resources :messagesのブロック内にmemberというブロックを追加し、その中にlikesのルーティングを追加します。こうす
ることで、messages/:id/likesというルートを作成することができます。

################################################################################################
2 resources :likes, only: ['destroy']
POST /messages/:id/likes: このルートは、メッセージに「いいね」をつけるとき: 特定のメッセージに対して「いいね」
を追加するためには、そのメッセージがどれであるかを特定する必要がある。
そのため、/messages/:id/likes というルートが使用され、:id でメッセージのIDを指定している。
------------------------------------------------------------------------------------------------
「いいね」を削除するとき: 「いいね」の削除には、メッセージのIDが不要。削除すべき「いいね」のIDさえ分かれば操作でき
るため、/likes/:id という簡単なルートが使用される。
「いいね」を削除する場合は、削除したい「いいね」のIDだけを使って DELETE /likes/:id というシンプルなルートが使わ
れる。
このルーティングの設計により、リソースの階層構造に従った明確で管理しやすいURLパターンが作られている。
=end
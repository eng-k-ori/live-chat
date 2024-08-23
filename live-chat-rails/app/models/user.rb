# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # 1
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  # 複数のレコードを保持する
  has_many :messages
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
end

=begin
@          @@          @@          @@          @@          @@          @@          @@          @
1
### 1. **`:database_authenticatable`**
- **役割**: ユーザーがメールアドレスとパスワードを使ってログインできるようにする機能。
- **動作**: このモジュールが有効になると、ユーザーがデータベースに保存されているパスワード（暗号化されて保存されて
いる）を使って認証される。ログイン時に入力されたパスワードがデータベース内のハッシュ化されたパスワードと一致するかど
うかを確認する。
================================================================================================
### 2. **`:registerable`**
- **役割**: ユーザーが新しいアカウントを作成（サインアップ）できるようにする機能。
- **動作**: ユーザーが新規にアカウントを作成するときの処理をサポートする。これには、アカウント作成フォームの提供、
ユーザー情報の保存、登録完了後のリダイレクトなどが含まれる。
================================================================================================
### 3. **`:recoverable`**
- **役割**: ユーザーがパスワードを忘れた場合に、パスワードリセットの機能を提供する。
- **動作**: このモジュールが有効だと、ユーザーは「パスワードを忘れた場合」のリンクをクリックして、メールアドレスを
入力すると、パスワードリセットのリンクが送信される。そのリンクをクリックすることで、新しいパスワードを設定できる。
- **具体例**: `user@example.com` がパスワードを忘れたときに、パスワードリセットのメールを受け取り、新しいパス
ワードを設定することができる。
================================================================================================
### 4. **`:rememberable`**
- **役割**: ユーザーがログイン状態を保持（「ログインを記憶する」）できるようにする機能。
- **動作**: ユーザーがログインするときに「ログインを記憶する」オプションを選ぶと、次回アクセス時に自動的にログイン
される。これはクッキーに情報を保存することで実現される。
- **具体例**: ユーザーがログイン時に「Remember me（ログイン状態を保持する）」をチェックすると、次にサイトにアク
セスしたときに再度ログインする必要がなくなる。
================================================================================================
### 5. **`:validatable`**
- **役割**: ユーザー登録時に、メールアドレスやパスワードの形式を自動的に検証する機能。
- **動作**: デフォルトで、メールアドレスの形式が正しいか、パスワードが一定の長さ（通常6文字以上）を満たしているか
をチェックする。このモジュールにより、基本的な入力チェックを簡単に行うことができる。
- **具体例**: 新規ユーザーがアカウントを作成しようとするとき、メールアドレスが `user@example` のように形式が正
しくない場合や、パスワードが5文字以下の場合にエラーメッセージが表示され、登録が拒否される。
=end

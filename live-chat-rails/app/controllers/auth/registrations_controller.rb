class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  private

  # ストロングパラメタメソッド
  def sign_up_params
    # 1 name、email、password、password_confirmationという4つのパラメタを許可するように上書き
    params.require(:registration).permit(:name, :email, :password, :password_confirmation)
  end
end

=begin
@          @@          @@          @@          @@          @@          @@          @@          @
1
VueやRailsのバージョンによっては、ここで下記のようなエラーが表示される場合があります。
Unpermitted parameters: :format, :registration
この場合は、app/controllers/auth/registrations_controller.rbのsign_up_paramsメソッドを下記のように変更
してください。
params.の後に、require(:registration)を追加しています。
=end

class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  private

  # ストロングパラメタメソッド
  def sign_up_params
    # name、email、password、password_confirmationという4つのパラメタを許可するように上書き
    params.permit(:name, :email, :password, :password_confirmation)
  end
end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    auth = request.env["omniauth.auth"]

    # ドメイン検証
    unless valid_university_email?(auth.info.email)
      redirect_to new_user_session_path, alert: "琉球大学のメールアドレス（@*.u-ryukyu.ac.jp）のみアクセスできます"
      return
    end

    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: "認証に失敗しました"
  end

  private

  def valid_university_email?(email)
    email.match?(User::ALLOWED_DOMAIN_REGEX)
  end
end

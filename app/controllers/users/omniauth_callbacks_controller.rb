class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    auth = request.env["omniauth.auth"]

    # ドメイン検証
    unless valid_university_email?(auth.info.email)
      flash[:alert] = "琉球大学のメールアドレス（@*.u-ryukyu.ac.jp）のみアクセスできます"
      redirect_to new_user_session_path
      return
    end

    @user = User.from_omniauth(auth)

    if @user.persisted?
      flash[:notice] = "Googleアカウントでログインしました"
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:alert] = "アカウントの作成に失敗しました: #{@user.errors.full_messages.join(', ')}"
      session["devise.google_data"] = auth.except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def failure
    flash[:alert] = "Google認証に失敗しました。もう一度お試しください"
    redirect_to new_user_session_path
  end

  private

  def valid_university_email?(email)
    email.match?(User::ALLOWED_DOMAIN_REGEX)
  end
end

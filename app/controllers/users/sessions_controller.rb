# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    super do |resource|
      flash[:notice] = "ログインしました"
    end
  end

  # DELETE /resource/sign_out
  def destroy
    flash[:notice] = "ログアウトしました"
    super
  end
end

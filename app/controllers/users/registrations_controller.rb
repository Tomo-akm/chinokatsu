# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # POST /resource
  def create
    super do |resource|
      if resource.persisted?
        flash[:notice] = "アカウントを作成しました。ログインしています..."
      end
    end
  end

  # PUT /resource
  def update
    super do |resource|
      if resource.errors.empty?
        flash[:notice] = "アカウント情報を更新しました"
      end
    end
  end

  # DELETE /resource
  def destroy
    super do
      flash[:notice] = "アカウントを削除しました。ご利用ありがとうございました"
    end
  end
end

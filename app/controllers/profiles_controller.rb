class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, notice: 'プロフィールを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:favorite_language, :research_lab, :internship_count, :personal_message)
  end
end

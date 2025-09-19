class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = params[:id] ? User.find(params[:id]) : (current_user if user_signed_in?)
    redirect_to new_user_session_path unless @user
    @posts = @user.posts.order(created_at: :desc)
    
    # ヒートマップ用の統計情報を計算
    @total_posts = @user.posts.count
    @posts_this_month = @user.posts.where(created_at: 1.month.ago..Time.current).count
    @max_posts_per_day = @user.posts
                              .where(created_at: 6.months.ago..Time.current)
                              .group("DATE(created_at)")
                              .count
                              .values
                              .max || 0
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

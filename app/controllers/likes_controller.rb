class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.build(user: current_user)

    if @like.save
      render partial: "shared/like_button", locals: { post: @post }
    else
      render partial: "shared/like_button", locals: { post: @post }, status: :unprocessable_entity
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)

    if @like&.destroy
      render partial: "shared/like_button", locals: { post: @post }
    else
      render partial: "shared/like_button", locals: { post: @post }, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end

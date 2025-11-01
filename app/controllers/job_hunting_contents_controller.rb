class JobHuntingContentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @job_hunting_content = JobHuntingContent.new
    @post = Post.new
  end

  def create
    @job_hunting_content = JobHuntingContent.new(job_hunting_content_params)
    @post = current_user.posts.build(contentable: @job_hunting_content)

    if @post.save
      redirect_to posts_path, notice: "就活投稿を作成しました"
    else
      flash.now[:alert] = "入力内容に誤りがあります。確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def job_hunting_content_params
    params.expect(job_hunting_content: [ :company_name, :selection_stage, :result, :content ])
  end
end

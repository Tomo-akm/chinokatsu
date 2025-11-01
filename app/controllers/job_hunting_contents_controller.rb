class JobHuntingContentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @job_hunting_content = JobHuntingContent.new
    @post = Post.new
  end

  def create
    @job_hunting_content = JobHuntingContent.new(job_hunting_content_params)
    @post = current_user.posts.build(contentable: @job_hunting_content)

    # タグの設定
    @post.tag_names = params.dig(:post, :tag_names) if params.dig(:post, :tag_names).present?

    if @post.save
      redirect_to posts_path, notice: "就活投稿を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def job_hunting_content_params
    params.expect(job_hunting_content: [ :company_name, :selection_stage, :result, :content ])
  end
end

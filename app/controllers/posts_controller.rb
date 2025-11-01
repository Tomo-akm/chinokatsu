class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :check_post_ownership, only: %i[ edit update destroy ]

  # GET /posts or /posts.json
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
            .includes(:contentable, :likes, :user, :tags)  # N+1対策（contentable追加）
            .order(created_at: :desc)
            .page(params[:page])
            .per(10)

    # サイドバー用のタグ一覧（投稿数上位10個）
    @popular_tags = Tag.with_posts.popular.limit(10)
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @general_content = GeneralContent.new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    # contentable の型に応じてインスタンス変数を設定
    if @post.general?
      @general_content = @post.contentable
    elsif @post.job_hunting?
      @job_hunting_content = @post.contentable
    end
  end

  # POST /posts or /posts.json
  def create
    @general_content = GeneralContent.new(general_content_params)
    @post = current_user.posts.build(contentable: @general_content)

    # タグの設定
    @post.tag_names = params.dig(:post, :tag_names) if params.dig(:post, :tag_names).present?

    if @post.save
      redirect_to posts_path, notice: "コミットをpushしました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    # contentable の型に応じてインスタンス変数を設定
    if @post.general?
      @general_content = @post.contentable
    elsif @post.job_hunting?
      @job_hunting_content = @post.contentable
    end

    # タグの更新
    @post.tag_names = params.dig(:post, :tag_names) if params.dig(:post, :tag_names).present?

    if @post.contentable.update(contentable_params)
      redirect_to @post, notice: "コミットをmergeしました✨", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!
    redirect_to posts_path, notice: "コミットをrevertしました↩️", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.includes(:contentable).find(params.expect(:id))
    end

    # Check if the current user owns the post
    def check_post_ownership
      unless @post.user == current_user
        redirect_to @post, alert: "このコミットをrebase・revertする権限がありません。"
      end
    end

    # 通常投稿用のパラメータ
    def general_content_params
      params.expect(general_content: [ :content ])
    end

    # contentable の型に応じてパラメータを返す
    def contentable_params
      if @post.general?
        params.expect(general_content: [ :content ])
      elsif @post.job_hunting?
        params.expect(job_hunting_content: [ :company_name, :selection_stage, :result, :content ])
      end
    end
end

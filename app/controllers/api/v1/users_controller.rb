class Api::V1::UsersController < ApplicationController
  def posts_activity
    user = User.find(params[:id])
    from = Time.parse(params[:start]) if params[:start]
    to = Time.parse(params[:stop]) if params[:stop]

    # デフォルトで6ヶ月前から現在まで
    from ||= 6.months.ago
    to ||= Time.current

    # ユーザーの投稿データを取得
    posts = user.posts.where(created_at: from..to)

    # Cal-Heatmap用のデータ形式に変換
    # created_atをUnixタイムスタンプ（秒）に変換し、同じ日の投稿数をカウント
    activity_data = posts.map { |post|
      # 日の開始時刻のタイムスタンプを使用
      post.created_at.beginning_of_day.to_i
    }.inject(Hash.new(0)) { |hash, timestamp|
      hash[timestamp] += 1; hash
    }

    render json: activity_data
  end
end

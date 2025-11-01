class JobHuntingContent < ApplicationRecord
  has_one :post, as: :contentable, dependent: :destroy

  # enum定義
  enum :selection_stage, {
    es: 0,
    first_interview: 1,
    second_interview: 2,
    final_interview: 3,
    other: 4
  }, prefix: true

  enum :result, {
    passed: 0,
    failed: 1,
    pending: 2
  }, prefix: true

  validates :company_name, presence: true, length: { maximum: 100 }
  validates :selection_stage, presence: true
  validates :result, presence: true
  validates :content, presence: true, length: { maximum: 5000 }

  # Ransackの設定
  def self.ransackable_attributes(auth_object = nil)
    %w[company_name selection_stage result content]
  end

  # 日本語表示用のヘルパーメソッド
  def selection_stage_ja
    {
      "es" => "ES",
      "first_interview" => "一次面接",
      "second_interview" => "二次面接",
      "final_interview" => "最終面接",
      "other" => "その他"
    }[selection_stage]
  end

  def result_ja
    {
      "passed" => "通過",
      "failed" => "不通過",
      "pending" => "選考中"
    }[result]
  end

  # セレクトボックス用の選択肢
  def self.selection_stages_for_select
    [
      [ "ES", "es" ],
      [ "一次面接", "first_interview" ],
      [ "二次面接", "second_interview" ],
      [ "最終面接", "final_interview" ],
      [ "その他", "other" ]
    ]
  end

  def self.results_for_select
    [
      [ "通過", "passed" ],
      [ "不通過", "failed" ],
      [ "選考中", "pending" ]
    ]
  end
end

class GeneralContent < ApplicationRecord
  has_one :post, as: :contentable, dependent: :destroy

  validates :content, presence: true, length: { maximum: 5000 }

  # Ransackの設定（post経由で検索可能にする）
  def self.ransackable_attributes(auth_object = nil)
    %w[content]
  end
end

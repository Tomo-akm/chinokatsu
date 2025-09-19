class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :content, presence: true

  # タグ名で検索
  scope :with_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }
  
  # Ransackの設定
  def self.ransackable_attributes(auth_object = nil)
    %w[content created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user tags]
  end

  # タグ名の配列を受け取ってタグを設定
  def tag_names=(names)
    tag_list = names.is_a?(String) ? names.split(',') : names
    tag_list = tag_list.map(&:strip).reject(&:blank?)
    self.tags = Tag.find_or_create_by_names(tag_list)
  end

  def tag_names
    tags.pluck(:name).join(', ')
  end
end

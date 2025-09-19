class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

  scope :popular, -> { order(posts_count: :desc) }
  scope :with_posts, -> { where('posts_count > 0') }

  before_save :normalize_name

  # Ransackの設定
  def self.ransackable_attributes(auth_object = nil)
    %w[name posts_count created_at]
  end

  def self.find_or_create_by_names(tag_names)
    return [] if tag_names.blank?
    
    tag_names.map do |name|
      find_or_create_by(name: name.strip.downcase)
    end
  end

  private

  def normalize_name
    self.name = name.strip.downcase
  end
end

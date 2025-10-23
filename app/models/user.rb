class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :posts, dependent: :destroy

  validates :name, presence: true
  validates :internship_count, presence: true, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  # 琉球大学ドメイン検証
  ALLOWED_DOMAIN_REGEX = /\A[\w+\-.]+@[a-z\d\-]+\.u-ryukyu\.ac\.jp\z/i

  validate :university_email_domain, if: :email_changed?

  # OmniAuth経由の場合はパスワード検証をスキップ
  def password_required?
    super && provider.blank?
  end

  def email_required?
    super && provider.blank?
  end

  # OmniAuthコールバック用
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name.presence || auth.info.email.split("@").first
      user.password = Devise.friendly_token[0, 20]
      user.internship_count = 0
    end
  end

  private

  def university_email_domain
    return if email.blank?

    unless email.match?(ALLOWED_DOMAIN_REGEX)
      errors.add(:email, "は琉球大学のメールアドレス（@*.u-ryukyu.ac.jp）のみ登録できます")
    end
  end
end

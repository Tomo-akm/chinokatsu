class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  validates :name, presence: true
  validates :internship_count, presence: true, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
end

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'requires an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'requires a unique email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
    end

    it 'requires a password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many posts' do
      association = described_class.reflect_on_association(:posts)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe '#posts' do
    it 'returns posts created by the user' do
      user = create(:user)
      post1 = create(:post, user: user)
      post2 = create(:post, user: user)
      other_post = create(:post)

      expect(user.posts).to include(post1, post2)
      expect(user.posts).not_to include(other_post)
    end
  end
end

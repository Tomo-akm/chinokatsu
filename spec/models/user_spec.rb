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
      create(:user, email: 'test@ie.u-ryukyu.ac.jp')
      user = build(:user, email: 'test@ie.u-ryukyu.ac.jp')
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

  describe '.from_omniauth' do
    let(:auth) do
      OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          email: 'e215700@ie.u-ryukyu.ac.jp',
          name: '山田太郎'
        }
      })
    end

    context '新規ユーザーの場合' do
      it 'ユーザーを作成する' do
        expect {
          User.from_omniauth(auth)
        }.to change(User, :count).by(1)
      end

      it '正しい属性を設定する' do
        user = User.from_omniauth(auth)
        expect(user.email).to eq('e215700@ie.u-ryukyu.ac.jp')
        expect(user.name).to eq('山田太郎')
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('123456789')
      end

      it 'ランダムなパスワードを設定する' do
        user = User.from_omniauth(auth)
        expect(user.encrypted_password).to be_present
      end

      it 'internship_countを0で初期化する' do
        user = User.from_omniauth(auth)
        expect(user.internship_count).to eq(0)
      end
    end

    context '既存ユーザーの場合' do
      it '新規作成しない' do
        User.from_omniauth(auth)
        expect {
          User.from_omniauth(auth)
        }.not_to change(User, :count)
      end

      it '既存のユーザーを返す' do
        first_user = User.from_omniauth(auth)
        second_user = User.from_omniauth(auth)
        expect(first_user.id).to eq(second_user.id)
      end
    end

    context 'nameがない場合' do
      let(:auth_without_name) do
        OmniAuth::AuthHash.new({
          provider: 'google_oauth2',
          uid: '987654321',
          info: {
            email: 'test@cs.u-ryukyu.ac.jp',
            name: ''
          }
        })
      end

      it 'emailの@前の部分をnameとする' do
        user = User.from_omniauth(auth_without_name)
        expect(user.name).to eq('test')
      end
    end
  end

  describe 'email validation' do
    context '琉球大学のメールアドレスの場合' do
      it 'eve.u-ryukyu.ac.jpを許可する' do
        user = build(:user, email: 'e215700@eve.u-ryukyu.ac.jp', password: 'password123')
        expect(user).to be_valid
      end

      it 'cs.u-ryukyu.ac.jpを許可する' do
        user = build(:user, email: 'taro@cs.u-ryukyu.ac.jp', password: 'password123')
        expect(user).to be_valid
      end

      it 'ie.u-ryukyu.ac.jpを許可する' do
        user = build(:user, email: 'hanako@ie.u-ryukyu.ac.jp', password: 'password123')
        expect(user).to be_valid
      end
    end

    context '琉球大学以外のメールアドレスの場合' do
      it 'gmail.comを拒否する' do
        user = build(:user, email: 'test@gmail.com', password: 'password123')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('は琉球大学のメールアドレス（@*.u-ryukyu.ac.jp）のみ登録できます')
      end

      it 'u-ryukyu.ac.jpに似たドメインを拒否する' do
        user = build(:user, email: 'fake@evil-u-ryukyu.ac.jp', password: 'password123')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('は琉球大学のメールアドレス（@*.u-ryukyu.ac.jp）のみ登録できます')
      end

      it '末尾が異なるドメインを拒否する' do
        user = build(:user, email: 'test@u-ryukyu.ac.jp.fake.com', password: 'password123')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('は琉球大学のメールアドレス（@*.u-ryukyu.ac.jp）のみ登録できます')
      end
    end
  end
end

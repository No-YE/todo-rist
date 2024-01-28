# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_inclusion_of(:provider).in_array(%w[google_oauth2]) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:links) }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      describe '#downcase_email' do
        let(:user) { build(:user, email: 'TeST@gMail.COm') }

        it 'downcases the email' do
          expect { user.valid? }.to change { user.email }.to('test@gmail.com')
        end
      end
    end
  end

  describe '.from_omniauth' do
    let!(:access_token) { double(provider: 'google_oauth2', uid: 'abcd', info:, extra:) }
    let(:info) do
      {
        'name' => 'Test User',
        'email' => 'test@gmail.com',
        'image' => 'https://lh3.googleusercontent.com/url/photo.jpg',
      }
    end
    let(:extra) do
      {
        'id_info' => { 'locale' => 'en' },
      }
    end

    context 'when user exists' do
      let_it_be(:existing_user) { create(:user, email: 'test@gmail.com') }

      it 'returns the user' do
        expect(described_class.from_omniauth(access_token)).to eq(existing_user)
      end
    end

    context 'when user does not exist' do
      it 'creates a new user' do
        expect { described_class.from_omniauth(access_token) }
          .to change(described_class, :count).by(1)
      end

      it 'returns the new user' do
        expect(described_class.from_omniauth(access_token)).to eq(described_class.last)
      end

      it 'sets the correct attributes' do
        user = described_class.from_omniauth(access_token)
        expect(user.name).to eq('Test User')
        expect(user.email).to eq('test@gmail.com')
        expect(user.image).to eq('https://lh3.googleusercontent.com/url/photo.jpg')
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('abcd')
      end
    end
  end

  describe '#as_json' do
    let(:user) { create(:user) }

    it 'returns the correct attributes' do
      expect(user.as_json).to eq(
        'id' => user.id,
        'name' => user.name,
        'email' => user.email,
        'image' => user.image,
        'provider' => user.provider,
        'uid' => user.uid,
        'locale' => user.locale,
        'created_at' => user.created_at.iso8601(3),
        'updated_at' => user.updated_at.iso8601(3),
      )
    end
  end

  describe '#attach_avatar_from' do
    let_it_be(:user) { create(:user) }
    let(:url) { 'https://meme.eq8.eu/noidea.jpg' }

    it 'attaches the avatar' do
      expect { user.attach_avatar_from(url) }.to change { user.avatar.attached? }.to(true)
    end

    it 'attaches the correct image' do
      expect { user.attach_avatar_from(url) }
        .to change { user.avatar.filename.to_s }.to('noidea.jpg')
    end
  end
end

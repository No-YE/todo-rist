# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :request do
  describe 'GET /index' do
    let(:omniauth_params) do
      {
        provider: 'google_oauth2',
        uid: '123456789',
        info: {
          name: 'John Doe',
          email: 'test@gmail.com',
          image: 'https://lh3.googleusercontent.com/a-/AOh14GhY7Z0',
        },
      }
    end

    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(omniauth_params)
    end

    context 'when request.env["omniauth.auth"] is valid' do
      it 'creates a new user' do
        expect { get '/users/auth/google_oauth2/callback' }.to change(User, :count).by(1)
      end
    end

    context 'when request.env["omniauth.auth"] is invalid' do
      let_it_be(:existing_user) { create(:user, provider: 'google_oauth2', uid: '123456789') }

      it 'does not create a new user and redirect to new_user_registration_url' do
        expect { get '/users/auth/google_oauth2/callback' }.not_to change(User, :count)
        expect(response).to redirect_to(new_user_registration_url)
      end
    end
  end
end

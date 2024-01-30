# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'GET /me.json' do
    context 'when user is signed in' do
      let_it_be(:user) { create(:user) }

      before do
        sign_in user
        get '/users/me.json'
      end

      it 'show user profile' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.name)
      end
    end

    context 'when user is not signed in' do
      before do
        get '/users/me.json'
      end

      it 'unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

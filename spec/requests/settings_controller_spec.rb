# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SettingsController, type: :request do
  describe 'GET /general' do
    context 'when user is signed in' do
      let_it_be(:user) { create(:user) }

      before do
        sign_in user
        get general_settings_path
      end

      it 'show general settings page' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('프로필')
      end
    end

    context 'when user is not signed in' do
      before do
        get general_settings_path
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /notification' do
    context 'when user is signed in' do
      let_it_be(:user) { create(:user) }

      before do
        sign_in user
        get notification_settings_path
      end

      it 'show notification settings page' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('리마인더')
      end
    end

    context 'when user is not signed in' do
      before do
        get notification_settings_path
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

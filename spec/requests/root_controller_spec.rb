# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RootController, type: :request do
  describe 'GET /index' do
    context 'when user is signed in' do
      let_it_be(:user) { create(:user) }

      before do
        sign_in user
        get root_path
      end

      it 'redirects to links_path' do
        expect(response).to redirect_to(links_path)
      end
    end

    context 'when user is not signed in' do
      before do
        get root_path
      end

      it 'show index page' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Summary first')
      end
    end
  end
end

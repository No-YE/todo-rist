# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::LinksController, type: :request do
  let_it_be(:admin) { create(:user, :admin) }

  describe 'POST /create_initial' do
    let(:link_params) { { link: { user_id: admin.id, url: 'https://example.com' } } }

    before do
      sign_in admin
    end

    it 'creates a new link' do
      expect do
        post '/admin/links/initial', params: link_params
      end.to change(Link, :count).by(1)
      expect(response).to have_http_status(:no_content)
    end
  end
end

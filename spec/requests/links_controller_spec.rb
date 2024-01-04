# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :request do
  let_it_be(:user) { create(:user) }
  let_it_be(:link) { create(:link, user:, url: 'https://example.com/1') }

  describe 'GET /index' do
    before do
      sign_in user
      get links_path(q: { title_cont: 'title' })
    end

    it 'show links page' do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('링크 추가')
    end

    it 'save search params in session' do
      expected_search_session = ActionController::Parameters.new(title_cont: 'title')
      expect(session[:links_index_search]).to eq(expected_search_session)
    end

    context 'when sort params is empty' do
      it 'sorts by id desc' do
        expect(response.body).to include('id desc')
      end
    end
  end

  describe 'GET /others' do
    before do
      sign_in user
      get others_links_path(q: { title_cont: 'title' })
    end

    it 'show others links page' do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('링크 추가')
    end

    it 'save search params in session' do
      expected_search_session = ActionController::Parameters.new(title_cont: 'title')
      expect(session[:links_others_search]).to eq(expected_search_session)
    end

    context 'when sort params is empty' do
      it 'sorts by id desc' do
        expect(response.body).to include('id desc')
      end
    end
  end

  describe 'GET /new' do
    before do
      sign_in user
      get new_link_path
    end

    it 'show new link page' do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('저장')
    end
  end

  describe 'POST /create' do
    let(:link_params) { { link: { url: 'https://example.com/2', due_date: '2024-01-01' } } }

    before do
      sign_in user
      post links_path, params: link_params
    end

    it 'creates a new link' do
      expect(Link.last.url).to eq('https://example.com/2')
      expect(Link.last.due_date).to eq(Date.new(2024, 1, 1))
    end

    it 'redirects to links_path' do
      expect(response).to redirect_to(links_path)
    end

    context 'when link is invalid' do
      let(:link_params) { { link: { url: 'https://example.com/1', due_date: '2024-01-01' } } }

      it 'renders new page' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('저장')
      end
    end
  end

  describe 'DELETE /destroy' do
    before do
      sign_in user
      delete link_path(link)
    end

    it '204 no content' do
      expect(response).to have_http_status(:no_content)
    end

    it 'soft deletes a link' do
      expect(link.reload.discarded?).to eq(true)
    end
  end

  describe 'PUT /read' do
    before do
      sign_in user
      link.unread!
      put read_link_path(link)
    end

    it '204 no content' do
      expect(response).to have_http_status(:no_content)
    end

    it 'marks a link as read' do
      expect(link.reload.read?).to eq(true)
    end
  end

  describe 'PUT /unread' do
    before do
      sign_in user
      link.read!
      put unread_link_path(link)
    end

    it '204 no content' do
      expect(response).to have_http_status(:no_content)
    end

    it 'marks a link as unread' do
      expect(link.reload.unread?).to eq(true)
    end
  end

  describe 'POST /clone' do
    let_it_be(:other_user) { create(:user) }

    before do
      sign_in other_user
      post clone_link_path(link)
    end

    it 'clones a link' do
      expect(Link.last.url).to eq('https://example.com/1')
    end

    it 'renders flash message' do
      expect(response.body).to include('내 투두에 복사되었습니다.')
    end

    context 'when link is invalid' do
      before do
        sign_in user
        post clone_link_path(link)
      end

      it 'renders flash message' do
        expect(response.body).to include('이미 존재하는 url입니다.')
      end
    end
  end
end

require 'rails_helper'

RSpec.describe ArticlesController do
  describe '#index' do
    it 'returns a success responce' do
      get '/articles'
      # expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
    end

    it 'returns a proper JSON' do
      article = create :article
      get '/articles'
      expect(json_data.length).to eq(1)
      expected = json_data.first
      expect(expected[:id]).to eq(article.id.to_s)
      expect(expected[:type]).to eq('article')
      expect(expected[:attributes]).to eq(
        title: article.title,
        content: article.content,
        slug: article.slug
      )
    end

    it 'returns articles in the proper order' do
      older_article = create(:article, created_at: 1.hour.ago)
      recent_article = create(:article)
      get '/articles'
      ids = json_data.map { |item| item[:id].to_i }
      expect(ids).to eq([recent_article.id, older_article.id])
    end

    it 'paginates results' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 2, size: 1 } }
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq(article2.id.to_s)
    end

    it 'paginates results' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 2, size: 1 } }
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(
        :first, :prev, :next, :last, :self
      )
    end
  end

  describe "#show" do
    it 'returns a proper JSON' do
      article1 = create :article
      get "/articles/#{article1.id}"
      expect(json_data[:id]).to eq(article1.id.to_s)
      expect(json_data[:type]).to eq('article')
      expect(json_data[:attributes]).to eq(
        title: article1.title,
        content: article1.content,
        slug: article1.slug
      )
    end
  end
end

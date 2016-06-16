require './spec/feature_spec_helper'
require 'json'

describe 'API v1 pages', type: :feature do
  context 'GET /v1/pages/:id' do
    it 'returns page' do
      page = FactoryGirl.build(:page)
      expected_id = DB.connection[:pages].insert(page.to_db)
      get "/v1/pages/#{expected_id}"
      data = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(data['id']).to eq expected_id
      expect(data['active']).to eq page.active
      expect(data['slug']).to eq page.slug
      expect(data['title']).to eq page.title
      expect(data['content']).to eq page.content
      expect(data['image']).to eq page.image
      expect(Time.parse(data['created_at']).to_i).to eq page.created_at.to_i
      expect(data['updated_at']).to be_nil
    end

    it 'returns page not found' do
      expected_id = 78
      expected_json = {
        error: 'page_not_found',
        error_description: 'Page not found.'
      }.to_json
      get "/v1/pages/#{expected_id}"
      expect(last_response.status).to eq 404
      expect(last_response.body).to eq expected_json
    end
  end
end

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

  context 'POST /v1/pages' do
    it 'created page' do
      page = FactoryGirl.build(:page)
      count = DB.connection[:pages].count
      post('/v1/pages',
           active: true,
           slug: page.slug,
           title: page.title,
           content: page.content,
           image: page.image)
      new_count = DB.connection[:pages].count
      data = JSON.parse(last_response.body)
      expect(last_response.status).to eq 201
      expect(data).to have_key('id')
      expect(data['active']).to eq false
      expect(data['slug']).to eq page.slug
      expect(data['title']).to eq page.title
      expect(data['content']).to eq page.content
      expect(data['image']).to eq page.image
      expect(data['created_at']).to eq Time.now.to_i
      expect(data['update_at']).to be_nil
      expect(new_count).to eq count + 1
    end

    it 'returns error title empty' do
      expected_json = {
        error: 'page_title_empty',
        error_description: 'Enter title page.'
      }.stringify_keys
      page = FactoryGirl.build(:page)
      count = DB.connection[:pages].count
      page.title = ''
      post('/v1/pages',
           active: page.active,
           title: page.title,
           content: page.content)
      new_count = DB.connection[:pages].count
      data = JSON.parse(last_response.body)
      expect(last_response.status).to eq 400
      expect(data).to eq expected_json
      expect(new_count).to eq count
    end
  end

  context 'PATCH /v1/pages/:id' do
    it 'update page' do
      page = FactoryGirl.build(:page, id: rand(1..1000))
      DB.connection[:pages].insert(page.to_db)
      updated_title = 'Updated title page'
      updated_content = 'Updated content page'
      patch("/v1/pages/#{page.id}",
            active: 0,
            title: updated_title,
            content: updated_content)
      expect(last_response.status).to eq 200
      data = JSON.parse(last_response.body)
      expect(data['id']).to eq page.id
      expect(data['active']).to eq false
      expect(data['title']).to eq updated_title
      expect(data['content']).to eq updated_content
      expect(data['updated_at']).to eq Time.now.to_i
    end

    it 'update active - true' do
      page = FactoryGirl.build(:page, id: rand(1..1000), active: false)
      DB.connection[:pages].insert(page.to_db)
      patch("/v1/pages/#{page.id}",
            active: 1)
      expect(last_response.status).to eq 200
      data = JSON.parse(last_response.body)
      expect(data['id']).to eq page.id
      expect(data['active']).to eq true
    end

    it 'returns error page not found' do
      expected_id = 78
      expected_json = {
        error: 'page_not_found',
        error_description: 'Page not found.'
      }.to_json
      patch("/v1/pages/#{expected_id}",
            title: 'updated title')
      expect(last_response.status).to eq 404
      expect(last_response.body).to eq expected_json
    end

    it 'returns error page title empty' do
      page = FactoryGirl.build(:page, id: rand(1..1000))
      DB.connection[:pages].insert(page.to_db)
      expected_json = {
        error: 'page_title_empty',
        error_description: 'Enter title page.'
      }.stringify_keys
      updated_title = ''
      patch("/v1/pages/#{page.id}",
            title: updated_title)
      data = JSON.parse(last_response.body)
      expect(last_response.status).to eq 400
      expect(data).to eq expected_json
    end
  end

  context 'DELETE /v1/pages/:id' do
    it 'delete page' do
      page = FactoryGirl.build(:page, id: rand(1..1000))
      DB.connection[:pages].insert(page.to_db)
      count = DB.connection[:pages].count
      delete("/v1/pages/#{page.id}")
      new_count = DB.connection[:pages].count
      expect(last_response.status).to eq 204
      expect(new_count).to eq count - 1
    end

    it 'returns error page not found' do
      expected_id = 78
      expected_json = {
        error: 'page_not_found',
        error_description: 'Page not found.'
      }.to_json
      delete "/v1/pages/#{expected_id}"
      expect(last_response.status).to eq 404
      expect(last_response.body).to eq expected_json
    end
  end
end

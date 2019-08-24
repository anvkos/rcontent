require './spec/feature_spec_helper'
require 'json'

describe 'API v1 tags', type: :feature do
  context 'GET /v1/tags/:id' do
    it 'returns tag' do
      tag = FactoryGirl.build(:tag, id: rand(1..1000))
      expected_id = DB.connection[:tags].insert(tag.to_db)
      get "/v1/tags/#{expected_id}"
      data = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(data['id']).to eq expected_id
      expect(data['slug']).to eq tag.slug
      expect(data['name']).to eq tag.name
      expect(Time.parse(data['created_at']).to_i).to eq tag.created_at.to_i
      expect(data['updated_at']).to be_nil
    end

    it 'returns page not found' do
      expected_id = 78
      expected_json = {
        error: 'tag_not_found',
        error_description: 'Tag not found.'
      }.to_json
      get "/v1/tags/#{expected_id}"
      expect(last_response.status).to eq 404
      expect(last_response.body).to eq expected_json
    end
  end

  context 'POST /v1/tags' do
    it 'created tag' do
      tag = FactoryGirl.build(:tag)
      count = DB.connection[:tags].count
      post('/v1/tags',
           slug: tag.slug,
           name: tag.name)
      new_count = DB.connection[:tags].count
      data = JSON.parse(last_response.body)
      expect(last_response.status).to eq 201
      expect(data).to have_key('id')
      expect(data['slug']).to eq tag.slug
      expect(data['name']).to eq tag.name
      expect(
        Time.parse(data['created_at']).to_i
      ).to eq tag.created_at.to_i
      expect(data['update_at']).to be_nil
      expect(new_count).to eq count + 1
    end

    it 'returns error name empty' do
      expected_json = {
        error: 'tag_name_empty',
        error_description: 'Enter name tag.'
      }.stringify_keys
      tag = FactoryGirl.build(:tag)
      count = DB.connection[:tags].count
      tag.name = ''
      post('/v1/tags',
           name: tag.name)
      new_count = DB.connection[:tags].count
      data = JSON.parse(last_response.body)
      expect(last_response.status).to eq 400
      expect(data).to eq expected_json
      expect(new_count).to eq count
    end
  end

  context 'PATCH /v1/tags/:id' do
    it 'update tag' do
      tag = FactoryGirl.build(:tag, id: rand(1..1000))
      DB.connection[:tags].insert(tag.to_db)
      updated_name = 'Updated name tag'
      updated_slug = 'updated_tag_slug'
      patch("/v1/tags/#{tag.id}",
            name: updated_name,
            slug: updated_slug)
      expect(last_response.status).to eq 200
      data = JSON.parse(last_response.body)
      expect(data['id']).to eq tag.id
      expect(data['name']).to eq updated_name
      expect(data['slug']).to eq updated_slug
      expect(
        Time.parse(data['updated_at']).to_i
      ).to eq Time.now.to_i
    end

    it 'returns error tag not found' do
      expected_id = 89
      expected_json = {
        error: 'tag_not_found',
        error_description: 'Tag not found.'
      }.to_json
      patch("/v1/tags/#{expected_id}",
            name: 'updated name')
      expect(last_response.status).to eq 404
      expect(last_response.body).to eq expected_json
    end

    it 'returns error tag name empty' do
      tag = FactoryGirl.build(:tag, id: rand(1..1000))
      DB.connection[:tags].insert(tag.to_db)
      expected_json = {
        error: 'tag_name_empty',
        error_description: 'Enter name tag.'
      }.stringify_keys
      updated_name = ''
      patch("/v1/tags/#{tag.id}",
            name: updated_name)
      data = JSON.parse(last_response.body)
      expect(last_response.status).to eq 400
      expect(data).to eq expected_json
    end
  end

  context 'DELETE /v1/tags/:id' do
    it 'delete tag' do
      tag = FactoryGirl.build(:tag, id: rand(1..1000))
      DB.connection[:tags].insert(tag.to_db)
      count = DB.connection[:tags].count
      delete("/v1/tags/#{tag.id}")
      new_count = DB.connection[:tags].count
      expect(last_response.status).to eq 204
      expect(new_count).to eq count - 1
    end

    it 'returns error tag not found' do
      expected_id = 89
      expected_json = {
        error: 'tag_not_found',
        error_description: 'Tag not found.'
      }.to_json
      delete "/v1/tags/#{expected_id}"
      expect(last_response.status).to eq 404
      expect(last_response.body).to eq expected_json
    end
  end
end

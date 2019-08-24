require 'dotenv'
Dotenv.load
require 'sinatra/base'
require 'wisper'
require 'json'
require './app/db'
# pages
require './app/params/get_page_params'
require './app/services/get_page_service'
require './app/services/create_page_service'
require './app/params/create_page_params'
require './app/services/delete_page_service'
require './app/params/delete_page_params'
require './app/services/update_page_service'
require './app/params/update_page_params'
# tags
require './app/params/get_tag_params'
require './app/services/get_tag_service'
require './app/services/create_tag_service'
require './app/params/create_tag_params'
require './app/services/update_tag_service'
require './app/params/update_tag_params'
require './app/services/delete_tag_service'
require './app/params/delete_tag_params'

class App < Sinatra::Base
  get '/v1/pages' do
  end

  get '/v1/pages/:id' do
    service = GetPageService.new
    service.on(:page_not_found) { return page_not_found }
    page = service.call GetPageParams.new(params)
    status 200
    page_prepare page
  end

  post '/v1/pages' do
    service = CreatePageService.new
    service.on(:page_title_empty) { return page_title_empty }
    page = service.call CreatePageParams.new(params)
    status 201
    page_prepare page
  end

  patch '/v1/pages/:id' do
    service = UpdatePageService.new
    service.on(:page_not_found) { return page_not_found }
    service.on(:page_title_empty) { return page_title_empty }
    page = service.call UpdatePageParams.new(params)
    status 200
    page_prepare page
  end

  delete '/v1/pages/:id' do
    service = DeletePageService.new
    service.on(:page_not_found) { return page_not_found }
    service.call DeletePageParams.new(params)
    status 204
  end

  get '/v1/tags/:id' do
    service = GetTagService.new
    service.on(:tag_not_found) { return tag_not_found }
    tag = service.call GetTagParams.new(params)
    status 200
    tag_prepare tag
  end

  post '/v1/tags' do
    service = CreateTagService.new
    service.on(:tag_name_empty) { return tag_name_empty }
    tag = service.call CreateTagParams.new(params)
    status 201
    tag_prepare tag
  end

  patch '/v1/tags/:id' do
    service = UpdateTagService.new
    service.on(:tag_not_found) { return tag_not_found }
    service.on(:tag_name_empty) { return tag_name_empty }
    tag = service.call UpdateTagParams.new(params)
    status 200
    tag_prepare tag
  end

  delete '/v1/tags/:id' do
    service = DeleteTagService.new
    service.on(:tag_not_found) { return tag_not_found }
    service.call DeleteTagParams.new(params)
    status 204
  end

  get '/status' do
    'ok'
  end

  def page_not_found
    @error = {
      error: 'page_not_found',
      error_description: 'Page not found.'
    }
    status = 404
  end

  def page_title_empty
    status 400
    {
      error: 'page_title_empty',
      error_description: 'Enter title page.'
    }.to_json
  end

  def tag_not_found
    @error = {
      error: 'tag_not_found',
      error_description: 'Tag not found.'
    }
    status = 404
  end

  def tag_name_empty
    status 400
    {
      error: 'tag_name_empty',
      error_description: 'Enter name tag.'
    }.to_json
  end

  not_found do
    @error ||= {
      error: 'page_not_found',
      error_description: 'Check API documentation.'
    }
    @error.to_json
  end

  private

  def page_prepare(page)
    page.to_h
        .to_json
  end

  def tag_prepare(tag)
    tag.to_h
       .to_json
  end
end

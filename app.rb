require 'dotenv'
Dotenv.load
require 'sinatra/base'
require 'wisper'
require 'json'
require './app/db'
require './app/params/get_page_params'
require './app/services/get_page_service'
require './app/services/create_page_service'
require './app/params/create_page_params'
require './app/services/delete_page_service'
require './app/params/delete_page_params'
require './app/services/update_page_service'
require './app/params/update_page_params'

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
end

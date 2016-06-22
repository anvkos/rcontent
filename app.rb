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

class App < Sinatra::Base
  get '/v1/pages' do
  end

  get '/v1/pages/:id' do
    service = GetPageService.new
    service.on(:page_not_found) { return page_not_found }
    page = service.call GetPageParams.new(params)
    status 200
    page.to_h
        .to_json
  end

  post '/v1/pages' do
    service = CreatePageService.new
    service.on(:page_title_empty) { return page_title_empty }
    page = service.call CreatePageParams.new(params)
    status 201
    page.to_h
        .to_json
  end

  patch '/v1/pages/:id' do
  end

  delete '/v1/pages/:id' do
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
end

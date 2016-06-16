require 'dotenv'
Dotenv.load
require 'sinatra/base'
require 'wisper'
require 'json'
require './app/db'
require './app/params/get_page_params'

class App < Sinatra::Base
  get '/v1/pages' do
    'hello Aesmb'
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

  not_found do
    @error ||= {
      error: 'page_not_found',
      error_description: 'Check API documentation.'
    }
    @error.to_json
  end
end

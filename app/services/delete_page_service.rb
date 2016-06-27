require_relative '../repositories/page_repository'
require_relative 'helpers/page_service_helpers'

class DeletePageService
  include Wisper::Publisher
  include PageServiceHelpers

  def call(params)
    repo = PageRepository.new
    page = repo.find(params[:id])
    return unless page_exists?(page)
    repo.delete page
  end
end

require_relative '../repositories/page_repository'
require_relative 'helpers/page_service_helpers'

class UpdatePageService
  include Wisper::Publisher
  include PageServiceHelpers

  def call(params)
    unless params[:title].nil?
      return if page_title_empty?(params)
    end
    repo = PageRepository.new
    page = repo.find(params[:id])
    return unless page_exists?(page)
    page.merge(params)
    page.updated_at = Time.now
    repo.update(page)
  end
end

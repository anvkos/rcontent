require_relative '../repositories/page_repository'
require_relative 'helpers/page_service_helpers'

class CreatePageService
  include Wisper::Publisher
  include PageServiceHelpers

  def call(params)
    return if page_title_empty?(params)
    repo = PageRepository.new
    page = Page.new(params.to_h)
    page.created_at = Time.now
    repo.create(page)
  end
end

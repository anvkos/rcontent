require_relative '../repositories/tag_repository'
require_relative 'helpers/tag_service_helpers'

class GetTagService
  include Wisper::Publisher
  include TagServiceHelpers

  def call(params)
    repo = TagRepository.new
    tag = repo.find(params[:id])
    return unless tag_exists?(tag)
    tag
  end
end

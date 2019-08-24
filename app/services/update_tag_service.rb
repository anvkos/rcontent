require_relative '../repositories/tag_repository'
require_relative 'helpers/tag_service_helpers'

class UpdateTagService
  include Wisper::Publisher
  include TagServiceHelpers

  def call(params)
    unless params[:name].nil?
      return if tag_name_empty?(params)
    end
    repo = TagRepository.new
    tag = repo.find(params[:id])
    return unless tag_exists?(tag)
    tag.merge(params)
    tag.updated_at = Time.now
    repo.update(tag)
  end
end

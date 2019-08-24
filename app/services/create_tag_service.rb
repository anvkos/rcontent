require_relative '../repositories/tag_repository'
require_relative 'helpers/tag_service_helpers'

class CreateTagService
  include Wisper::Publisher
  include TagServiceHelpers

  def call(params)
    return if tag_name_empty?(params)
    repo = TagRepository.new
    tag = Tag.new(params.to_h)
    tag.created_at = Time.now
    repo.create(tag)
  end
end

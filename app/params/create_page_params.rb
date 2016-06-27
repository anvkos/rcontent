require_relative 'base_params'

class CreatePageParams < BaseParams
  attribute :active,  type: Boolean
  attribute :slug,    type: String
  attribute :title,   type: String
  attribute :content, type: String
  attribute :image,   type: String
end

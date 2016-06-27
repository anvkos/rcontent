require_relative 'base_params'

class UpdatePageParams < BaseParams
  attribute :id,      type: Integer
  attribute :active,  type: Boolean
  attribute :slug,    type: String
  attribute :title,   type: String
  attribute :content, type: String
  attribute :image,   type: String
end

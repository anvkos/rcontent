require_relative 'base_params'

class CreateTagParams < BaseParams
  attribute :slug,    type: String
  attribute :name,    type: String
end

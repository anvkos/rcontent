require_relative 'base_params'

class UpdateTagParams < BaseParams
  attribute :id,         type: Integer
  attribute :slug,       type: String
  attribute :name,       type: String
  attribute :created_at, type: Time
  attribute :updated_at, type: Time
end

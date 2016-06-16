require 'hanami/validations'

class GetPageParams
  include Hanami::Validations

  attribute :id,      type: Integer
  attribute :active,  type: Boolean
  attribute :slug,    type: String
  attribute :title,   type: String
  attribute :content, type: String
  attribute :image,   type: String
  attribute :created_at, type: Time
  attribute :updated_at, type: Time

  def [](key)
    send key.to_sym
  end
end

require 'hanami/validations'

class CreatePageParams
  include Hanami::Validations

  attribute :active,  type: Boolean
  attribute :slug,    type: String
  attribute :title,   type: String
  attribute :content, type: String
  attribute :image,   type: String

  def [](key)
    send key.to_sym
  end
end

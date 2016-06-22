require 'hanami/validations'

class UpdatePageParams
  include Hanami::Validations

  attribute :id,      type: Integer
  attribute :active,  type: Boolean
  attribute :slug,    type: String
  attribute :title,   type: String
  attribute :content, type: String
  attribute :image,   type: String

  def [](key)
    send key.to_sym
  end
end

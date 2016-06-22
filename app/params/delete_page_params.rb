require 'hanami/validations'

class DeletePageParams
  include Hanami::Validations

  attribute :id, type: Integer

  def [](key)
    send key.to_sym
  end
end

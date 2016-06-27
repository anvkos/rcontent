require 'hanami/validations'

class BaseParams
  include Hanami::Validations

  def [](key)
    send key.to_sym
  end
end

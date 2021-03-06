require 'virtus'

class Tag
  include Virtus.model

  attribute :id,         Integer
  attribute :name,       String
  attribute :slug,       String
  attribute :created_at, Time
  attribute :updated_at, Time

  def to_db
    {
      id: id,
      name: name,
      slug: slug,
      created_at: created_at,
      updated_at: updated_at
    }.delete_if { |_, v| v.nil? }
  end

  def merge(attributes)
    attributes.each do |key, val|
      self[key] = val if respond_to?(key)
    end
  end

  def self.from_db(data)
    attributes = {
      id: data[:id],
      name: data[:name],
      slug: data[:slug],
      created_at: data[:created_at],
      updated_at: data[:updated_at]
    }.delete_if { |_, v| v.nil? }
    new(attributes)
  end
end

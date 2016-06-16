require 'virtus'

class Page
  include Virtus.model

  attribute :id
  attribute :active,     Boolean, default: false
  attribute :slug,       String
  attribute :title,      String
  attribute :content,    String
  attribute :image,      String
  attribute :created_at, Time
  attribute :updated_at, Time

  def to_db
    {
      id: id,
      active: (active ? 1 : 0),
      slug: slug,
      title: title,
      content: content,
      image: image,
      created_at: created_at,
      updated_at: updated_at
    }.delete_if { |_, v| v.nil? }
  end

  def self.from_db(data)
    attributes = {
      id: data[:id],
      active: data[:active] == 1,
      slug: data[:slug],
      title: data[:title],
      content: data[:content],
      image: data[:image],
      created_at: data[:created_at],
      updated_at: data[:updated_at]
    }.delete_if { |_, v| v.nil? }
    new(attributes)
  end
end

require_relative '../models/tag'

class TagRepository
  def find(id)
    find_by(id: id)
  end

  def create(tag)
    tag.id = table.insert(tag.to_db)
    tag
  end

  def update(tag)
    table.where(id: tag.id).update(tag.to_db)
    tag
  end

  def delete(tag)
    table.where(id: tag.id).delete
  end

  private

  def find_by(params)
    data = table.where(params).first
    return nil if data.nil?
    Tag.from_db(data)
  end

  def table
    @db ||= DB.connection
    @db[:tags]
  end
end

require_relative '../models/page'

class PageRepository
  def find(id)
    find_by(id: id)
  end

  def create(page)
    page.id = table.insert(page.to_db)
    page
  end

  def update(page)
    table.where(id: page.id).update(page.to_db)
    page
  end

  def delete(page)
    table.where(id: page.id).delete
  end

  private

  def find_by(params)
    data = table.where(params).first
    return nil if data.nil?
    Page.from_db(data)
  end

  def table
    @db ||= DB.connection
    @db[:pages]
  end
end

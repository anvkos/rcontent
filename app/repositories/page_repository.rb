require_relative '../models/page'

class PageRepository
  def find(id)
    find_by(id: id)
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

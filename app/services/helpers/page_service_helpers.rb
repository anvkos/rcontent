module PageServiceHelpers
  private

  def page_exists?(page)
    if page.nil?
      broadcast(:page_not_found)
      false
    else
      true
    end
  end

  def page_title_empty?(params)
    if params[:title].nil? || params[:title].empty?
      broadcast(:page_title_empty)
      true
    end
  end
end

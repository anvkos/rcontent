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
end

module TagServiceHelpers
  private

  def tag_exists?(tag)
    if tag.nil?
      broadcast(:tag_not_found)
      false
    else
      true
    end
  end

  def tag_name_empty?(params)
    if params[:name].nil? || params[:name].empty?
      broadcast(:tag_name_empty)
      true
    end
  end
end

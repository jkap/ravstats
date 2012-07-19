module ApplicationHelper

  def title
    if @title
      "#{@title} - RavStats!"
    else
      "RavStats!"
    end
  end

  def set_title(title)
    @title = title
  end
end

module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end

end

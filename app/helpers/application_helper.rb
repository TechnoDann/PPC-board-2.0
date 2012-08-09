module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end

  def markdown(text)
    options = {:auto_links => true, :escape_html => true}
    BlueCloth::new(text, options).to_html.html_safe
  end
end

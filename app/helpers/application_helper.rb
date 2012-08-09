module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end
  
  class MarkdownHolder
    @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:filter_html => false), {
                                           :autolink => true, :strikethrough => true,
                                           :lax_html_blocks => true, :superscript => true})
    def self.renderer
      @@markdown
    end
  end

  def markdown(text)
    MarkdownHolder.renderer.render(text)
  end
end

module ApplicationHelper
  #HTML cleaner configs
  DefaultCleaner = {
    :elements => %w[
        a abbr b bdo blockquote br caption cite code col colgroup dd
        del dfn dl dt em figcaption font figure h1 h2 h3 h4 h5 h6
        hgroup hr i img ins kbd li mark ol p pre q rp rt ruby s samp
        small strike strong sub sup table tbody td tfoot th thead time
        tr u ul var wbr
      ],
    
    :attributes => {
      :all         => ['dir', 'lang', 'title'],
      'a'          => ['href'],
      'blockquote' => ['cite'],
      'col'        => ['span', 'width'],
      'colgroup'   => ['span', 'width'],
      'del'        => ['cite', 'datetime'],
      'font'       => ['color', 'size'],
      'img'        => ['align', 'alt', 'height', 'src', 'width'],
      'ins'        => ['cite', 'datetime'],
      'ol'         => ['start', 'reversed', 'type'],
      'q'          => ['cite'],
      'table'      => ['summary', 'width'],
      'td'         => ['abbr', 'axis', 'colspan', 'rowspan', 'width'],
      'th'         => ['abbr', 'axis', 'colspan', 'rowspan', 'scope', 'width'],
      'time'       => ['datetime', 'pubdate'],
      'ul'         => ['type']
    },
    
    :protocols => {
      'a'          => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
      'blockquote' => {'cite' => ['http', 'https', :relative]},
      'del'        => {'cite' => ['http', 'https', :relative]},
      'img'        => {'src'  => ['http', 'https', :relative]},
      'ins'        => {'cite' => ['http', 'https', :relative]},
      'q'          => {'cite' => ['http', 'https', :relative]}
    }
  }

  TitleCleaner = {
    :elements => %w[b em i strong]
  }

  def title(page_title)
    content_for(:title) { page_title }
  end

  class MarkdownHolder
    @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, {
                                           :autolink => true, :strikethrough => true,
                                           :lax_html_blocks => true, :superscript => true})
    def self.renderer
      @@markdown
    end
  end

  def markdown(text)
    MarkdownHolder.renderer.render(Sanitize.clean(text, DefaultCleaner) || "")
  end

  def htmlic_title(text)
      Sanitize.clean(text, TitleCleaner)
  end
end

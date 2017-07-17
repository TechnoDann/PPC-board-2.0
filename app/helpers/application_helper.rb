module ApplicationHelper
  #HTML cleaner configs
  DefaultCleaner = {
    :elements => %w[
        a abbr address article aside b bdi bdo blockquote br caption
        cite code col colgroup dd del dfn dl dt em figcaption font
        figure h1 h2 h3 h4 h5 h6 header hgroup hr i img ins kbd li
        mark ol p pre q rp rt ruby s samp section small span strike
        strong sub summary sup table tbody td tfoot th thead time tr
        tt u ul var wbr
      ],

    :attributes => {
      :all         => ['dir', 'lang', 'title'],
      'a'          => ['href', 'title'],
      'abbr'       => ['title'],
      'blockquote' => ['cite'],
      'col'        => ['span', 'width'],
      'colgroup'   => ['span', 'width'],
      'del'        => ['cite', 'datetime'],
      'dfn'        => ['cite'],
      'font'       => ['color', 'size'],
      'img'        => ['align', 'alt', 'height', 'src', 'width'],
      'ins'        => ['cite', 'datetime'],
      'ol'         => ['start', 'reversed', 'type'],
      'q'          => ['cite'],
      'span'       => ['style'],
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
    },

    :css => {
      :properties => ['font', 'font-family', 'font-size', 'color']
    }
  }

  TitleCleaner = {
    :elements => %w[b em i strong del]
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
    def self.renderer= (other)
      @@markdown = other
    end

    def self.shadow_with_extensions(ext_hash)
      old = @@markdown
      @@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, ext_hash)
      return old
    end
  end

  def markdown(text)
    MarkdownHolder.renderer.render(Sanitize.clean(text, DefaultCleaner) || "")
  end

  def htmlic_title(text)
      Sanitize.clean(text, TitleCleaner)
  end

  def render_subthread_as_archive(hash)
    ret = []
    if hash == nil
      return ret
    end
    for post, subthreads in hash do
      if post.next_version
        next
      end
      ret << {:subject => htmlic_title(post.subject),
              :author => post.author,
              :timestamp => post.sort_timestamp,
              :body => markdown(post.body).gsub("*","\\*").gsub("^", "\\^").gsub("`", "\\\\`"),
              :source => "/posts/" + String(post.id)
      }
      ret << render_subthread_as_archive(subthreads)
    end
    return ret
  end

  def dump_posts_in_range(from_date, to_date)
    ret = []
    conditions = {:ancestry => nil, :next_version_id => nil,
                  :sort_timestamp => from_date .. to_date}
    Post.where(conditions).order("sort_timestamp DESC").each do |root|
         thread = Post.arrange_nodes(root.subtree.select(:body)
                                      .order("ancestry NULLS FIRST, sort_timestamp DESC").load)
         ret << render_subthread_as_archive(thread)
    end
    return Marshal.dump(ret)
  end
end

require 'rubygems'
require 'mechanize'

module S#cript (that archives)
  @@agent = Mechanize.new

  def S.scrape_body(link)
    page = @@agent.click(@@page.link_with( :href => link))
    info = 
    { :author => page.search(".author_header").first.content,
      :subject => page.search("span.subject_header").first.content,
      :timestamp => Time.parse(page.search("span.date_header").first.content + " -0500").utc,
      :body => page.search("div.message_text").first.inner_html
    }
    @@agent.back
    info
  end
  
  def S.find_subthreads(ul)
    ret = []
    if ul == nil
      return ret
    end
    ul.children.filter("li").each do |node|
      if node['class'] == "message_entry "
        ret << S.scrape_body(node.search("a").first['href'])
      elsif node['class'] = "nested_list"
        ret << S.find_subthreads(node.children.first)
      else
        puts "Can't happen"
      end
    end
    ret
  end
  
  def S.serialize_thread(thread_div)
    ret = [S.scrape_body(thread_div.search("div.first_message_div a").first['href'])]
    ul = thread_div.search("div.responses").children
    if ul
      ret << find_subthreads(ul.first) # Is gauranteed to be a <ul>
    end
    ret
  end
  
  def S.scrape_threads(url)
    @@page = @@agent.get(url)
    @@page.search("div#threads div.thread").map { |t| S.serialize_thread t }
  end

end
pp S.scrape_threads("http://disc.yourwebapps.com/Indices/241484.html")

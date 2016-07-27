#!/usr/bin/env ruby
#Usage: ./archive-script [url]
require 'rubygems'
require 'mechanize'

module S#cript (that archives)
  @@agent = Mechanize.new

  def S.try_encode(str)
    begin
      str.encode("UTF-8", "Windows-1251")
    rescue
      str
    end
  end

  def S.scrape_body(link)
    $stderr.puts(link)
    page = @@agent.click(@@page.link_with( :href => link))
    info =
    { :author => S.try_encode(page.search(".author_header").first.content),
      :subject => S.try_encode(page.search("span.subject_header").first.content),
      :timestamp => Time.parse(page.search("span.date_header").first.content + " -0500").utc,
      :body => S.try_encode(page.search("div.message_text").first.inner_html).gsub("\*","\\\*")
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
      if node['class'] == "message_entry " or node['class'] == "message_entry new_message"
        ret << S.scrape_body(node.search("a").first['href'])
      elsif node['class'] = "nested_list"
        ret << S.find_subthreads(node.children.first)
      else
        $stderr.puts "Can't happen"
      end
    end
    ret
  end

  def S.serialize_thread(thread_div)
    ret = [S.scrape_body(thread_div.search("div.first_message_div a").first['href'])]
    ul = thread_div.search("div.responses li.nested_list").children
    if ul
      ret << find_subthreads(ul.first) # Is gauranteed to be a <ul>
    end
    ret
  end

  def S.scrape_threads()
    threads = []
    while @@page
      @@page.search("div#threads div.thread").each { |t| threads << S.serialize_thread(t) }
      forms = @@page.forms.find_all { |f| f.button_with :name => 'nextpage' }
      if forms != []
        @@page = forms.first.submit
      else
        @@page = nil
      end
    end
    threads
  end

  def S.scrape_board(url)
    @@page = @@agent.get(url)
    S.scrape_threads
  end
end
Marshal.dump(S.scrape_board(ARGV[0]), $stdout)
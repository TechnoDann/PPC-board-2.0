require 'rubygems'
require 'mechanize'

def scrape_body(page)
  { :author => page.search("span.author_header").first.content,
    :subject => page.search("span.subject_header").first.content,
    :timestamp => Time.parse(page.search("span.date_header").first.content + " -0500").utc,
    :body => page.search("div.message_text").first.content }
end

agent = Mechanize.new

puts scrape_body(agent.get("http://disc.yourwebapps.com/discussion.cgi?disc=199610;article=228586;title=PPC%20Posting%20Board"))

puts scrape_body(agent.get("http://disc.yourwebapps.com/discussion.cgi?disc=199610;article=228570;title=PPC%20Posting%20Board"))

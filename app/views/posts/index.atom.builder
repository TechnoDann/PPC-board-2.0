atom_feed do |feed|
  feed.title("Threads from the PPC Posting Board")
  feed.updated(Post.order("created_at DESC").first.created_at ) if @posts.length > 0

  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.subject)
      if post.body
        entry.content(markdown(post.body), :type => 'html')
      else
        entry.content("No body provided.", :type => 'text')
      end
      entry.author do |author|
        author.name(post.author)
        author.url(user_url(post.user, :only_path => false))
      end
    end
  end
end


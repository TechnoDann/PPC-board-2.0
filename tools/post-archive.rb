# Usage: rails c < tools/post-archive.rb (change file name)
class Hash
  #http://stackoverflow.com/questions/6227600/how-to-remove-a-key-from-hash-and-get-the-remaining-hash-in-ruby-rails
  def remove!(*keys)
    keys.each{|key| self.delete(key) }
    self
  end
  def remove(*keys)
    self.dup.remove!(*keys)
  end
end
def read_archive(filename)
  file = File.open(filename)
  ret = Marshal.load(file)
  file.close
  ret
end
def post_archive(archive, parent, user)
  parent_id = nil
  archive.each do |entity|
    if entity.is_a?(Hash)
      safe_hash = entity.remove(:timestamp).merge!({:parent_id => parent})
      post = Post.new(safe_hash)
      post.user = user
      post.save
      parent_id = post.id
      post.created_at = entity[:timestamp]
      post.sort_timestamp = post.created_at
      post.save
    elsif entity.is_a?(Array)
      unless entity == []
        # Subthread of the post we last posted
        post_archive(entity, parent_id, user)
      end
    else
      puts("Can't happen")
    end
  end
end
def post_threads
  user = User.find_by_name("Archive Script")
  board = read_archive("/tmp/threads-to-read")
  board.each do |thread|
    post_archive thread, nil, user
    true
  end
  true
end
post_threads

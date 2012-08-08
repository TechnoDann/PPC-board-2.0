module PostsHelper
  def reSorted?(post)
    (post.sort_timestamp - post.created_at).abs > 60
  end
end

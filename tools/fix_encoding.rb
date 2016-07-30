def reencode(str)
  if str.ascii_only? then
    return false
  end
  begin
    back = str.encode('windows-1251', 'utf-8')
    forward = back.encode('utf-8', 'windows-1252')
    if forward != back then
      return forward
    else
      return false
    end
  rescue
    return false
  end
end

the_user_id = User.find_by_name("Archive Script").id

subj_count = 0
body_count = 0
start_date = DateTime.new(2016).beginning_of_year
Post.select(:body).find_each do |post|
  if post.user_id = the_user_id and post.sort_timestamp >= start_date
    new_subj = reencode(post.subject)
    new_body = reencode(post.body)
    if new_subj then
      subj_count += 1
      print "#{post.id}.subject:\n#{post.subject}\n---\n#{new_subj}\n"
      post.subject = new_subj
    end
    if new_body then
      body_count += 1
      #print "#{post.id}.body:\n#{post.body}\n---\n#{new_body}\n"
      post.body = new_body
    end
    if new_subj or new_body then
      post.save
    end
  end
end
puts subj_count
puts body_count

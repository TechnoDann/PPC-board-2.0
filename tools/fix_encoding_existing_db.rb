def reencode(str)
  if str.ascii_only? then
    return false
  end
  # Interpret UTF-8 (that came from windows-1252 interpreted as windows-1251)
  # as windows-2151. This produces `back`. This gives the original source bytes
  # if the input string was mis-reencoded.
  # Then, take the bytes, interpret as windows-1252, and cast to utf-8
  # If the strings are different, there was a misencoding during initial archiving
  # If they aren't or exceptions are raised, the string was UTF-8 in the first place
  # This is more or less safe because people don't post long stretches of Cycillic on the Board
  # and those would have been UTF-8 anyway
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
Post.select(:body).find_each do |post|
  if post.user_id == the_user_id
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

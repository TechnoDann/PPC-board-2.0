#!/usr/bin/env ruby
# Usage: ./fix_old_archive.rb [in archive] [out archive]
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

def fix_post(post_hash)
  maybe_reencoded_subject = reencode(post_hash[:subject])
  maybe_reencoded_body = reencode(post_hash[:body])
  if maybe_reencoded_subject
    post_hash[:subject] = maybe_reencoded_subject
  end
  if maybe_reencoded_body
    post_hash[:body] = maybe_reencoded_body
  end
  reescaped_body = post_hash[:body].gsub("^", "\\^").gsub("`", "\\\\`")
  if reescaped_body != post_hash[:body]
    post_hash[:body] = reescaped_body
  end
  return post_hash
end

def fix_posts(archive)
  return archive.map do |p|
    if p.is_a?(Hash)
      fix_post(p)
    else
      fix_posts(p)
    end
  end
end

out_file = if ARGV.length >= 2 then File.open(ARGV[1], "wb") else $stdout end
in_file = if ARGV.length >= 1 then File.open(ARGV[0], "rb") else $stdin end
Marshal.dump(fix_posts(Marshal.load(in_file)), out_file)

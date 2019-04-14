PPC Posting Board 2.0
=====================
NOTE: ** Archives generated before 2017 should to be run through `tools/fix_old_archive.rb` before being imported into fresh installations**

Ahoy there!

This is a little project to build a web 1.5 posting board. The
community is currently using an ancient bulletin-board system, several
members have been extolling the virtues of a PHPbb setup with
subforums and whatnot, and I opened my big fat mouth and said "Hey!
This looks like a perfect use for the Model-View-Controller design
pattern!"

I may come to regret this.

Design documents should all be OS-agnostic, in the doc/ directory.

What to expect:
 * Ruby on Rails
 * One set of posts, many ways to look at it
 * Optional authentication, with options

What not to expect:
 * Magic
 * Fast development
 * Incredibly mind-blowing code

Note: to archive a running T-Board into the usual format, execute
`include ApplicationHelper; ApplicationController.helpers.dump_posts_in_range(from_date, to_date)`
and get the resulting string into a file somewhere (Heroku wants base64 and some newlines after this to prevent data loss)

Developers:
 * Tomash ( krzysdrewniak@gmail.com )
 * Delta Juliette (AKA Captain Vim, Techno.Dann@gmail.com)
Development setup
-----------------
Please copy `config/database.yml.example` to `config/database.yml` and
customize it to fit your local database setup. Please do the same for
`config/mailers.yml.example`.

How to update the archives
--------------------------
- Install `mechanize` (it's not in the Gemfile)
- `./tools/archive-script.rb 'http://disc.yourwebapps.com/Indices/199610.html' >scrape-output-file  2>scrape.log`
- Make sure your instance has a user named "Archive Script" (and note their ID, it'll be important later)
- `rake db:post_archive FILE=scrape-output-file LINK_MAP_FILE=link-map-raw.csv`
- `heroku run rails runner 'include ApplicationHelper; puts(Base64.encode64(ApplicationController.helpers.dump_posts_in_range(Time.parse("YYYY-MM-DD 00:00:00 UTC"), Time.now))); puts("")' > /tmp/t-board-archive`
- `base64 -d /tmp/t-board-archive > t-board-scrape-file` after cleaning out the error messages and ^Ms (and trailing newline) from the output of the above command
- `rake db:post_archive FILE=t-board-scrape-file LINK_MAP_FILE=t-board-link-map-raw.csv`
- `bundle exec unicorn -p 3000 -c ./config/unicorn.rb ` to start the server
- `for y in {2008..2019}; do; for m in {01..12}; do; for p in a b c; do; echo "http://localhost:3000/posts/scrape/$y/$m$p?user_id=N" >> /tmp/urls; done; done; done`, where `N` is the user id of "Archive Script"
- `wget -E -k -p --header "Cookie: foo=bar" -i /tmp/urls`
- `git checkout gh-pages`
- `./tools/scrape-output-transform.pl localhost:3000/posts/scrape archive`
- `./tools/transform-link-map.pl t-board-august-2018-to-april-2019-link-map-raw.csv archive/t-board-august-2018-to-april-2019-link-map.csv`
- `./tools/transform-link-map.pl board-may-2016-to-apr-2019-link-map-raw.csv archive/board-may-2016-to-apr-2019-link-map.csv`
- Edit `archive/index.html` to point to all the new stuff (probably by copy-paste and search-replace)
- Commit and push

Licensing
---------

Copyright (C) 2012 PPC Posting Board 2.0 Team

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

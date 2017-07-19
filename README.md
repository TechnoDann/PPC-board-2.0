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

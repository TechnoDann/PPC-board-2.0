#Usage: rake db:dump_archive > file
require 'csv'
namespace :db do
  desc "Dump the archive to a CSV file"
  task :dump_archive => :environment do
    roots = Post.where(:ancestry => nil, :next_version_id => nil,
                       :user_id => User.find_by_name("Archive Script").id)
      .order("sort_timestamp DESC")
    CSV($stdout) do |csv|
      csv << ["id", "sort_timestamp", "ancestry", "author", "subject", "body"]
      def recurse(tree,csv)
        tree.each do |k,v|
          csv << [k.id, k.sort_timestamp, k.ancestry, k.author, k.subject, k.body]
          recurse(v,csv)
        end
      end
      roots.each do |root|
        posts = root.subtree.select(:body).arrange(:order => "sort_timestamp DESC")
        recurse(posts,csv)
      end
    end
  end
end

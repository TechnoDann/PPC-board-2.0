class Post < ActiveRecord::Base
  has_ancestry
  attr_accessible :body, :subject, :author, :parent_id
  attr_accessible :author, :body, :subject, :locked, :poofed, :sort_timestamp, :parent_id , :as => :moderator
  before_create :set_sort_timestamp
  
  belongs_to :previous_version, :class_name => 'Post', :foreign_key => 'previous_version_id'
  private
  def set_sort_timestamp
    self.sort_timestamp = Time.now()
  end
end

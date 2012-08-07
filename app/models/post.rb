class Post < ActiveRecord::Base
  attr_accessible :body, :subject, :author
  attr_accessible :author, :body, :subject, :locked, :poofed, :sort_timestamp, :as => :moderator
  acts_as_nested_set
  after_create :set_sort_timestamp
  
  private
  def set_sort_timestamp
    self.sort_timestamp = self.created_at
  end
end

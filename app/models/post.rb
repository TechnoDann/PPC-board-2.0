class Post < ActiveRecord::Base
  has_ancestry
  attr_accessible :body, :subject, :author, :parent_id
  attr_accessible :author, :body, :subject, :locked, :poofed, :sort_timestamp, :parent_id , :as => :moderator
  before_create :set_sort_timestamp
  
  private
  def set_sort_timestamp
    self.sort_timestamp = Time.now()
  end
end

class Post < ActiveRecord::Base
  has_ancestry
  attr_accessible :body, :subject, :author, :parent_id
  attr_accessible :author, :body, :subject, :locked, :poofed, :sort_timestamp, :parent_id , :as => :moderator
  before_create :set_sort_timestamp

  belongs_to :previous_version, :class_name => 'Post', :foreign_key => 'previous_version_id'
  belongs_to :next_version, :class_name => 'Post', :foreign_key => 'next_version_id' 

  validate :no_memory_hole
  def clone_before_edit
    clone = Post.new
    attrs = self.attributes
    attrs.delete("id")
    clone.update_attributes(attrs, :without_protection => true)
    clone.next_version = self
    clone.sort_timestamp = self.sort_timestamp
    clone.save
    clone
  end
  
  def close_edit_cycle(clone)
    self.previous_version = clone
    self.save :validate => false
  end

  private
  def no_memory_hole
    if self.next_version && self.next_version.previous_version == self
      errors[:base] << "You aren\'t allowed to edit anything other than the current version of a post. What is this, 1984?"
    end
  end

  def set_sort_timestamp
    self.sort_timestamp = Time.now()
  end
end

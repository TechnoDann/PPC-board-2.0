class Post < ActiveRecord::Base
  has_ancestry
  attr_accessible :body, :subject, :author, :parent_id
  attr_accessible :author, :body, :subject, :locked, :poofed, :sort_timestamp, :parent_id , :as => :moderator
  before_create :set_sort_timestamp

  belongs_to :previous_version, :class_name => 'Post', :foreign_key => 'previous_version_id'
  belongs_to :next_version, :class_name => 'Post', :foreign_key => 'next_version_id' 

  validate :no_memory_hole
  validate :no_locked_reply, :on => :create
  validates :subject, :author, :presence => true

  def clone_before_edit
    clone = Post.new
    attrs = self.attributes
    attrs.delete("id")
    clone.update_attributes(attrs, :without_protection => true)
    clone.being_cloned = true
    # Note, all pasts of a post have a next_version of the most recent version.
    # This is now a feature.
    clone.next_version = self
    logger.debug "Clone before save, after assignment: #{clone.attributes.inspect}\n"
    clone.sort_timestamp = self.sort_timestamp
    clone.save
    logger.debug "Clone after save, after assignment: #{clone.attributes.inspect}\n"
    clone
  end
  
  def close_edit_cycle(clone)
    self.previous_version = clone
    self.being_cloned = false
    self.save :validate => false
  end

  private
  def no_memory_hole
    if self.next_version && !self.being_cloned
      errors[:base] << "You aren\'t allowed to edit anything other than the current version of a post. What is this, 1984?"
    end
  end

  def no_locked_reply
    if self.locked || self.ancestors.where(:locked => true).count > 0
      errors[:base] << "You aren't allowed to reply to locked threads."
    end
  end

  def set_sort_timestamp
    self.sort_timestamp = Time.now()
  end
end

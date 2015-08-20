class Post < ActiveRecord::Base
  has_ancestry
  lazy_load :body

  attr_readonly :parent_id
  before_create :set_sort_timestamp

  belongs_to :previous_version, :class_name => 'Post', :foreign_key => 'previous_version_id'
  belongs_to :next_version, :class_name => 'Post', :foreign_key => 'next_version_id'
  has_and_belongs_to_many :tags
  belongs_to :user
  has_and_belongs_to_many :watchers, -> { uniq }, :class_name => 'User'

  validate :no_memory_hole
  validate :no_locked_reply, :on => :create
  validates :subject, :author, :user_id, :presence => true
  validates_length_of :subject, :maximum => 105
  validates_length_of :author, :maximum => 80

  self.per_page = 30

  def clone_before_edit
    clone = Post.new
    load_body = self.body # Skip lazy_columns
    attrs = self.attributes
    attrs.delete("id")
    clone.update_attributes(attrs, :without_protection => true)
    clone.being_cloned = true
    # Note, all pasts of a post have a next_version of the most recent version.
    # This is now a feature.
    clone.next_version = self
    clone.sort_timestamp = self.sort_timestamp
    clone.save
    clone.being_cloned = false
    clone.save :validate => false
    clone
  end
  
  def close_edit_cycle(clone)
    self.previous_version = clone
    self.save
  end

  def new_reply?
    (Time.now - self.created_at < 24.hours) && (Time.now - self.root.created_at > 24.hours) && !self.is_root?
  end

  def reSorted?
    (self.sort_timestamp - self.created_at).abs > 60
  end

  private
  def no_memory_hole
    self.next_version
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

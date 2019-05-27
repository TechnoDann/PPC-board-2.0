# frozen_string_literal: true
class Post < ApplicationRecord
  ## NOTE: next_version should be current_version,
  ## but renaming it to reflect the actual semantics of the code seems tricky
  has_ancestry orphan_strategy: :adopt
  lazy_load :body

  attr_readonly :parent_id
  before_create :set_sort_timestamp

  before_destroy :destroy_past_versions
  before_destroy :remove_previous_version_reference

  belongs_to :previous_version, :class_name => 'Post', :foreign_key => 'previous_version_id', :optional => true
  belongs_to :next_version, :class_name => 'Post', :foreign_key => 'next_version_id', :optional => true
  has_and_belongs_to_many :tags
  belongs_to :user
  has_and_belongs_to_many :watchers, -> { uniq }, :class_name => 'User'

  validate :no_memory_hole
  validate :no_locked_reply, :on => :create
  validate :flood_prevention, :on => :create
  validates :subject, :author, :user_id, :presence => true
  validates_length_of :subject, :maximum => 105
  validates_length_of :author, :maximum => 80

  attr_accessor :watch_add
  attr_accessor :being_cloned
  attr_accessor :recursive_destroy

  self.per_page = 25

  include PgSearch
  pg_search_scope :text_search,
                  :against => {:subject => 'A', :author => 'C', :body => 'B'},
                  :using => {:tsearch => {:prefix => true,
                                          :negation => true,
                                          :dictionary => "english",
                                          :highlight => {
                                            :start_sel => "<b>",
                                            :stop_sel => "</b>",
                                            :max_fragments => 5
                                          }
                                         }},
                  :order_within_rank => "sort_timestamp DESC"
  def clone_before_edit
    clone = Post.new
    load_body = self.body # Skip lazy_columns
    attrs = self.attributes
    attrs.delete("id")
    clone.update(attrs)
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
    if self.locked || self.ancestors.where(:locked => true).exists?
      errors[:base] << "You aren't allowed to reply to locked threads."
    end
  end

  def flood_prevention
    if Post.where(:user_id => self.user_id, :created_at => 1.minute.ago .. Time.now).exists?
      errors[:base] << "You can only create one post every minute to prevent spam"
    end
  end

  def set_sort_timestamp
    if not self.sort_timestamp
      self.sort_timestamp = Time.now()
    end
  end

  def destroy_past_versions
    if not self.recursive_destroy
      current = self
      next_post = nil
      while current != nil
        next_post = current.previous_version
        current.previous_version_id = nil
        current.being_cloned = true
        current.save!
        current.being_cloned = false
        if current != self
          current.recursive_destroy = true
          current.destroy!
        end
        current = next_post
      end
    end
  end

  def remove_previous_version_reference
    if (not self.recursive_destroy) && self.next_version_id != nil
      self_id = self.id
      probe = self.next_version
      while probe.previous_version_id != self_id
        probe = probe.previous_version
      end
      probe.previous_version_id = nil
      probe.being_cloned = true
      probe.save!
      probe.being_cloned = false
    end
  end
end

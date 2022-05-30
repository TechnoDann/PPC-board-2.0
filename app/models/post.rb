# frozen_string_literal: true
class Post < ApplicationRecord
  ## NOTE: next_version should be current_version,
  ## but renaming it to reflect the actual semantics of the code seems tricky
  has_ancestry orphan_strategy: :adopt
  lazy_load :body

  attr_readonly :parent_id
  before_create :set_sort_timestamp

  before_destroy :drop_from_edit_chain
  before_destroy :migrate_next_version

  after_save :invalidate_thread_cache

  belongs_to :previous_version, :class_name => 'Post', :foreign_key => 'previous_version_id', :optional => true
  belongs_to :next_version, :class_name => 'Post', :foreign_key => 'next_version_id', :optional => true
  has_and_belongs_to_many :tags
  belongs_to :user
  has_and_belongs_to_many :watchers, -> { distinct }, :class_name => 'User'

  validate :no_memory_hole, :on => :update
  validate :no_locked_reply, :on => :create
  validate :flood_prevention, :on => :create
  validates :subject, :author, :user_id, :presence => true
  validates_length_of :subject, :minimum => 1, :maximum => 105
  validates_length_of :author, :minimum => 1, :maximum => 80

  attr_accessor :watch_add
  attr_accessor :override_sort_timestamp

  attr_accessor :being_cloned

  self.per_page = 25

  def self.searchable_language
    'english'
  end
  def self.searchable_columns
    [:subject, :author, :body]
  end

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
    clone.save!
    clone.being_cloned = false
    clone
  end

  def close_edit_cycle(clone)
    self.previous_version = clone
    self.save!
  end

  DAY = 24.hours

  def recent?
    Time.now - self.created_at < DAY
  end

  def new_reply?
    (Time.now - self.created_at < DAY) && (Time.now - self.root.created_at > DAY) && !self.is_root?
  end

  def seeing_activity?
    (Time.now - self.updated_at) < DAY
  end

  def reSorted?
    (self.sort_timestamp - self.created_at).abs > 60
  end

  private

  def no_memory_hole
    self.next_version
    if self.next_version && !self.being_cloned
      errors.add(:base, "You aren\'t allowed to edit anything other than the current version of a post. What is this, 1984?")
    end
  end

  def no_locked_reply
    if self.locked || self.ancestors.where(:locked => true).exists?
      errors.add(:base, "You aren't allowed to reply to locked threads.")
    end
  end

  def flood_prevention
    if !Rails.env.test? && !self.being_cloned &&
       Post.where(:user_id => self.user_id, :created_at => 10.second.ago..Time.now).exists?
      errors.add(:base, "You can only create one post every 10 seconds to prevent spam")
    end
  end

  def set_sort_timestamp
    if (not self.sort_timestamp) || (self.override_sort_timestamp != "1")
      self.sort_timestamp = Time.now
    end
  end

  def drop_from_edit_chain
    Post.where(:previous_version => self).each do |p|
      p.previous_version = self.previous_version
      p.being_cloned = true
      p.save!
      p.being_cloned = false
    end
  end

  def migrate_next_version
    Post.where(:next_version => self).each do |p|
      if self.previous_version == p
        p.next_version = nil
        p.save!
      else
        p.next_version = self.previous_version
        p.being_cloned = true
        p.save!
        p.being_cloned = false
      end
    end
  end

  def invalidate_thread_cache
    self.root.touch
  end
end

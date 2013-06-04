ThinkingSphinx::Index.define :post, :with => :active_record do
  indexes body
  indexes author
  indexes user.name, :as => :real_author
  indexes subject
  indexes tags.name, :as => :tags
  has sort_timestamp
end

class TaskTag
  
  def self.all_tags(opts={})
    Task.all.collect(&:tags).flatten.uniq
  end
  
  def self.tag_count_for(tag)
    Task.count(:tags => [tag])
  end
end
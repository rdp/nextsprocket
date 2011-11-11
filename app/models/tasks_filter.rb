class TasksFilter
  attr_accessor :terms, :category, :programming_language, :reward_low, :reward_high, :status
  
  def id
    ""
  end

  # Author:: Nitin Shantharam (mailto:nitin@)
  def initialize(params = {})
    params.each{|k,v| send("#{k}=", v) unless v == "ANY"} if params
  end

  def to_params
    options = {}
    [:terms, :category, :programming_language, :reward_low, :reward_high, :status].collect do |param|
      options[param] = self.send(param) unless self.send(param).blank?
    end

    options
  end

  def to_finder_options
    options = {}
    
    options[:title] = /#{Regexp.escape(self.terms)}/i unless self.terms.blank?
    options[:category] = self.category unless self.category.blank?
    options[:computer_language] = self.programming_language unless self.programming_language.blank?
    options[:status] = self.status unless self.status.blank?

    if !self.reward_low.blank? && !self.reward_high.blank?
      options[:total_reward] = {"$gte" => self.reward_low.to_f, "$lte" => self.reward_high.to_f}
    elsif !self.reward_low.blank?
      options[:total_reward] = {"$gte" => self.reward_low.to_f}
    elsif !self.reward_high.blank?
      options[:total_reward] = {"$lte" => self.reward_high.to_f}
    end
    
    options
  end
  
  def self.rewards
    [
      [-1, -1],
      [0, 50],
      [50, 100],
      [100, 250],
      [250, 500],
      [500, -1]
    ]
  end


end

class StringUtils
  def separate(text)
    text.gsub(',', ' ').downcase.split(/\s+/)
  end
end
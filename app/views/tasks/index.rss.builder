xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Next Sprocket Tasks"
    xml.description "The open source developer's Marketplace."
    xml.link root_url
    
    @tasks.each do |task|
      xml.item do
        xml.title "#{number_to_currency(task.total_reward)} - #{task.title}"
        xml.link task_url(task.id)
        xml.description task.description
        xml.pubDate Time.parse(task.created_at.to_s).rfc822()
        xml.guid task_url(task.id)
      end
    end
  end
end
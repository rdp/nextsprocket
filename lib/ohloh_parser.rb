require 'rubygems'
require 'nokogiri'
class OhlohParser
  def self.import_ohloh_dir(dir)
    puts "Importing to MongoDB"
    Dir.entries(dir).each do |file|
      if File.extname(file).eql?(".xml")
        puts "parsing #{file}"
        doc = parse_ohloh_file(File.join(dir,file))
        OpenSourceProject.create(doc)
      end
    end
  end

  def self.parse_ohloh_file(file)
    xml_file = Nokogiri::XML(open(file))

    doc = Hash.new
    xml_file.search('response result project').each do |project|
      ['name', 'description', 'homepage_url', 'download_url'].each do |field|
        doc[field] = project.search(field).first.content
      end

      doc['user_count'] = project.search('user_count').first.content.to_i rescue nil
      doc['language'] = project.search('analysis main_language_name').first.content rescue ""
      doc['licenses'] = project.search('licenses license').map{|l| l.search('nice_name').first.content rescue ""}
    end

    doc
  end
end
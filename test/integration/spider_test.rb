require "#{File.dirname(__FILE__)}/../test_helper"
require 'anemone'

class SpiderTest < ActionController::IntegrationTest
    def setup
      @host = "http://nextsprocket.com"
      @top_level_page =  "#{@host}"
    end

    test "All links from front page are valid" do
      results = crawl_page(@top_level_page)

      results.each do |r|
        assert_no_match(/(404|500)/, r.first, r)
      end
    end

    def crawl_page(url)
      results= []
      Anemone.crawl(url) do |anemone|
        anemone.on_every_page do |page|
          results.push [page.code.to_s, page.doc.at('title').inner_html, page.url] rescue nil
        end
      end
      results
    end
end
require_relative '../config/environment.rb'

class Scraper

    def self.scrape_index
        url = "https://boardgamegeek.com/browse/boardgame"
        uri = URI.open(url)
        doc_index = Nokogiri::HTML(uri)
        puts doc_index.css("tr")
        # binding.pry
    end
end

# Scraper.scrape_index
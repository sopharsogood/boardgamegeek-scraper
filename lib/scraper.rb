require_relative '../config/environment.rb'

class Scraper

    def self.scrape_index(url)
        uri = URI.open(url)
        doc_index = Nokogiri::HTML(uri)
        return doc_index.css("tr")
    end

    def self.make_boardgames_from_index(doc_tr)
        doc_tr.css("tr").each_with_index do |doc_row, index|
            if index > 0
                rank = index
                name_cell = doc_row.css("td.collection_objectname")
                name = name_cell.css("a.primary").text.strip
                year = name_cell.css("span.smallerfont").text.strip[1...-1].to_i # remember to remove parens
                blurb = name_cell.css("p.smallefont").text.strip # smallefont (no R) is sic
                geek_rating = doc_row.css("td.collection_bggrating").first.text.strip.to_f
                avg_rating = doc_row.css("td.collection_bggrating + td.collection_bggrating").first.text.strip.to_f
                binding.pry
            end
        end
    end

end
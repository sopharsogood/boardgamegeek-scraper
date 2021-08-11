require_relative '../config/environment.rb'

class Scraper

    def self.scrape_index(url)
        uri = URI.open(url)
        doc_index = Nokogiri::HTML(uri)
        return doc_index.css("tr")
    end

    def self.make_boardgames_from_index(doc_tr)
        doc_tr.css("tr").each_with_index do |doc_row, index|
            if index > 0                                         # throwing out index 0 because it's the table header, not a row with a game
                name_cell = doc_row.css("td.collection_objectname")
                new_game_hash = {
                    :rank => index,
                    :name => name_cell.css("a.primary").text.strip,
                    :year => name_cell.css("span.smallerfont").text.strip[1...-1].to_i, # remember to remove parens
                    :blurb => name_cell.css("p.smallefont").text.strip, # smallefont (no R) is sic
                    :geek_rating => doc_row.css("td.collection_bggrating").first.text.strip.to_f,
                    :avg_rating => doc_row.css("td.collection_bggrating + td.collection_bggrating").first.text.strip.to_f, 
                    :url => name_cell.css("a.primary").attribute("href").value
                }
                Boardgame.new(new_game_hash)
            end
        end
    end

    def self.get_single_game_details(game)
        game_id = game.url.split("/")[2]
        url = "https://api.geekdo.com/xmlapi2/thing?id=" + game_id
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        doc = Nokogiri::HTML(response.body)
        binding.pry
    end

end
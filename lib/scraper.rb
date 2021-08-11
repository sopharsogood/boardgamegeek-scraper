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
        expanded_game_hash = {
            :description => doc.css("description").text.split("&#10;"),
            :designer => doc.css('link[type="boardgamedesigner"]').first.attribute("value").value.strip, # only gets one designer even for games with 2-3 designers; worth expanding to get all?
            :publisher => doc.css('link[type="boardgamepublisher"]').first.attribute("value").value.strip, # primary publisher seems to be the one listed first, the rest are alphabetical
            :min_players => doc.css("minplayers").first.attribute("value").value.strip,
            :max_players => doc.css("maxplayers").first.attribute("value").value.strip,
            :play_time => doc.css("playingtime").first.attribute("value").value.strip
        }
        game.enter_new_attributes(expanded_game_hash)
    end

end
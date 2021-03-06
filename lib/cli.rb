require_relative '../config/environment.rb'

class CLI

    def self.get_input_and_respond
        input = "-1"
        loop do
            puts " "
            puts "Which of the top 100 board games would you like to see?"
            puts "Enter a range of values, such as 1-100 or 21-30, for a brief description and rating of several games."
            puts "Or, enter a single value such as 11 for detailed information about a single game."
            puts "Or, type 'exit' to quit." if input != "-1"
            input = gets.strip
            puts " "
            split_input = input.split("-")
            input = "blank" if input == "" # prevents type error later from downcasing nil later
            first_input = split_input[0].to_i
            second_input = split_input[1].to_i      # this is 0 if the user entered a single number instead of a range
            first_input = 100 if first_input > 100
            second_input = 100 if second_input > 100
            if first_input > 0 && second_input >= first_input
                range = (first_input..second_input).to_a
                self.display_many_games(range)
            elsif first_input > 0
                self.display_single_game(first_input)
            elsif input[0].downcase == "e"                # more forgiving than checking the entire word exit
                puts "Thank you and have a nice day!"
                break
            else
                puts "Sorry, I didn't understand that! I am a simple machine and easily confused."
            end
        end
    end

    def self.display_many_games(range)
        puts "----- Best Games ##{range.first}-#{range.last} -----"
        puts " "
        range.each do |index|
            game = Boardgame.all[index - 1]
            puts "#{game.rank}. #{game.name}: #{game.blurb} (#{game.simple_rating})"
        end
        puts " "
        dashes_needed = range.first.to_s.length + range.last.to_s.length + 25
        puts "-".*(dashes_needed)
        puts " "
    end

    def self.display_single_game(index)
        game = Boardgame.all[index - 1]
        Scraper.get_single_game_details(game) if game.description == [] # conditional so only scrape once if user re-asks about same game

        puts "----- #{game.rank}. #{game.name} -----"
        puts " "
        puts "Released #{game.year}"
        puts "Designed by #{game.designer}       Published by #{game.publisher}"
        if game.min_players == game.max_players
            player_plural = "s"
            player_plural = "" if game.max_players == 1
            puts "#{game.min_players} player#{player_plural}"
        else
            puts "#{game.min_players}-#{game.max_players} players"
        end
        puts "Game length: #{game.play_time} minutes"
        spaces_needed = game.designer.length - game.geek_rating.to_s.length + 6
        string_of_spaces = " ".*(spaces_needed)
        puts "Geek Rating: #{game.geek_rating}" + string_of_spaces + "Average Rating: #{game.avg_rating}"
        puts " "
        puts " "
        puts "--- Game Categories ---"
        puts " "
        puts "Genres: #{game.genres}"
        puts " "
        puts "Mechanics: #{game.mechanics}"
        puts " "
        puts " "
        puts "--- Full Description ---"
        puts " "
        game.description.each do |description|
            puts description
        end
        puts " "
        puts "------------------------"
        puts " "
        puts " "
    end
end
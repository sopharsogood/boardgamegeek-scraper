require_relative '../config/environment.rb'

class CLI

    def self.get_input_and_respond
        input = "1"
        until input[0] == "e"
            puts " "
            puts "Which of the top 100 board games would you like to see?"
            puts "Enter a range of values, such as 1-100 or 21-30,"
            puts "for a brief description and rating of several games,"
            puts "or enter a single value such as 11 for detailed information about a single game."
            input = gets.strip
            puts " "
            split_input = input.split("-")
            first_input = split_input[0].to_i
            second_input = split_input[1].to_i
            first_input = 100 if first_input > 100
            second_input = 100 if second_input > 100
            if first_input > 0 && second_input >= first_input
                range = (first_input..second_input).to_a
                self.display_many_games(range)
            elsif first_input > 0
                self.display_single_game(first_input)
            elsif input[0] == "e"
                puts "Thank you and take care!"
                exit
            else
                puts "Sorry, I didn't understand that! I am a simple machine and easily confused."
            end
        end
    end

    def self.display_many_games(range)
        range.each do |index|
            game = Boardgame.all[index - 1]
            puts "#{game.rank}. #{game.name}: #{game.blurb} (#{game.simple_rating}/10)"
        end
    end

end
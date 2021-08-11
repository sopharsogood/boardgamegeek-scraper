require_relative '../config/environment.rb'

class Boardgame
    attr_accessor :rank, :name, :year, :blurb, :url, :geek_rating, :avg_rating, :simple_rating
    attr_accessor :description, :designer, :publisher, :play_time, :min_players, :max_players

    @@all = []

    def initialize(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
        self.simple_rating = (self.avg_rating + self.geek_rating) / 2 # condense two ratings into a single number
        self.simple_rating = self.simple_rating.round(3)              # for simplicity of display in large list
        self.description = []
        @@all << self
        # binding.pry
    end

    def enter_new_attributes(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
    end

    def self.all
        @@all
    end
end
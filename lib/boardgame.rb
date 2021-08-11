require_relative '../config/environment.rb'

class Boardgame
    attr_accessor :rank, :name, :year, :blurb, :url, :geek_rating, :avg_rating, :simple_rating

    @@all = []

    def initialize(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
        self.simple_rating = (self.avg_rating + self.geek_rating) / 2
        @@all << self
        binding.pry
    end

    def self.all
        @@all
    end
end
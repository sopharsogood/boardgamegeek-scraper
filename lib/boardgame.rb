require_relative '../config/environment.rb'

class Boardgame
    attr_accessor :rank, :name, :year, :blurb, :url, :geek_rating, :avg_rating, :simple_rating
    attr_accessor :description, :designer, :publisher, :play_time, :min_players, :max_players, :mechanics, :genres

    CHARACTER_REPLACEMENTS = {
        # "&quot;" => "\"",
        # "&amp;" => "&",
        # "&ndash;" => "–",
        # "&ldquo;" => "\“",
        # "&rdquo;" => "\”",
        # "&mdash;" => "—",
        # "&eacute;" => "é",
        # "&rsquo;" => "’",
        "&#226;&#128;&#139;" => "",
        # "&hellip;" => "...",
        "&#239;&#172;&#130;" => "fl",
        "&#239;&#172;&#128;" => "v",
        "&#226;&#128;&#147;" => "–"
    }

    @@all = []

    def initialize(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
        self.simple_rating = (self.avg_rating + self.geek_rating) / 2 # condense two ratings into a single number
        self.simple_rating = self.simple_rating.round(3)              # for simplicity of display in large list
        self.description = []
        @@all << self
        @@coder = HTMLEntities.new
        # binding.pry
    end

    def enter_new_attributes(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
        self.fix_weird_description_characters
        self.description = self.fix_HTML_description_characters
    end

    def fix_weird_description_characters
        CHARACTER_REPLACEMENTS.each do |key, value|
            self.description.each do |description_text|
                description_text.gsub!(key, value)
            end
        end
    end

    def fix_HTML_description_characters
        self.description.collect do |description_text|
            @@coder.decode(description_text)
        end
    end

    def self.all
        @@all
    end
end
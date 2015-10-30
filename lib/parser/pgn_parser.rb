require "constructor"

class PgnParser
  constructor :game_text, :readers => true

  def self.parse text
    PgnParser.new(game_text: text)
  end

  PGN::TAGS.each do |tag_key, tag_value|
	define_method(tag_key) do
	  tag(tag_value)
  	end
  end

  private
  def tag tag_key
    game_text.match(/\[#{tag_key} \"(.*)\"\]/) {|match| match.captures[0] }
  end
end
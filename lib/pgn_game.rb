require "constructor"

class String
	def capitalize_first_char
		self.sub(/^(.)/) { $1.capitalize }
	end
end

module PGN
	#TAGS_KEYS = [:event, :site, :date, :round, :white, :black, :result]
	#TAGS = Hash[TAGS_KEYS.collect { |tag_key| [tag_key, tag_key.to_s.capitalize_first_char] }]
	TAGS = {
		event: "Event",
		site: "Site",
		date: "Date",
		round: "Round",
		white: "White",
		black: "Black",
		result: "Result"
	}

end

class PgnGame
	constructor :tournament, :round, :white, :black, :result, :accessors => true, :strict => false

	def make_entry attribute, value
		"[#{attribute} \"#{value}\"]"
	end

	def to_pgn
		[make_entry(PGN::TAGS[:event], tournament.event),
			make_entry(PGN::TAGS[:site], tournament.site),
			make_entry(PGN::TAGS[:date], tournament.date),
			make_entry("TimeControl", tournament.timeControl),
			make_entry(PGN::TAGS[:round], round),
			make_entry(PGN::TAGS[:white], white.name),
			make_entry("WhiteElo", white.elo),
			make_entry(PGN::TAGS[:black], black.name),
			make_entry("BlackElo", black.elo),
			make_entry(PGN::TAGS[:result], result)]
		.join("\n") + "\n"
	end
end

class YamlPgnGamePresenter
  constructor :game, readers: true

  def to_yaml prefix = ""
    ["#{prefix}white: \"#{game.white.name}\"",
     "#{prefix}black: \"#{game.black.name}\"",
     "#{prefix}result: \"#{game.result}\"",
     "#{prefix}round: #{game.round}"]
		.join("\n")
  end

  def to_yaml_sequence_entry
    to_yaml("  ").gsub(/\A /, "-")
  end
end
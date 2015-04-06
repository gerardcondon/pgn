require "constructor"

class String
	def capitalize_first_char
		self.sub(/^(.)/) { $1.capitalize }
	end
end

class PgnGame
	constructor :tournament, :round, :white, :black, :result, :accessors => true, :strict => false

	def make_entry attribute, value
		attributeStr = attribute.to_s.capitalize_first_char
		"[#{attributeStr} \"#{value}\"]"
	end

	def to_pgn
		[make_entry("Event", tournament.event),
			make_entry("Site", tournament.site),
			make_entry("Date", tournament.date),
			make_entry("TimeControl", tournament.timeControl),
			make_entry("Round", round),
			make_entry("White", white.name),
			make_entry("WhiteElo", white.elo),
			make_entry("Black", black.name),
			make_entry("BlackElo", black.elo),
			make_entry("Result", result)]
		.join("\n") + "\n"
	end
end
require 'highline/import'
require "pathname"
require "ostruct"
require_relative "lib/pgn_game"
require_relative "lib/tournament"

MY_NAME = "Condon, Gerard"
DEFAULT_SITE = "Cork, Ireland"
DEFAULT_TIME_CONTROL = "5400+15"

folders = Pathname.glob("*").select { |c| c.directory? }
tournaments = folders.map(&:basename).map(&:to_s)

desc "Create a new tournament"
task :create_tournament do
	tournament = Tournament.new

	tournament.event = ask("Event Title: ")
	tournament.date = ask("Date [YYYY.MM.DD]: ")
	tournament.number_of_rounds = ask("Number of rounds: ", Integer)
	tournament.site = ask("Site: ") { |q| q.default = DEFAULT_SITE }
	tournament.timeControl = ask("TimeControl: ") { |q| q.default = DEFAULT_TIME_CONTROL }

	elo = ask("My ELO: ", Integer)
	me = Player.new(name: MY_NAME, elo: elo)

	tournament.number_of_rounds.times do |round|
		say ("Enter details for Round #{round+1}")
		name = ask("Name: ")
		elo = ask("Elo: ")
		say("Colour:")
		colour = choose("white", "black")
		say("Result:")
		result = choose("1-0", "1/2-1/2", "0-1", "*")

		opponent = Player.new(name: name, elo: elo)
		if (colour == "white")
			white = opponent
			black = me
		else
			white = me
			black = opponent
		end

		game = PgnGame.new(round: round + 1,
			white: white, black: black, result: result)
		tournament.addGame game
	end

	serializer = TournamentSerializer.new(tournament: tournament)
	serializer.createOnDisk
end
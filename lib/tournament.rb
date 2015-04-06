require "constructor"
require_relative "player"

class Tournament
	constructor :event, :date, :number_of_rounds, :my_elo,
	:site, :timeControl, :games, :accessors => true, :strict => false

	def setup
		@games = []
	end

	def addGame game
		game.tournament = self
		games << game
	end
end

class TournamentSerializer

	constructor :tournament, accessors: true

	def folder_name
		"tournaments/#{tournament.event}"
	end

	def filename_for_game game
		"#{folder_name}/#{game.round}.pgn"
	end

	def write_game_to_disk filename, contents
		IO.write(filename, contents)
	end

	def createOnDisk
		FileUtils.mkdir_p(folder_name)
		tournament.games.each do |game|
			filename = filename_for_game(game)
			write_game_to_disk filename, game.to_pgn
		end
	end

end
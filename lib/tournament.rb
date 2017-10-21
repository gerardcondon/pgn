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

class TournamentPresenter
	
  constructor :tournament, accessors: true
  def metadata_as_yaml prefix = ""
	  ["#{prefix}event: \"#{tournament.event}\"",
	   "#{prefix}number_of_rounds: #{tournament.number_of_rounds}",
	   "#{prefix}site: \"#{tournament.site}\"",
	   "#{prefix}date: \"#{tournament.date}\""]
	   .join("\n") + "\n"
  end

  def metadata_as_yaml_sequence_entry
    metadata_as_yaml("  ").gsub(/\A /, "-")
  end

    def to_metadata_s
	    ["- event: \"#{tournament.event}\"",
	     "  number_of_rounds: #{tournament.number_of_rounds}",
	     "  site: \"#{tournament.site}\"",
	     "  date: \"#{tournament.date}\""]
		.join("\n")
    end
    
    def to_games_yaml
    	tournament.games.map {|game| YamlPgnGamePresenter.new(game: game).to_yaml_sequence_entry }.join("\n")
    end
    
	def to_yaml
	  metadata_as_yaml + "games: \n" + to_games_yaml
	end
    
    def date
    	tournament.date
    end
end

class TournamentsPresenter
	
	constructor :tournaments, accessors: true
	
	def to_yaml
		self.to_s()
	end
	
    def to_s
    	sorted_tournaments = tournaments.sort_by {|tournament| tournament.date }
	    sorted_tournaments.map(&:to_metadata_s).join("\n") + "\n"
    end
end
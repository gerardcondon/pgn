require 'highline/import'
require "pathname"
require "ostruct"
require_relative "lib/pgn_game"
require_relative "lib/tournament"
require_relative "lib/parser/collection_parser"
require_relative "lib/parser/tournament_parser"

MY_NAME = "Condon, Gerard"
DEFAULT_SITE = "Cork, Ireland"
DEFAULT_TIME_CONTROL = "5400+15"

folders = Pathname.glob("tournaments/*").select { |c| c.directory? }
tournaments = folders.map(&:basename).map(&:to_s)

def get_my_info
    elo = ask("My ELO: ", Integer)
    Player.new(name: MY_NAME, elo: elo)
end

def get_game_for_round round, me
    say ("Enter details for Round #{round}")
    name = ask("Name: ")
    elo = ask("Elo: ")
    say("Opponent Colour:")
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

    PgnGame.new(round: round,
        white: white, black: black, result: result)
end

desc "Add a game to an existing tournament"
task :add_game do
    tournament = Tournament.new

    say "Tournament"
    tournament.event = choose(*tournaments)

    # TODO: Get these from other games in the tournament

    tournament.date = ask("Date [YYYY.MM.DD]: ")
    tournament.site = ask("Site: ") { |q| q.default = DEFAULT_SITE }
    tournament.timeControl = ask("TimeControl: ") { |q| q.default = DEFAULT_TIME_CONTROL }

    me = get_my_info()
    # TODO: Get this from highest filename + 1
    last_played_round = ask("Last played round", Integer)
    game = get_game_for_round(last_played_round + 1, me)
    tournament.addGame game

    serializer = TournamentSerializer.new(tournament: tournament)
    serializer.createOnDisk
end

desc "Create a new tournament"
task :create_tournament do
    tournament = Tournament.new

    tournament.event = ask("Event Title: ")
    tournament.date = ask("Date [YYYY.MM.DD]: ")
    tournament.number_of_rounds = ask("Number of rounds: ", Integer)
    tournament.site = ask("Site: ") { |q| q.default = DEFAULT_SITE }
    tournament.timeControl = ask("TimeControl: ") { |q| q.default = DEFAULT_TIME_CONTROL }

    me = get_my_info()

    tournament.number_of_rounds.times do |round|
        game = get_game_for_round(round + 1, me)
        tournament.addGame game
    end

    serializer = TournamentSerializer.new(tournament: tournament)
    serializer.createOnDisk
end

namespace :website do

def chess_collection_file_name event_name
  name_without_spaces = event_name.downcase.strip.gsub(' ', '-')
  ascii_name = name_without_spaces.gsub(/[äöü]/) do |match|
    case match
      when "ä" then 'a'
      when "ö" then 'o'
      when "ü" then 'u'
    end
  end
  ascii_name.gsub(/[^\w-]/, '')
end

desc "Process all collections "
task :parse_collections do
  pgn_files = Dir.glob("collections/*.pgn")
  collections_yaml = pgn_files.map do |pgn_file|
    collection = CollectionParser.parse IO.read(pgn_file)
    presenter = YamlCollectionPresenter.new(collection: collection)

    IO.write("website/data/#{chess_collection_file_name(collection.event)}.yaml", presenter.to_yaml)
    presenter.metadata_as_yaml_sequence_entry
  end
  IO.write("website/data/collections.yaml", collections_yaml.join("\n"))
end

desc "Serve out the preview website"
task :serve do
    puts "middleman server -p $PORT"
end

desc "Process all tournaments"
task :parse_tournaments do
  parsed_tournaments = folders.map { |folder| TournamentParser.parse folder }
  mkdir_p("website/data/generated") 
  presenters = parsed_tournaments.map do |parsed_tournament| 
    presenter = TournamentPresenter.new(tournament: parsed_tournament)
    IO.write("website/data/generated/#{chess_collection_file_name(parsed_tournament.event)}.yaml", presenter.to_yaml)
    presenter
  end
   
  presenter = TournamentsPresenter.new(tournaments: presenters)
  IO.write("website/data/generated/tournaments.yaml", presenter.to_yaml)
end

end
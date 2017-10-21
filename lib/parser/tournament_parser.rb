require "constructor"
require "pathname"
require_relative "pgn_parser.rb"
require_relative "../tournament.rb"

class TournamentParser
  constructor :folder, :accessors => true

  def self.parse folder
    TournamentParser.new(folder: folder).parse
  end

  def parse
    # Get list of pgn files in the folder
    puts folder
    game_files = folder.each_child.select {|child| child.fnmatch?("*.pgn") }
    games = game_files.map {|file| IO.read(file)}
    pgn_parsers = games.map {|game| PgnParser.parse("[Event #{game}") }
    tournament = Tournament.new(event: pgn_parsers[0].event, date: pgn_parsers[0].date, site: pgn_parsers[0].site, number_of_rounds: pgn_parsers.size)
    pgn_parsers.each{ |pgn_game|
      tournament.addGame(PgnGame.new(
        round: pgn_game.round,
        white: Player.new(name: pgn_game.white, elo: pgn_game.white_elo),
        black: Player.new(name: pgn_game.black, elo: pgn_game.black_elo),
        result: pgn_game.result,
        date: pgn_game.date
      ))
    }
    tournament
  end
end
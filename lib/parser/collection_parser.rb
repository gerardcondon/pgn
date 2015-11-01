require "constructor"
require_relative "pgn_parser.rb"
require_relative "../collection.rb"

class CollectionParser
  constructor :text, :accessors => true

  def find_player(players, player_name)
    players.fetch(player_name) { |player_name| Player.new(name: player_name, elo: nil)}
  end

  def self.parse text
    parser = CollectionParser.new(text: text).parse
  end

  def parse
    games = text.split(/^\[Event /).reject { |t| t.empty? }
    pgn_parsers = games.map {|game| PgnParser.parse("[Event #{game}") }
    collection = Collection.new(event: pgn_parsers[0].event, date: pgn_parsers[0].date, site: pgn_parsers[0].site)
    players = {};
    pgn_parsers.each{ |pgn_game|
      collection.number_of_rounds = [collection.number_of_rounds, pgn_game.round.to_i].max
      white_player = find_player(players, pgn_game.white);
      black_player = find_player(players, pgn_game.black);
      collection.addGame(PgnGame.new(
        round: pgn_game.round,
        white: white_player,
        black: black_player,
        result: pgn_game.result
      ))
    }
    collection
  end
end
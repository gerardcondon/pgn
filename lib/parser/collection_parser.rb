require "constructor"
require_relative "../collection.rb"

class CollectionParser
  constructor :file_path, :accessors => true
    
  def parse
    file = File.read(file_path)
    games = file.split(/^\[Event/)
    pgn_parsers = games.map {|game| PgnParser.parse(game) }
    # Create Collection from first game
    pgn_games = pgn_parsers.each{ |pgn_game| 
      # Update Max Rounds
      # Get White Player
      # Get Black Player
      # add new game to the collection PgnGame.new pgn_game
    }
    #update collection rounds
    #return Collection.new :event, :date, :number_of_rounds, :site, :games
  end
end
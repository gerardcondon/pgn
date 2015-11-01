require "constructor"
require_relative "player"

class Collection
  constructor :event, :date, :number_of_rounds,
  :site, :games, :accessors => true, :strict => false

  def setup
    @games ||= []
    @number_of_rounds ||= 0
  end

  def addGame game
    game.tournament = self
    games << game
  end
end

class YamlCollectionPresenter
  constructor :collection, readers: true

  def metadata_as_yaml prefix = ""
    ["#{prefix}event: \"#{collection.event}\"",
     "#{prefix}number_of_rounds: #{collection.number_of_rounds}",
     "#{prefix}site: \"#{collection.site}\"",
     "#{prefix}date: \"#{collection.date}\""]
		.join("\n") + "\n"
  end

  def metadata_as_yaml_sequence_entry
    metadata_as_yaml("  ").gsub(/\A /, "-")
  end

  def to_yaml
    metadata = metadata_as_yaml
    collection_str = collection.games.map {|game| YamlPgnGamePresenter.new(game: game).to_yaml_sequence_entry }.join("\n")
    metadata + "games: \n" + collection_str
  end
end
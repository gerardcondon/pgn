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

  def to_yaml
    ["- event: \"#{collection.event}\"",
     "  number_of_rounds: #{collection.number_of_rounds}",
     "  site: \"#{collection.site}\"",
     "  date: \"#{collection.date}\""]
		.join("\n") + "\n"
  end
end
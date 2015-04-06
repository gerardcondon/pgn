require "rspec"
require "rspec/its"
require_relative "../lib/pgn_game"
require_relative "../lib/player"
require_relative "../lib/tournament"

describe "The PGN Game" do
  subject(:game) {
    tournament = Tournament.new(
      event: "Cork Chess League 2014-2015",
      site: "Cork, Ireland",
      date: "2014.10.24",
      timeControl: "5400+15"
    )
    white = Player.new(name: "Bob", elo: 1234)
    black = Player.new(name: "Mike", elo: 5432)
    game = PgnGame.new(
      white: white,
      black: black,
      round: 1,
      result: "1-0")
    tournament.addGame game
    game
  }

  it "can convert the game to a pgn file" do
    expect(game.to_pgn).to eq EXPECTED_PGN
  end
end

EXPECTED_PGN = <<-END
\[Event \"Cork Chess League 2014-2015\"\]
\[Site \"Cork, Ireland\"\]
\[Date \"2014.10.24\"\]
\[TimeControl \"5400+15\"\]
\[Round \"1\"\]
\[White \"Bob\"\]
\[WhiteElo \"1234\"\]
\[Black \"Mike\"\]
\[BlackElo \"5432\"\]
\[Result \"1-0\"\]
END
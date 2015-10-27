require "rspec"
require "rspec/its"
require_relative "../lib/parser/pgn_parser"
require_relative "../lib/pgn_game"

describe "The PGN Game" do
  subject(:parsed_game) {
      PgnParser.parse INPUT_PGN
  }

  context "mandatory attributes" do
    its(:event) { should eq("Cork Chess League 2014-2015") }
    its(:site) { should eq("Cork, Ireland") }
    its(:date) { should eq("2014.10.24") }
    its(:round) { should eq("1") }
    its(:white) { should eq("Bob") }
    its(:black) { should eq("Mike") }
    its(:result) { should eq("1-0") }
  end
end

INPUT_PGN = <<-END
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
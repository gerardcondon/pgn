require "rspec"
require "rspec/its"
require_relative "../lib/collection"
require_relative "../lib/pgn_game"
require_relative "../lib/player"
require_relative "../lib/tournament"
require_relative "../lib/parser/collection_parser"

describe "Parsing a collection and outputting YAML" do
  subject(:collection) {
    CollectionParser.parse(COLLECTION_INPUT_PGN)
  }

  describe "A YamlCollectionPresenter" do
    it "can convert a collection pgn file to yaml" do
      presenter = YamlCollectionPresenter.new(collection: collection)
      expect(presenter.metadata_as_yaml_sequence_entry).to eq EXPECTED_YAML
    end
  end
end

COLLECTION_INPUT_PGN = <<-END
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

\[Event \"Cork Chess League 2014-2015\"\]
\[Site \"Cork, Ireland\"\]
\[Date \"2014.10.24\"\]
\[TimeControl \"5400+15\"\]
\[Round \"2\"\]
\[White \"Tom\"\]
\[WhiteElo \"9999\"\]
\[Black \"Mike\"\]
\[BlackElo \"5432\"\]
\[Result \"1-0\"\]

\[Event \"Cork Chess League 2014-2015\"\]
\[Site \"Cork, Ireland\"\]
\[Date \"2014.10.24\"\]
\[TimeControl \"5400+15\"\]
\[Round \"2\"\]
\[White \"Bob\"\]
\[WhiteElo \"1234\"\]
\[Black \"Tom\"\]
\[BlackElo \"9999\"\]
\[Result \"1/2-1/2\"\]
END


EXPECTED_YAML = <<-END
- event: "Cork Chess League 2014-2015"
  number_of_rounds: 2
  site: "Cork, Ireland"
  date: "2014.10.24"
END
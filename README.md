### PGN

This repository contains
* PGN files for my chess games organised by tournament
* ruby code to create new empty pgn files for tournaments and games

### Rakefile

To create a new tournament folder run `rake create_tournament` and input the game data as prompted.
This will create the folder and a pgn file for each game. These files can be edited afterwards in any chess program of your choice.

### Website

To build the website run `middleman build` in the website folder.
This will generate the static site in the `build` folder.

#### Website Roadmap
* Content
    * All games page for my tournaments
    * Previous/next buttons on the chess games
    * Generate all the data files from my tournaments
    * Handle collection pgn files with games from multiple events
    * Add analysis column to my games table
    * Add elo for me and my opponents
    * Add all my games

* Code Refactoring
    * Remove duplication between collection and tournament
    * Choose one html templating solution
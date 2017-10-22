###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

# Change Compass configuration
# config :development do
  compass_config do |config|
    config.sass_options = {:debug_info => true}
  end
# end

###
# Page options, layouts, aliases and proxies
###

# Slim settings
Slim::Engine.set_default_options :pretty => true
# shortcut
Slim::Engine.set_default_options :shortcut => {
  '#' => {:tag => 'div', :attr => 'id'},
  '.' => {:tag => 'div', :attr => 'class'},
  '&' => {:tag => 'input', :attr => 'type'}
}

# Markdown settings 
#set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :with_toc_data => true
set :markdown_engine, :redcarpet

# Clear out automated posts folder
automated_posts_folder = "#{config[:source]}/posts/automated"
FileUtils.rmtree(automated_posts_folder)
FileUtils.mkdir(automated_posts_folder)

post_counter = 1
data.microposts.each do |micropost|
  post_content = "---\n"
  post_content += "title: mp#{post_counter}\n"
  post_content += "date: #{micropost.date}\n"
  post_content += "tags: microposts\n"
  post_content += "micropost: true\n"
  post_content += "---\n"
  post_content += "#{micropost.text}"
  
  File.write("#{automated_posts_folder}/#{micropost.date}-mp#{post_counter}.html.md", post_content)
  
  post_counter += 1
end

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end


helpers do
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

  def row_colour_for_round round
    ["active", "success", "info", "warning", "danger"][round % 5]
  end
  
  def row_colour_for_my_game white_player_name, result
    if result.eql? "1-0"
      return (white_player_name.eql? "Condon, Gerard") ? "success" : "danger" 
    elsif result.eql? "1/2-1/2"
      return "active"
    else
      return (white_player_name.eql? "Condon, Gerard") ? "danger" : "success" 
    end
  end
  
  def row_colour_for_rating previous_rating, new_rating
    if previous_rating > new_rating
      return "danger" 
    end
    "success"
  end
end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
data.collections.each do |collection|
  file_name = chess_collection_file_name(collection.event)
  proxy "/#{file_name}/#{file_name}.html", "/collections/collection.html",
    :locals => {no_sidebar: true, collection: data[file_name] }, :ignore => true
  game_number = 1
  data[file_name].games.each do |game|
    proxy "/#{file_name}/" + chess_collection_file_name(game.white + "-" + game.black) + "-#{game_number}.html", "/collections/game.html",
      :locals => {no_sidebar: true, pgn_file: collection.pgn, game: data[file_name], game_number: game_number}, :ignore => true
    game_number += 1
  end
end

all_games = []

data.generated.tournaments.each do |tournament|
  file_name = chess_collection_file_name(tournament.event)
  tournament_page = "/#{file_name}/#{file_name}.html"
  proxy tournament_page, "/tournaments/tournament.html",
    :locals => {no_sidebar: true, title: tournament.event, 
      description: "My games at the #{tournament.event}", tournament: data.generated[file_name] }, :ignore => true
  data.generated[file_name].games.each do |game|
    game_file_name = "/#{file_name}/" + chess_collection_file_name(game.white + "-" + game.black) + "-#{game.round}.html"
    proxy game_file_name, "/tournaments/game.html",
      :locals => {no_sidebar: true, tournament: tournament_page, tournament_name: tournament.event, title: "#{game.white + "-" + game.black}", game: game}, :ignore => true
    all_games << {game: game, file_name: game_file_name, tournament: tournament.event}
  end
end

page "/tournaments.html" do
  @all_games = all_games
end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end


activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "chess"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "posts/{type}/{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".md"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  # blog.page_link = "page/{num}"
end

page "/sitemap.xml", layout: false

###
# Site Settings
###
# Set site setting, used in helpers / sitemap.xml / feed.xml.
set :site_url, 'http://www.gerardcondon.com/chess'
set :site_author, 'Gerard Condon'
set :site_title, 'Chess Analysis'
set :site_description, 'Site containing analysis of my chess games.'
# Select the theme from bootswatch.com.
# If false, you can get plain bootstrap style.
# set :theme_name, 'flatly'
set :theme_name, false
# set @analytics_account, like "XX-12345678-9"
@analytics_account = "UA-71152906-1"

page "/feed.xml", layout: false
page "/diagram.html", layout: :diagram
page "/atom.xml", layout: false
set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  Dir.glob(File.join("#{root}", @bower_config["directory"], "*", "fonts")) do |f|
    sprockets.append_path f
  end
  sprockets.append_path File.join "#{root}", @bower_config["directory"]
end


set :relative_links, true

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash
set :relative_links, true

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end

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
end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
data.collections.each do |collection|
  file_name = chess_collection_file_name(collection.event)
  proxy "/#{file_name}/#{file_name}.html", "/collections/collection.html",
    :locals => {no_sidebar: true, collection: data[file_name] }, :ignore => true
  game_number = 1
  data[file_name].games.each do |game|
    proxy "/#{file_name}/" + chess_collection_file_name(game.white + "-" + game.black) + ".html", "/collections/game.html",
      :locals => {no_sidebar: true, game: data[file_name], game_number: game_number}, :ignore => true
    game_number += 1
  end
end

test_files = [{pgn_url: "https://raw.githubusercontent.com/gerardcondon/chess/master/tournaments/Mulcahy%202015/6.pgn", title: "Mulcahy 2015 Game 6", name: "doc"},
{pgn_url: "https://raw.githubusercontent.com/gerardcondon/chess/master/tournaments/Cork%20Club%20Championship%202014-2015/4.pgn", title: "Cork Club Championship 2014-2015 Game 4", name: "lh"},
{pgn_url: "https://raw.githubusercontent.com/gerardcondon/chess/master/tournaments/Cork%20Club%20Championship%202014-2015/5.pgn", title: "Cork Club Championship 2014-2015 Game 5", name: "aw"}]

test_files.each do |test_file|
  proxy "/test/#{test_file[:name]}.html", "/test/test.html",
    :locals => test_file, :ignore => true
end

page "/test/test_list.html" do
  @test_files = test_files
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
  blog.sources = "posts/{year}-{month}-{day}-{title}.html"
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

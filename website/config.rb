###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

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
    :locals => {:collection => data[file_name] }, :ignore => true
  game_number = 1
  data[file_name].games.each do |game|
    proxy "/#{file_name}/" + chess_collection_file_name(game.white + "-" + game.black) + ".html", "/collections/game.html",
      :locals => {:game => data[file_name], :game_number => game_number}, :ignore => true
    game_number += 1
  end
end
###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

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

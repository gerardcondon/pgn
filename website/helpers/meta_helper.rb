def page_title
  title = current_page.data.title || site_title
  if current_article && current_article.title
    title = site_title + " | " +  current_article.title
  end

  title
end

def page_description
  description = site_description

  if current_article && current_page.data.description
    description = current_page.data.description
  end

  description
end

def include_sidebar?
  isCollectionsPage = current_page.source_file.end_with?("collections.html.erb")
  isCollectionPage = current_page.source_file.end_with?("collection.html.erb")
  isTournamentsPage = current_page.source_file.end_with?("tournaments.html.erb")
  isTournamentPage = current_page.source_file.end_with?("tournament.html.erb")
  isGamePage = current_page.source_file.end_with?("game.html.erb")
  #p current_page.source_file
  #p isCollectionsPage
  #p isCollectionPage
  #p isGamePage
  !(isTournamentsPage || isTournamentPage || isCollectionsPage || isGamePage || isCollectionPage || current_page.source_file.end_with?("about.html.slim") || current_page.source_file.end_with?("test.html.erb") || current_page.source_file.end_with?("test_list.html.erb"))
end

def page_keywords
  keywords = [] # Set site keywords here

  if current_article && current_article.tags
    keywords.concat(current_article.data.tags)
  end

  keywords.uniq.join(", ")
end
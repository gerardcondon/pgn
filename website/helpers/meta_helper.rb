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

def insert_fen_diagram fen, caption
  str = "<figure>"
  str += "<div class=\"fen-wrapper\">"
  str += "<p align=\"center\"><iframe class=\"scaled-fen-frame\" height=\"395\" width=\"395\" align=\"middle\" src=\"diagram.html?fen=#{fen}\"></iframe></p>"
  str += "</div>"
  str += "<figcaption>#{caption}</figcaption>"
  str += "</figure>"
  return str
end

module Middleman
  module Blog
    module BlogArticle
      def is_micropost?
        data["micropost"]
      end
      
      def display_title
        is_micropost? ? "" : data["title"]
      end
      
      def published_time
        date.to_time.iso8601
      end
      
      def updated_time
        is_micropost? ? published_time : File.mtime(source_file).iso8601
      end
    end
  end
end

  
  
  
require 'pry' # for debug

module NauLibClient
  autoload :Library,      './lib/library.rb'
  autoload :BookSearcher, './lib/book_searcher.rb'
  autoload :Section,      './lib/section.rb'
  autoload :Book,         './lib/book.rb'
  autoload :Downloader,   './lib/downloader.rb'
  autoload :Session,      './lib/session.rb'
  autoload :Books,        './lib/books.rb'
end

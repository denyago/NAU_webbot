module NauLibClient
  ##
  # Class: Book
  #
  # Represents a book of NAU library
  class Book
    attr_reader :title, :id, :size, :section

    # Initializes new Book
    #
    # Params:
    #   - opts {Hash} of options:
    #     - :title    {String}
    #     - :id       {String}
    #     - :size     {String}
    #     - :section  {String}
    #     - :session  {Capybara::Session} with page, where link and info on this book found
    def initialize(opts={})
      @title   = opts[:title]
      @id      = opts[:id]
      @size    = opts[:size]
      @section = opts[:section]
      @session = opts[:session]
    end

    # Returns {String} with textual representation
    def inspect
      "#<NauLib::Book title='#{title}', section='#{section}'>"
    end

    # Returns {String} with full URL of the book file
    def url
      @_url ||= get_url
    end

    # Downloads book's file
    #
    # Returns {String} with path to book's downloaded file
    def download
      Downloader.new(url).get
    end

  private

    def session
      @session ||= Section.new(section).get_books_page
    end

    def get_url
      session.find('a', text: title)[:href]
    end
  end
end

module NauLibClient
  ##
  # Class: Section
  #
  # Represents one of many NAU library
  # sections, containing books.
  class Section
    attr_reader :name

    # Initializes new Section
    #
    # Params:
    #   - name {String} name of section
    #   - session {Capybara::Session} with library front page
    def initialize(name, session=nil)
      @name    = name
      @session = session
    end

    # Returns {String} with textual representation
    def inspect
      "#<NauLib::Section name='#{name}'>"
    end

    # Returns {Array} of Books of this section
    def books
      @_books ||= get_books
    end

    # Returns {Capybara::Session} with page, where books of section are
    def get_books_page
      BookSearcher.find_page(section: name)
    end

  private
    def session
      @session ||= Session.begin
    end

    def get_books
      Books.page_to_books(get_books_page)
    end
  end
end

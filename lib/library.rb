module NauLibClient
  ##
  # Class: Library
  #
  # Represents NAU library, with options
  # to see it's sections and search for books
  class Library

    # Returns {Array} of Sections
    def self.sections
      @_sections ||= get_sections
    end

    # Find books
    #
    # Params:
    #   - opts {Hash} of search options:
    #     - :section {String} exact section name
    #     - :title   {String} full book title or it's part
    #     - :author  {String} full author name or it's part
    #     - :published_before {String} with year publised
    #     - :published_after  {String} with year publised
    #
    # Returns {Array} of Books found
    def self.find(conditions={})
      page = BookSearcher.find_page(conditions)
      Books.page_to_books(page)
    end

  private
    def self.get_sections
      page = Session.begin
      page.find('#RadioButtonList1').all('input[type="radio"]').
        map { |section_input| section_input.value }.
        reject { |section_name| section_name == 'Всі розділи'  }.
        map do |section_name|
        Section.new(section_name, page)
      end
    end
  end
end

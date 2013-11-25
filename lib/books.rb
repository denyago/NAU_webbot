module NauLibClient
  ##
  # Class: Books
  #
  # Utility class for getting Array of books from page passed
  class Books

    # Gets books from a page
    #
    # Params:
    #   - page {Capybara::Session} with books
    #
    # Returns {Array} of Books
    def self.page_to_books(page)
      book_rows = page.find('#Table2').all('tr')[1..-1] # removing first row which is title
      book_rows.map do |book_row|
        id, title, section, size = book_row.all('td').map(&:text)
        Book.new(title: title, id: id, size: size, section: section, session: page)
      end
    end
  end
end

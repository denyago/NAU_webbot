require 'bundler/setup'
require 'capybara'
require 'capybara/dsl'
require 'open-uri'

require 'pry' # for debug

Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.lib.nau.edu.ua'

module NauLib
  class Client
    include Capybara::DSL

    def initialize
      visit('/newbooks/newbooks.aspx')
    end

    def sections
      @_sections ||= get_sections
    end

  private
    def get_sections
      page.find('#RadioButtonList1').all('input[type="radio"]').map do |section_input|
        name = section_input.value
        Section.new(name, page)
      end
    end
  end

  class Section
    attr_reader :name

    def initialize(name, session)
      @name    = name
      @session = session
    end

    def inspect
      "#<NauLib::Section name='#{name}'>"
    end

    def books
      @_books ||= get_books
    end

  private

    def get_books
      visit_books_page
      book_rows = @session.find('#Table2').all('tr')[1..-1] # removing first row which is title
      book_rows.map do |book_row|
        id, title, section, size = book_row.all('td').map(&:text)
        Book.new(title, id, size, name, @session)
      end
    end

    def visit_books_page
      @session.within("#form1") do
        @session.select(name, from: 'DropDownList1')
        @session.click_button('Srch_Button')
      end
    end
  end

  class Book
    attr_reader :title, :id, :size, :section

    def initialize(title, id, size, section, session)
      @title   = title
      @id      = id
      @size    = size
      @section = section
      @session = session
    end

    def inspect
      "#<NauLib::Book title='#{title}', section='#{section}'>"
    end

    def url
      @_url ||= get_url
    end

    def download
      Downloader.new(url).get
    end

  private

    def get_url
      @session.find('a', text: title)[:href]
    end
  end

  class Downloader
    def initialize(url)
      @url = url
    end

    def get
      File.open(save_path, 'wb') do |file|
        file << open(@url).read
      end

      save_path
    end

  private

    def save_path
      file_name = File.basename(@url)
      File.join('.', file_name)
    end
  end
end

client = NauLib::Client.new
puts "NAU librarly sections:\n  " + client.sections.map(&:name).join("\n  ")

the_section = client.sections.last
puts "Books in the section '#{the_section.name}':\n  " + the_section.books.map(&:title).join("\n  ")

the_book = the_section.books.first
puts the_book.inspect

file = the_book.download
`open #{file}`

# client.find(section: '', author_like: '', title_like: '', published_at: '')

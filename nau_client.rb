require 'bundler/setup'
require 'capybara'
require 'open-uri'

require 'pry' # for debug

Capybara.app_host = 'http://www.lib.nau.edu.ua'

module NauLibClient
  class Library

    def self.sections
      @_sections ||= get_sections
    end

    def self.find(conditions={})
      page = BookSearcher.find_page(conditions)
      Books.page_to_books(page)
    end

  private
    def self.get_sections
      page = Session.begin
      page.find('#RadioButtonList1').all('input[type="radio"]').map do |section_input|
        name = section_input.value
        next if name == 'Всі розділи'
        Section.new(name, page)
      end
    end
  end

  class BookSearcher
    DEFAULT_CONDITIONS = {
      section: 'Без обмежень',
      title:   '',
      author:  '',
      published_after:  '',
      published_before: ''
    }

    def self.find_page(conditions)
      session = Session.begin
      normalized_conditions = DEFAULT_CONDITIONS.merge(conditions)
      normalized_conditions.each do |condition_name, value|
        case condition_name
          when :section then session.select(value, from: 'DropDownList1')
          when :title   then session.fill_in('TextBox2', with: value)
          when :author  then session.fill_in('TextBox1', with: value)
          when :published_after  then session.fill_in('TextBox3', with: value)
          when :published_before then session.fill_in('TextBox4', with: value)
        end
      end
      session.click_button('Srch_Button')
      session
    end
  end

  class Section
    attr_reader :name

    def initialize(name, session=nil)
      @name    = name
      @session = session
    end

    def inspect
      "#<NauLib::Section name='#{name}'>"
    end

    def books
      @_books ||= get_books
    end

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

  class Book
    attr_reader :title, :id, :size, :section

    def initialize(opts={})
      @title   = opts[:title]
      @id      = opts[:id]
      @size    = opts[:size]
      @section = opts[:section]
      @session = opts[:session]
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

    def session
      @session ||= Section.new(section).get_books_page
    end

    def get_url
      session.find('a', text: title)[:href]
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

  class Session
    def self.begin
      @session ||= Capybara::Session.new(:selenium).tap do |session|
        session.visit('/newbooks/newbooks.aspx')
      end
    end
  end

  class Books
    def self.page_to_books(page)
      book_rows = page.find('#Table2').all('tr')[1..-1] # removing first row which is title
      book_rows.map do |book_row|
        id, title, section, size = book_row.all('td').map(&:text)
        Book.new(title: title, id: id, size: size, section: section, session: page)
      end
    end
  end
end

# client.find(section: '', author_like: '', title_like: '', published_at: '')

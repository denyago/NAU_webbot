module NauLibClient
  ##
  # Class: BookSearcher
  #
  # Utility class to help search books.
  class BookSearcher
    DEFAULT_CONDITIONS = {
      section: 'Без обмежень',
      title:   '',
      author:  '',
      published_after:  '',
      published_before: ''
    }

    # Find books.
    #
    # See: Library#find
    #
    # Returns {Capybara::Session} page with books found
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
end

require 'capybara'

module NauLibClient
  ##
  # Class: Session
  #
  # Utility class for getting start page of NAU library
  class Session
    HOSTNAME = 'http://www.lib.nau.edu.ua'

    # Returns {Capybara::Session} with just opened front page of library
    def self.begin
      @session ||= Capybara::Session.new(:selenium).tap do |session|
        session.visit(HOSTNAME + '/newbooks/newbooks.aspx')
      end
    end
  end
end

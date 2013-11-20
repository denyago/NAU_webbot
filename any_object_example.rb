require './nau_client.rb'

url = NauLibClient::Book.new(title: 'Morgan Kaufmann. Computer Architecture. A Quantitative Approach. 3rd Edition. - 1141 c.', section: 'Програмування').url
puts url

size = NauLibClient::Section.new('Кібернетика').books.size
puts size

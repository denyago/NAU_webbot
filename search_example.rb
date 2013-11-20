require './nau_client.rb'

books = NauLibClient::Library.find(title: 'курс', author: 'го', section: 'Економіка', published_before: '2014', published_after: '2004')
puts books.map(&:inspect).join("\n")

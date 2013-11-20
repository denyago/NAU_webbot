require './nau_client.rb'

file =  NauLibClient::Library.sections[3].books[2].download
`open #{file}`

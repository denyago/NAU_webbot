require './nau_client.rb'

lib = NauLibClient::Library
puts "NAU librarly sections:\n  " + lib.sections.map(&:name).join("\n  ")

the_section = lib.sections.last
puts "Books in the section '#{the_section.name}':\n  " + the_section.books.map(&:title).join("\n  ")

the_book = the_section.books.first
puts the_book.inspect

file = the_book.download
`open #{file}`

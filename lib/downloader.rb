require 'open-uri'

module NauLibClient
  ##
  # Class: Downloader
  #
  # Utility class responsible for
  # downloading files by URL and
  # storing localy.
  class Downloader
    BASE_FOLDER = 'books'

    # Initializes new Downloader
    #
    # Params:
    #   - url {String} with URL of file to download
    def initialize(url)
      @url = url
    end

    # Performs actual downloading
    #
    # Returns {String} with path to downloaded
    # file
    def get
      File.open(save_path, 'wb') do |file|
        file << open(@url).read
      end

      save_path
    end

  private

    def save_path
      file_name = File.basename(@url)
      File.join('.', BASE_FOLDER, file_name)
    end
  end
end

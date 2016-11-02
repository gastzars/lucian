require 'fileutils'

module Lucian
  ##
  # Initiator module for initializing process

  module Initiator
    def self.init(path = File.expand_path('.'))
      lucian_path = File.expand_path(path+'/lucian')
      create_directory(lucian_path)
    end

    def self.create_directory(directory_path)
      FileUtils::mkdir_p directory_path
    end

    def self.create_helper_file(directory_path)
      
    end
  end
end

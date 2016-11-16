require 'fileutils'

module Lucian
  ##
  # Initiator module for initializing process

  module Initiator
    def self.init(path = File.expand_path('.'))
      BoardCaster.print('Start initialize Lucian environment', "green")
      lucian_path = File.expand_path(path+'/lucian')
      create_directory(lucian_path)
      create_helper_file(lucian_path)
      create_gemfile(path)
      create_dockerfile(lucian_path)
      BoardCaster.print('Lucian init DONE', "green")
    end

    private

    def self.create_directory(directory_path)
      FileUtils::mkdir_p directory_path
      BoardCaster.print('Create: '+directory_path+' [DONE]', "yellow")
    end

    def self.create_helper_file(directory_path)
      FileUtils.cp(File.expand_path(File.expand_path(__FILE__)+'./../template/lucian_helper.rb'), directory_path)
      BoardCaster.print('Create: '+directory_path+'/lucian_helper.rb'+' [DONE]', "yellow")
    end

    def self.create_gemfile(directory_path)
      FileUtils.cp(File.expand_path(File.expand_path(__FILE__)+'./../template/Gemfile'), directory_path)
      BoardCaster.print('Create: '+directory_path+'/Gemfile'+' [DONE]', "yellow")
    end

    def self.create_dockerfile(directory_path)
      FileUtils.cp(File.expand_path(File.expand_path(__FILE__)+'./../template/Dockerfile'), directory_path)
      BoardCaster.print('Create: '+directory_path+'/Dockerfile'+' [DONE]', "yellow")
    end
  end
end

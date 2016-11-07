module Lucian

  ##
  # Core module for Lucian framework is HERE !

  class Engine
    attr_reader :compose_file, :compose_data, :compose_directory, :lucian_files, :network_name

    ##
    # Initialize and fetch for compose file.
    # if unable to find a docker-compose file then givving an error

    def initialize(compose_file = nil)
      @compose_file = compose_file || fetch_docker_compose_file
      raise Error.new('Unable to find docker-compose.yml or docker-compose.yaml.') if !@compose_file || !File.file?(@compose_file)
      @compose_directory = File.expand_path(@compose_file+'/..')
      @compose_data = YAML.load_file(@compose_file)
      @lucian_directory = @compose_directory+'/'+DIRECTORY
      @lucian_helper = @lucian_directory+'/'+HELPER
      @lucian_files = fetch_lucian_files(@lucian_directory)
      @network_name = File.basename(@compose_directory).gsub!(/[^0-9A-Za-z]/, '')
      $LOAD_PATH.unshift(@lucian_directory) unless $LOAD_PATH.include?(@lucian_directory)
      @docker_compose = Docker::Compose.new
      require 'lucian_helper' if File.exist?(@lucian_helper)
    end

    ##
    # Run

    def run
      BoardCaster.print("Start running Lucian ..", "yellow")
      RSpec.lucian_engine = self
      Lucian::Runner.invoke(self)
    end

    private

    ##
    # Fetching compose file from curent directory and parents

    def fetch_docker_compose_file(path = File.expand_path('.'))
      files = Dir.glob(path+'/docker-compose.y*ml')
      files = fetch_docker_compose_file(File.expand_path(path+'/..')) if files.size == 0 && path != '/'
      if files.instance_of?(Array)
        compose_path = files[0] 
      else
        compose_path = files
      end
      return compose_path
    end

    ##
    # Fetching *_lucian.rb files

    def fetch_lucian_files(path = File.expand_path('./lucian'))
      Dir.glob("#{path}/**/*_lucian.rb")
    end

  end
end

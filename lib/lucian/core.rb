module Lucian

  # Core module for Lucian framework is HERE !
  class Core
    attr_reader :compose_file, :compose_data, :compose_directory

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
    end

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

  end
end

module Lucian

  # Core module for Lucian framework is HERE !
  class Core
    attr_accessor :compose_file, :compose_data

    ##
    # Initialize and fetch for compose file.
    # if unable to find a docker-compose file then givving an error

    def initialize(compose_file = nil)
      @compose_file = compose_file || fetch_docker_compose_file
      raise Error.new('Unable to find docker-compose.yml or docker-compose.yaml.') unless @compose_file
      @compose_data = YAML.load_file(compose_file)
    end

    ##
    # Fetching compose file from cuurent directory and parents

    def fetch_docker_compose_file(path = File.expand_path('.'))
      files = Dir.glob(path+'/docker-compose.y*ml')
      files = fetch_docker_compose_file(File.expand_path(path+'/..')) if files.size == 0 && path == '/'
      compose_path = files[0]
      return compose_path
    end

  end
end

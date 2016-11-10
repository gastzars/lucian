module Lucian

  ##
  # Core module for Lucian framework is HERE !
  class Engine
    attr_reader :compose_file, :compose_data, :compose_directory, :network_name #lucian_files

    attr_reader :docker_compose, :network_name, :examples

    ##
    # Initialize and fetch for compose file.
    # if unable to find a docker-compose file then givving an error
    def initialize(compose_file = nil, examples = [])
      @compose_file = compose_file || fetch_docker_compose_file
      raise Error.new('Unable to find docker-compose.yml or docker-compose.yaml.') if !@compose_file || !File.file?(@compose_file)
      @compose_directory = File.expand_path(@compose_file+'/..')
      @compose_data = YAML.load_file(@compose_file)
      @lucian_directory = @compose_directory+'/'+DIRECTORY
      @lucian_helper = @lucian_directory+'/'+HELPER
      #@lucian_files = fetch_lucian_files(@lucian_directory)
      @network_name = File.basename(@compose_directory).gsub!(/[^0-9A-Za-z]/, '')
      $LOAD_PATH.unshift(@lucian_directory) unless $LOAD_PATH.include?(@lucian_directory)
      @docker_compose = Docker::Compose.new
      @examples = examples
      config_compose
      require 'lucian_helper' if File.exist?(@lucian_helper)
      Lucian.engine = self
    end

    ##
    # Run
    def run
      BoardCaster.print("Start running Lucian ..", "yellow")
      RSpec.lucian_engine = self
      Lucian::Runner.invoke(self)
    end

    ##
    # Shutdown
    def shutdown
      @docker_compose.down
      stop_lucian_container
      remove_lucian_container
      # remove_lucian_image # NOTE Bot sure we need to remove this or not
    end

    ##
    # Run and validate services status
    def run_docker_service(services_names)
      services_names.collect!(&:to_s)
      services_names.each do |service|
        @docker_compose.up(service, {:detached => true})
      end
      exited = @docker_compose.ps.where { |c| !c.up? && services_names.include?(c.image) }
      raise "We have some exited containers: " + exited.join(', ') if exited.count > 0
    end

    ##
    # Stop docker service
    def stop_docker_service(services_names)
      services_names.each do |service|
        @docker_compose.stop(service)
      end
    end

    ##
    # Start lucian docker connect to compose
    def start_lucian_docker
      image = build_lucian_image
      run_lucian_image(image)
    end


    private

    ##
    # Config compose
    def config_compose
      @docker_compose.file = @compose_file
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

    ## NOTE CURRENTLY UNUSED
    #
    # Fetching *_lucian.rb files
    #
    #def fetch_lucian_files(path = File.expand_path('./lucian'))
    #  Dir.glob("#{path}/**/*_lucian.rb")
    #end

    ##
    # Build lucian docker image
    def build_lucian_image
      BoardCaster.print("Building lucian image ..", "yellow")
      image = Docker::Image.build_from_dir(@lucian_directory)
      Lucian.image = image
      return image
    end

    ##
    # Run lucian docker image
    def run_lucian_image(image=Lucian.image)
      raise "Image can not be nil" if image.nil?
      BoardCaster.print("Starting lucian container ..", "yellow")
      container = image.run
      Lucian.container = container
      return container
    end

    ##
    # Remove docker image
    def remove_lucian_image(image=Lucian.image)
      raise "Image can not be nil" if image.nil?
      BoardCaster.print("Removing lucian image ..", "yellow")
      image.remove
      return true
    end

    ##
    # Remove docker container
    def remove_lucian_container(container=Lucian.container)
      raise "Container can not be nil" if container.nil?
      BoardCaster.print("Removing lucian contanier ..", "yellow")
      container.remove
      return true
    end

    ##
    # Stop docker container
    def stop_lucian_container(container=Lucian.container)
      raise "Container can not be nil" if container.nil?
      BoardCaster.print("Stopping lucian contanier ..", "yellow")
      container.kill!
      return true
    end
  end
end

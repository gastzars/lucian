module RSpec::Core
  class Configuration
    def files_or_directories_to_run=(*files)
      files = files.flatten

      if (command == 'rspec' || Runner.running_in_drb?) && default_path && files.empty?
        files << default_path
      elsif command == 'lucian'
        files << 'lucian'
      end

      @files_or_directories_to_run = files
      @files_to_run = nil
    end
  end
end

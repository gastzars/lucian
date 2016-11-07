module RSpec::Core
  class Runner
    def self.invoke(lucian_engine=nil)
      disable_autorun!
      status = run(ARGV, $stderr, $stdout, lucian_engine).to_i
      exit(status) if status != 0
    end

    def self.run(args, err=$stderr, out=$stdout, lucian_engine=nil)
      trap_interrupt
      options = ConfigurationOptions.new(args)

      if options.options[:runner]
        options.options[:runner].call(options, err, out)
      else
        if lucian_engine
          new(options, RSpec.configuration, RSpec.world, lucian_engine).run(err, out)
        else
          new(options).run(err, out)
        end
      end
    end

    def initialize(options, configuration=RSpec.configuration, world=RSpec.world, lucian_engine=nil)
      @options       = options
      @configuration = configuration
      if lucian_engine
        configuration.pattern = "**{,/*/**}/*_lucian.rb"
      end
      @world         = world
    end

  end
end

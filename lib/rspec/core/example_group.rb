module RSpec::Core
  class ExampleGroup

    def self.define_example_method(name, extra_options={})
      idempotently_define_singleton_method(name) do |*all_args, &block|
        # NOTE EXAMPLE METHOD IS OVERRIDED HERE

        desc, *args = *all_args
        options = Metadata.build_hash_from(args)
        options.update(:skip => RSpec::Core::Pending::NOT_YET_IMPLEMENTED) unless block
        options.update(extra_options)

        RSpec::Core::Example.new(self, desc, options, block)
      end
    end

    def self.define_example_group_method(name, metadata={})
      idempotently_define_singleton_method(name) do |*args, &example_group_block|
        # NOTE EXAMPLE GROUP METHOD IS OVERRIDED HERE

        hash_options = args.last if args.last.is_a? Hash
        if hash_options && hash_options[:services]

          puts "OVERRIDDED"
        end

        # END OVERRIDED HERE

        thread_data = RSpec::Support.thread_local_data
        top_level   = self == ExampleGroup
  
        registration_collection =
          if top_level
            if thread_data[:in_example_group]
              raise "Creating an isolated context from within a context is " \
                    "not allowed. Change `RSpec.#{name}` to `#{name}` or " \
                    "move this to a top-level scope."
            end

            thread_data[:in_example_group] = true
            RSpec.world.example_groups
          else
            children
          end

        begin
          description = args.shift
          combined_metadata = metadata.dup
          combined_metadata.merge!(args.pop) if args.last.is_a? Hash
          args << combined_metadata

          subclass(self, description, args, registration_collection, &example_group_block)
        ensure
          thread_data.delete(:in_example_group) if top_level
        end
      end
    end

  end
end

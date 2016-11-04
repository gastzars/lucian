require 'lucian/version'
require 'docker/compose'
require 'rspec/core'

require_relative 'lucian/engine'
require_relative 'lucian/errors'
require_relative 'lucian/initiator'
require_relative 'lucian/board_caster'

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

        puts "overrided"

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

module Lucian
  DIRECTORY = 'lucian'
  HELPER = 'lucian_helper.rb'

  include RSpec::Core

  # Reinitialize core syntax

  RSpec::Core::ExampleGroup.define_example_method :example
  RSpec::Core::ExampleGroup.define_example_method :it
  RSpec::Core::ExampleGroup.define_example_method :specify
  RSpec::Core::ExampleGroup.define_example_method :focus,    :focus => true
  RSpec::Core::ExampleGroup.define_example_method :fexample, :focus => true
  RSpec::Core::ExampleGroup.define_example_method :fit,      :focus => true
  RSpec::Core::ExampleGroup.define_example_method :fspecify, :focus => true
  RSpec::Core::ExampleGroup.define_example_method :xexample, :skip => 'Temporarily skipped with xexample'
  RSpec::Core::ExampleGroup.define_example_method :xit,      :skip => 'Temporarily skipped with xit'
  RSpec::Core::ExampleGroup.define_example_method :xspecify, :skip => 'Temporarily skipped with xspecify'
  RSpec::Core::ExampleGroup.define_example_method :skip,     :skip => true
  RSpec::Core::ExampleGroup.define_example_method :pending,  :pending => true

  RSpec::Core::ExampleGroup.define_example_group_method :example_group
  RSpec::Core::ExampleGroup.define_example_group_method :describe
  RSpec::Core::ExampleGroup.define_example_group_method :context
  RSpec::Core::ExampleGroup.define_example_group_method :xdescribe, :skip => "Temporarily skipped with xdescribe"
  RSpec::Core::ExampleGroup.define_example_group_method :xcontext,  :skip => "Temporarily skipped with xcontext"
  RSpec::Core::ExampleGroup.define_example_group_method :fdescribe, :focus => true
  RSpec::Core::ExampleGroup.define_example_group_method :fcontext,  :focus => true
end


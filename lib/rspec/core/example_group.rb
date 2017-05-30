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

          # OVERRIDED ENSURE
          #
        end
      end
    end

    def self.run(reporter=RSpec::Core::NullReporter)
      self_services = self.metadata[:services] || []
      parent_services = []
      unless self.metadata[:parent_example_group].nil?
        current_parent = self.metadata[:parent_example_group]
        loop do
          parent_services << current_parent[:services]
          break if current_parent[:parent_example_group].nil?
          current_parent = current_parent[:parent_example_group]
        end
        parent_services = parent_services.flatten.uniq - self_services
      end
      services = (self_services+parent_services).flatten.compact.uniq
      if services.count > 0 && ENV['LUCIAN_DOCKER'] == nil
        Lucian::BoardCaster.print(">> ExampleGroup : "+self.metadata[:full_description].to_s, "cyan")
        RSpec.lucian_engine.run_docker_service(services)
      end
      return if RSpec.world.wants_to_quit
      reporter.example_group_started(self)

      should_run_context_hooks = descendant_filtered_examples.any?
      begin
        run_before_context_hooks(new('before(:context) hook')) if should_run_context_hooks
        result_for_this_group = run_examples(reporter)
        results_for_descendants = ordering_strategy.order(children).map { |child| child.run(reporter) }.all?
        result_for_this_group && results_for_descendants
      rescue Pending::SkipDeclaredInExample => ex
        for_filtered_examples(reporter) { |example| example.skip_with_exception(reporter, ex) }
        true
      rescue RSpec::Support::AllExceptionsExceptOnesWeMustNotRescue => ex
        for_filtered_examples(reporter) { |example| example.fail_with_exception(reporter, ex) }
        RSpec.world.wants_to_quit = true if reporter.fail_fast_limit_met?
        false
      ensure
        run_after_context_hooks(new('after(:context) hook')) if should_run_context_hooks
        if self_services.count > 0 && ENV['LUCIAN_DOCKER'] == nil
          RSpec.lucian_engine.stop_docker_service(self_services)
        end
        reporter.example_group_finished(self)
      end
    end

  end
end

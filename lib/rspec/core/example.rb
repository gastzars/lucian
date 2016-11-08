module RSpec::Core
  class Example
    def run(example_group_instance, reporter)
      @example_group_instance = example_group_instance
      @reporter = reporter
      RSpec.configuration.configure_example(self, hooks)
      RSpec.current_example = self

      start(reporter)
      Pending.mark_pending!(self, pending) if pending?

      begin
        if skipped?
          Pending.mark_pending! self, skip
        elsif !RSpec.configuration.dry_run?
          with_around_and_singleton_context_hooks do
            begin
              # NOTE Code is overrided HERE
              # Check if there are services or not 
              if self.metadata[:services] != nil && self.metadata[:services].is_a?(Array) && ENV["LUCIAN_DOCKER"] == nil
                run_docker_services
                run_lucian_test
              else
                run_before_example
                @example_group_instance.instance_exec(self, &@example_block)

                if pending?
                  Pending.mark_fixed! self

                  raise Pending::PendingExampleFixedError,
                        'Expected example to fail since it is pending, but it passed.',
                        [location]
                end
              end
            rescue Pending::SkipDeclaredInExample
              # no-op, required metadata has already been set by the `skip`
              # method.
            rescue AllExceptionsExcludingDangerousOnesOnRubiesThatAllowIt => e
              set_exception(e)
            ensure
              run_after_example
              stop_docker_services if self.metadata[:services] != nil && self.metadata[:services].is_a?(Array) && ENV["LUCIAN_DOCKER"] == nil
            end
          end
        end
      rescue Support::AllExceptionsExceptOnesWeMustNotRescue => e
        set_exception(e)
      ensure
        @example_group_instance = nil # if you love something... let it go
      end

      finish(reporter)
    ensure
      execution_result.ensure_timing_set(clock)
      RSpec.current_example = nil
    end

    def run_docker_services
      Lucian::BoardCaster.print("\n>> ExampleGroup : "+self.metadata[:full_description].to_s, "cyan")
      RSpec.lucian_engine.run_docker_service(self.metadata[:services])
    end

    def stop_docker_services
      RSpec.lucian_engine.stop_docker_service(self.metadata[:services])
    end

    def run_lucian_test
      
    end
  end
end

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
                result = run_lucian_test
                if result[2].to_i != 0
                  pending_cut = result[0].join("\n").gsub("\n", "--_n").match(/(PENDING.*)FAILING/)[0] rescue nil
                  failing_cut = result[0].join("\n").gsub("\n", "--_n").match(/(FAILING.*)Finished/)[0] rescue nil
                  unless pending_cut.nil? # Pending present?
                    # TODO Add pending logic here
                  end
                  unless failing_cut.nil? # Failing present?
                    failing_cases = failing_cut.scan(/\|=:.*:=\|/)
                    failing_cases.each do |_case|
                      data_cases = _case.split(":=|").collect{|message|
                        message.gsub("|=:","").split(":|-|:").collect{|_em| 
                          _em.gsub("--_n", "\n")
                        }
                      }
                      data_cases.each do |to_report|
                        #description = to_report[0]
                        lines = to_report[1]
                        traces = to_report[2]
                        error = StandardError.new(traces)
                        error.set_backtrace([lines])
                        raise error
                      end
                    end
                  end
                end
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

    def run_lucian_test
      if Lucian.image.nil? || Lucian.container.nil?
        Lucian.start_lucian_docker
      end
      Lucian.run_lucian_test(self.metadata[:full_description].to_s)
    end
  end
end

require 'rspec/core/formatters/console_codes'

module Lucian
  class CustomFormatter
    RSpec::Core::Formatters.register self, :dump_pending, :dump_failures, :close,
      :dump_summary, :example_passed, :example_failed, :example_pending
  
    def initialize output
      @output = output
    end
  
    def example_passed notification
      @output << RSpec::Core::Formatters::ConsoleCodes.wrap("\nPASSED", :success)
    end
  
    def example_failed notification
      @output << RSpec::Core::Formatters::ConsoleCodes.wrap("\nFAILED", :failure)
    end
  
    def example_pending notification
      @output << RSpec::Core::Formatters::ConsoleCodes.wrap("\nPENDED", :pending)
    end
  
    def dump_pending notification
      if notification.pending_examples.length > 0
        @output << "\n\n#{RSpec::Core::Formatters::ConsoleCodes.wrap("PENDING:", :pending)}\n"
        @output << notification.pending_examples.map {|example| "|=:" + example.full_description + ":|-|:" + example.location + ":=|" }.join("\n")
      end
    end
  
    def dump_failures notification
      if notification.failed_examples.length > 0
        @output << "\n#{RSpec::Core::Formatters::ConsoleCodes.wrap("FAILING:", :failure)}\n"
        @output << failed_examples_output(notification)
      end
    end
  
    def dump_summary notification
      @output << "\n\nFinished in #{RSpec::Core::Formatters::Helpers.format_duration(notification.duration)}."
    end
  
    def close notification
      @output << "\n"
    end
  
    private
  
    def failed_examples_output notification
      failed_examples_output = notification.failed_examples.map do |example|
        failed_example_output example
      end
      build_examples_output(failed_examples_output)
    end
  
    def build_examples_output output
      output.join("\n\n")
    end
  
    def failed_example_output example
      full_description = example.full_description
      location = example.location
      formatted_message = strip_message_from_whitespace(example.execution_result.exception.message)
      "|=:#{full_description}:|-|:#{location}:|-|:#{formatted_message}:=|"
    end
  
    def strip_message_from_whitespace msg
      msg.split("\n").map(&:strip).join("\n")
    end
  
    def add_spaces n
      " " * n
    end
  end
end

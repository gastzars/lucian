require 'lucian/version'
require 'docker/compose'
require 'rspec/core'
require 'docker-api'

require_relative 'lucian/engine'
require_relative 'lucian/errors'
require_relative 'lucian/initiator'
require_relative 'lucian/board_caster'
require_relative 'rspec'
require_relative 'rspec/core/example_group'
require_relative 'rspec/core/example'
require_relative 'rspec/core/configuration'
require_relative 'rspec/core/configuration_options'
require_relative 'rspec/core/runner'
require_relative 'lucian/custom_formatter'
require_relative 'docker/compose/session'

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

  ##
  # Start lucian docker
  def self.start_lucian_docker
    engine.start_lucian_docker
  end

  ##
  # Run lucian test
  def self.run_lucian_test(example)
    engine.run_lucian_test(example)
  end

  class << self
    attr_accessor :engine, :image, :container
  end
end


require 'lucian/version'
require 'docker/compose'
require 'rspec/core'

require_relative 'lucian/engine'
require_relative 'lucian/errors'
require_relative 'lucian/initiator'
require_relative 'lucian/board_caster'

module Lucian
  DIRECTORY = 'lucian'
  HELPER = 'lucian_helper.rb'

  include RSpec::Core

  ##
  # Overrided RSpec describe

  def self.describe(description, *args)
    super(description, args)
  end

  def self.context(description, *args)
    super(description, args)
  end

  def self.fdescribe(description, *args)
    super(description, args)
  end

  def self.fcontext(description, *args)
    super(description, args)
  end

  ##
  # Overrided RSpec example method

  def self.it(description, *args)
    super(description, args)
  end

  def self.example(description, *args)
    super(description, args)
  end

  def self.specify(description, *args)
    super(description, args)
  end

  def self.focus(description, *args)
    super(description, args)
  end

  def self.fexample(description, *args)
    super(description, args)
  end

  def self.fit(description, *args)
    super(description, args)
  end

  def self.fspecify(description, *args)
    super(description, args)
  end
end

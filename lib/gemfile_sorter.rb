# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module GemfileSorter
  class InvalidLineComparisonError < StandardError; end

  def self.sort_gemfile(directory_name = ".")
    Parser.parse("#{directory_name}/Gemfile")
  end
end

loader.eager_load

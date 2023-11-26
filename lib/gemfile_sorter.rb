# frozen_string_literal: true

require "fileutils"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module GemfileSorter
  class InvalidLineComparisonError < StandardError; end

  def self.sort_gemfile(directory_name = ".")
    Parser.parse("#{directory_name}/Gemfile")
  end

  def self.execute(directory_name = ".")
    result = Parser.parse("#{directory_name}/Gemfile")
    FileUtils.mv("#{directory_name}/Gemfile", "#{directory_name}/Gemfile.unsorted")
    File.write("#{directory_name}/Gemfile", result)
  end
end

loader.eager_load

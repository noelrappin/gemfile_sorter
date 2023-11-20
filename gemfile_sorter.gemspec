# frozen_string_literal: true

require_relative "lib/gemfile_sorter/version"

Gem::Specification.new do |spec|
  spec.name = "gemfile_sorter"
  spec.version = GemfileSorter::VERSION
  spec.authors = ["Noel Rappin"]
  spec.email = ["noelrap@hey.com"]

  spec.summary = "Sorts gemfiles based on name, group, and source"
  spec.description = "Sorts gemfiles based on name, group, and source"
  spec.homepage = "https://github.com/noelrappin/gemfile_sorter"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/noelrappin/gemfile_sorter"
  spec.metadata["changelog_uri"] = "https://github.com/noelrappin/gemfile_sorter/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-collection_matchers"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "zeitwerk"

  spec.add_dependency "awesome_print"
end

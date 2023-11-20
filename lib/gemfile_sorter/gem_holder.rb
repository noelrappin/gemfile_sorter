module GemfileSorter
  module GemHolder
    attr_accessor :gems

    def add_gem(gem)
      @gems[gem.name] = gem
    end

    def gem_string
      gems.values.sort.map { _1.to_s }.join.delete_prefix("\n")
    end
  end
end

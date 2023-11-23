module GemfileSorter
  class GemHolder
    attr_accessor :gems, :line, :line_number

    def initialize(name, line:, line_number:)
      @gems = {}
      @line = line
      @line_number = line_number
    end

    def add_gem(gem)
      @gems[gem.name] = gem
    end

    def gem_string
      gems.values.sort.map { _1.to_s }.join.delete_prefix("\n")
    end

    def to_s
      "\n" + line + gem_string.delete_suffix(",") + "end\n"
    end

    def empty? = gems.empty?
  end
end

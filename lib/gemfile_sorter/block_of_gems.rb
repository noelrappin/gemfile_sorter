module GemfileSorter
  class BlockOfGems
    attr_accessor :gems, :line, :line_number

    def initialize(name, line:, line_number:)
      @gems = {}
      @line = line
      @line_number = line_number
    end

    def container? = false

    def inside_block_map = nil

    def add(gem)
      @gems[gem.name] = gem
    end

    def gem_string
      gems.values.sort.map { _1.to_s }.join.delete_prefix("\n")
    end

    def leading_spaces
      line.match(/(\A *)/)[1]
    end

    def to_s
      "\n" +
        line +
        gem_string.delete_suffix(",") +
        (inside_block_map&.to_s || "") +
        "#{leading_spaces}end\n"
    end

    def empty? = gems.empty?
  end
end

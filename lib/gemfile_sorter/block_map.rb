module GemfileSorter
  class BlockMap
    attr_accessor :blocks

    def initialize
      @blocks = {}
    end

    def empty? = blocks.empty?

    def extra_line_unless_empty
      empty? ? "" : "\n"
    end

    def add_gem(gem)
      add(gem.inline_result, line: gem.inline_line, line_number: gem.line_number)
    end

    def add(names, line:, line_number:)
      block = block(names, line:, line_number:)
      blocks[block.normalized_name] ||= block
    end

    def to_s
      extra_line_unless_empty +
        blocks.values.sort.map { _1.to_s }.join.delete_prefix("\n")
    end
  end
end

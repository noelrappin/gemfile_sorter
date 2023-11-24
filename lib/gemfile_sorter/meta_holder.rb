module GemfileSorter
  class MetaHolder
    attr_accessor :gem_holders

    def initialize
      @gem_holders = {}
    end

    def empty? = gem_holders.empty?

    def extra_line_unless_empty
      empty? ? "" : "\n"
    end

    def add(names, line:, line_number:)
      holder = holder(names, line:, line_number:)
      gem_holders[holder.normalized_name] ||= holder
    end

    def to_s
      extra_line_unless_empty +
        gem_holders.values.sort.map { _1.to_s }.join.delete_prefix("\n")
    end
  end
end

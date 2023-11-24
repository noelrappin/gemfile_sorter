module GemfileSorter
  class Groups
    include LineGrouping

    attr_accessor :groups

    def initialize
      @groups = {}
    end

    def empty? = groups.empty?

    def add(names, line:, line_number:)
      group = Line::Group.new(names, line:, line_number:)
      groups[group.normalized_name] ||= group
    end

    def to_s
      extra_line_unless_empty +
        groups.values.sort.map { _1.to_s }.join.delete_prefix("\n")
    end
  end
end

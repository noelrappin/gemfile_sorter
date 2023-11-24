module GemfileSorter
  class Sources
    include LineGrouping

    attr_accessor :sources

    def initialize
      @sources = {}
    end

    def empty? = sources.empty?

    def add(name, line:, line_number:)
      source = Line::Source.new(name, line:, line_number:)
      sources[source.name] ||= source
    end

    def to_s
      extra_line_unless_empty +
        sources.values.sort.map { _1.to_s }.join.delete_prefix("\n")
    end
  end
end

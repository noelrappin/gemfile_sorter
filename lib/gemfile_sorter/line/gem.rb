module GemfileSorter
  module Line
    class Gem
      include Comparable
      attr_reader :group_extractor
      attr_accessor :line, :name, :options, :line_number, :comment_group

      def initialize(name, comment_group = nil, *options, line: "", line_number: nil)
        @line = line.rstrip
        @name = name
        @options = options
        @line_number = line_number
        @comment_group = comment_group || CommentGroup.new
        @group_extractor = GemExtractor.new(self, "group")
      end

      def to_s
        (comment_group.empty? ? "" : "\n") + comment_group.to_s + parsed_line + "\n"
      end

      def parsed_line
        group_extractor.updated_line
      end

      def extract_group
        group_extractor.extract
      end

      def <=>(other)
        name <=> other.name
      rescue
        raise InvalidLineComparisonError
      end
    end
  end
end

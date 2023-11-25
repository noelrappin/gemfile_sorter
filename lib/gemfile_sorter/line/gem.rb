module GemfileSorter
  module Line
    class Gem
      include Comparable
      attr_reader :group_extractor, :source_extractor
      attr_accessor :line, :name, :options, :line_number, :comment_group, :parsed

      def initialize(name, comment_group = nil, *options, line: "", line_number: nil)
        @line = line.rstrip
        @name = name
        @options = options
        @line_number = line_number
        @comment_group = comment_group || CommentGroup.new
        @group_extractor = GemExtractor.new(self, "group")
        @source_extractor = GemExtractor.new(self, "source")
        @parsed = false
      end

      def to_s
        (comment_group.empty? ? "" : "\n") + comment_group.to_s + parsed_line + "\n"
      end

      def parsed_line
        return line unless inline_match?
        inline_match.updated_line
      end

      def inline_match
        extract unless parsed
        [group_extractor, source_extractor]
          .find { _1.match? }
      end

      def inline_match? = !!inline_match

      def extract
        self.parsed = true
        group_extractor.extract || source_extractor.extract
      end

      def inline_kind = inline_match&.key

      def inline_result = inline_match&.result_string

      def inline_line = inline_match.resulting_first_line

      def <=>(other)
        name <=> other.name
      rescue
        raise InvalidLineComparisonError
      end
    end
  end
end

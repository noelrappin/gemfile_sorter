module GemfileSorter
  module Line
    class Gem
      include Comparable
      attr_accessor :line, :name, :options, :line_number, :comment_group, :parsed_line

      def initialize(name, comment_group = nil, *options, line: "", line_number: nil)
        @line = line.rstrip
        @name = name
        @options = options
        @parsed_line = line
        @line_number = line_number
        @comment_group = comment_group || CommentGroup.new
      end

      def to_s
        (comment_group.empty? ? "" : "\n") + comment_group.to_s + parsed_line
      end

      def extract_group
        group_index = options.find_index { _1.match(/group/) }
        return unless group_index
        pointer = group_index + 1
        result = [options[pointer]]
        if result.first&.match?("=>")
          pointer += 1
          result = [options[pointer]]
        end
        if result.first&.start_with?("[")
          loop do
            pointer += 1
            result << options[pointer]
            break if result.last&.end_with?("]")
          end
        end
        line_start = parsed_line.index(options[group_index]) - 2
        line_end = parsed_line.index(result.last) + result.last.size - 1
        parsed_line[line_start..line_end] = ""
        self.parsed_line = "  #{parsed_line}"
        result.map do |str|
          str.to_s
            .delete_prefix(":")
            .delete_prefix("[:")
            .delete_suffix("]")
        end.sort.join(", ")
      end

      def <=>(other)
        name <=> other.name
      rescue
        raise InvalidLineComparisonError
      end
    end
  end
end

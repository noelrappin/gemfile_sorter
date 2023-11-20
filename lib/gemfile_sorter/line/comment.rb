module GemfileSorter
  module Line
    class Comment
      attr_accessor :line, :line_number

      def initialize(line: nil, line_number: nil)
        @line = line
        @line_number = line_number
      end

      def comments = [self]

      def to_s = line
    end
  end
end

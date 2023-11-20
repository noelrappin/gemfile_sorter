module GemfileSorter
  module Line
    class Group
      include GemHolder
      attr_accessor :names, :line, :line_number, :gems

      def initialize(*names, line:, line_number:)
        @names = names
        @line = line
        @line_number = line_number
        @gems = {}
      end

      def normalized_name
        Array(names).flatten.map { _1.delete_prefix(":") }.sort.join(", ")
      end

      def <=>(other)
        normalized_name <=> other.normalized_name
      rescue
        raise InvalidLineComparisonError
      end

      def to_s
        "\n" + line + gem_string.delete_suffix(",") + "end\n"
      end
    end
  end
end

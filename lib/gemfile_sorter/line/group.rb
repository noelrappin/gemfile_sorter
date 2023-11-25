module GemfileSorter
  module Line
    class Group < BlockOfGems
      attr_accessor :names

      def initialize(*names, line:, line_number:)
        @names = names
        super(normalized_name, line:, line_number:)
      end

      def normalized_name
        Array(names).flatten.map { _1.delete_prefix(":") }.sort.join(", ")
      end

      def <=>(other)
        normalized_name <=> other.normalized_name
      rescue
        raise InvalidLineComparisonError
      end
    end
  end
end

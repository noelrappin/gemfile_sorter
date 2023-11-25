module GemfileSorter
  module Line
    class Group < BlockOfGems
      attr_accessor :names, :sources

      def initialize(*names, line:, line_number:)
        @names = names
        @sources = Sources.new
        super(normalized_name, line:, line_number:)
      end

      def container? = true

      def inside_block_map = sources

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

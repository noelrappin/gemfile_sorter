module GemfileSorter
  module Line
    class Source < BlockOfGems
      attr_accessor :name, :groups

      def initialize(name, line:, line_number:)
        @name = name
        @groups = Groups.new
        super(name, line:, line_number:)
      end

      def container? = true

      def inside_block_map = groups

      def normalized_name = name

      def <=>(other)
        name <=> other.name
      rescue
        raise InvalidLineComparisonError
      end
    end
  end
end

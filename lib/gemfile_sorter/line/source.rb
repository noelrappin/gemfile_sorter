module GemfileSorter
  module Line
    class Source < GemHolder
      attr_accessor :name

      def initialize(name, line:, line_number:)
        @name = name
        super(name, line:, line_number:)
      end

      def <=>(other)
        name <=> other.name
      rescue
        raise InvalidLineComparisonError
      end
    end
  end
end

module GemfileSorter
  class Sources < MetaHolder
    def holder(name, line:, line_number:)
      Line::Source.new(name, line:, line_number:)
    end
  end
end

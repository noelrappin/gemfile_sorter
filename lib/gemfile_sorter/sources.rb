module GemfileSorter
  class Sources < BlockMap
    def block(name, line:, line_number:)
      Line::Source.new(name, line:, line_number:)
    end
  end
end

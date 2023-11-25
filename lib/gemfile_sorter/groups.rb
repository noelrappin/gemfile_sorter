module GemfileSorter
  class Groups < BlockMap
    def block(names, line:, line_number:)
      Line::Group.new(names, line:, line_number:)
    end
  end
end

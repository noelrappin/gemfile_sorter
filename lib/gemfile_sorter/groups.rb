module GemfileSorter
  class Groups < MetaHolder
    def holder(names, line:, line_number:)
      Line::Group.new(names, line:, line_number:)
    end
  end
end

module GemfileSorter
  module LineGrouping
    def extra_line_unless_empty
      empty? ? "" : "\n"
    end
  end
end

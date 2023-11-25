module GemfileSorter
  class GemExtractor
    attr_reader :gem, :key
    attr_accessor :running_pointer, :result

    def initialize(gem, key)
      @gem = gem
      @key = key
      @running_pointer = nil
      @result = []
    end

    def options = gem.options

    def starting_index = options.find_index { _1.match(/#{key}/) }

    def match? = !!starting_index

    def running_option = options[running_pointer]

    def increment_pointer = self.running_pointer += 1

    def initial_result
      value = running_option
      if value.match?("=>")
        increment_pointer
        value = running_option
      end
      value
    end

    def extract_multiple_results
      return unless result.first&.start_with?("[")
      loop do
        increment_pointer
        result << running_option
        break if result.last&.end_with?("]")
      end
    end

    def extraction_start
      gem.line.index(options[starting_index]) - 2
    end

    def extraction_end
      size = (result.last&.size || 0)
      size += 1 unless symbol_result?
      gem.line.index(result.last) + (size || 0) - 1
    end

    def updated_line
      return gem.line if result.empty?
      result = gem.line
      result[extraction_start..extraction_end] = ""
      "  #{result}"
    end

    def result_string
      result.map do |str|
        str.to_s
          .delete_prefix(":")
          .delete_prefix("[:")
          .delete_suffix("]")
      end.sort.join(", ")
    end

    def extract_initial_result
      self.running_pointer = starting_index + 1
      result << initial_result
    end

    def extract
      return unless match?
      extract_initial_result
      extract_multiple_results
      result_string
    end

    def symbol_result? = result.last&.include?(":")

    def annotated_result
      symbol_result? ? ":#{result_string}" : %("#{result_string}")
    end

    def resulting_first_line
      "#{key} #{annotated_result} do\n"
    end
  end
end

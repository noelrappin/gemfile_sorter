RSpec::Matchers.define :be_split_into do |expected_result|
  match do |initial_line|
    GemfileSorter::Parser.new("filename")
    actual(initial_line) == expected_result
  end

  def actual(initial_line)
    parser = GemfileSorter::Parser.new("filename")
    parser.split_line(initial_line)
  end

  failure_message do |initial_line|
    message = ["Expected #{initial_line} to be correctly split:"]
    actual_split = actual(initial_line)
    expected_result.each_with_index do |element, index|
      message << "#{index + 1}e| #{element}"
      if actual_split[index] != element
        message << "#{index + 1}a| #{actual_split[index]}"
      end
      message << "\n"
    end
    actual_split[expected_result.size..].each_with_index do |element, index|
      message << "#{index + expected_result.size + 1}e|"
      message << "#{index + expected_result.size + 1}a| #{element}"
    end

    message.join("\n")
  end
end

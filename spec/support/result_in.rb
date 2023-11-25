RSpec::Matchers.define :result_in do |expected_result|
  chain(:group) { @key = "group" }
  chain(:source) { @key = "source" }

  match do |incoming_options|
    @expected_result = expected_result
    @gem = gem(incoming_options)
    @extractor = GemfileSorter::GemExtractor.new(@gem, @key)
    @extractor.extract
    actual_result == expected_result && option_check && line_check
  end

  failure_message do |incoming_options|
    if actual_result != expected_result
      "Expected #{incoming_options} to have a #{@key} of #{expected_result}, but it has #{actual_result}"
    elsif !line_check
      "Expected #{incoming_options} to result in a line of -#{expected_line}-, but it has -#{@extractor.updated_line}-"
    end
  end

  def gem(incoming_options)
    GemfileSorter::Line::Gem.new(
      "zeitwerk",
      nil,
      *incoming_options,
      line: %(gem "zeitwerk", "1.2.3", #{incoming_options.join(" ")}).strip,
      line_number: 1
    )
  end

  def expected_line
    if @extractor.match?
      %(  gem "zeitwerk", "1.2.3")
    else
      %(gem "zeitwerk", "1.2.3",)
    end
  end

  def option_check
    return true unless @options
    @gem.options == @options
  end

  def line_check
    @gem.parsed_line == expected_line
  end

  def actual_result
    @actual_result ||= @extractor.result_string
  end
end

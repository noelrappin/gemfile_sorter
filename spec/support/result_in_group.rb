RSpec::Matchers.define :result_in_group do |expected_group|

  match do |incoming_options|
    @expected_group = expected_group
    @gem = gem(incoming_options)
    actual_group == expected_group && option_check && line_check
  end

  failure_message do |incoming_options|
    if actual_group != expected_group
      "Expected #{incoming_options} to have a group of #{expected_group}, but it has #{actual_group}"
    elsif !line_check
      "Expected #{incoming_options} to result in a line of -#{expected_line}-, but it has -#{@gem.parsed_line}-"
    end
  end

  def gem(incoming_options)
    GemfileSorter::Line::Gem.new(
      "zeitwerk",
      nil,
      *incoming_options,
      line: %(gem "zeitwerk", "1.2.3", #{incoming_options.join(" ")}).strip,
      line_number: 1)
  end

  def expected_line
    if @expected_group
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

  def actual_group
    @actual_group ||= @gem.extract_group
  end
end

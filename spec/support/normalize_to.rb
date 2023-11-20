RSpec::Matchers.define :normalize_to do |normalized_name|
  match do |name_list|
    @group = group(name_list)
    actual == normalized_name
  end

  failure_message do |name_list|
    "Expected #{name_list} to be #{normalized_name} (#{normalized_name.class}), actually it is #{actual} (#{actual.class})"
  end

  def group(name_list)
    GemfileSorter::Line::Group.new(name_list, line: "", line_number: 1)
  end

  def actual = @group.normalized_name
end

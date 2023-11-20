RSpec::Matchers.define :be_correctly_sorted do
  match do |directory_name|
    actual(directory_name) == expected_text(directory_name)
  end

  description do |directory_name|
    "correctly sort #{directory_name}"
  end

  failure_message do |directory_name|
    message = ["Expected #{directory_name} to be correctly sorted:"]
    ap actual(directory_name).split("\n")
    result_lines = actual(directory_name).split("\n")
    expected_lines = expected_text(directory_name).split("\n")
    expected_lines.each_with_index do |line, index|
      message << "#{index + 1}e| #{line}"
      if result_lines[index] != line
        message << "#{index + 1}a| #{result_lines[index]}"
      end
      message << "\n"
    end
    (result_lines[expected_lines.size..] || []).each_with_index do |element, index|
      message << "\n"
      message << "#{index + expected_lines.size + 1}e|"
      message << "#{index + expected_lines.size + 1}a| #{element}"
    end
    message.join("\n")
  end

  def full_directory(directory_name)
    "spec/unsorted_samples/#{directory_name}"
  end

  def actual(directory_name)
    GemfileSorter.sort_gemfile(full_directory(directory_name))
  end

  def expected_text(directory_name)
    File.read("spec/sorted_samples/#{directory_name}")
  end
end

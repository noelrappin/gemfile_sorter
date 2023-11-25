module GemfileSorter
  RSpec.describe GemExtractor do
    describe "extract groups" do
      specify { expect(%w[]).to result_in("").group }
      specify { expect(%w[group: :development]).to result_in("development").group }
      specify { expect(%w[group: development]).to result_in("development").group }
      specify { expect(%w[:group => development]).to result_in("development").group }
      specify { expect(%w[group => development]).to result_in("development").group }
      specify { expect(%w[group: \[:development :test\]]).to result_in("development, test").group }
      specify { expect(%w[group: \[:test :development\]]).to result_in("development, test").group }
    end

    describe "extract sources" do
      specify { expect(%w[]).to result_in("").source }
      specify { expect(%w[source: localhost]).to result_in("localhost").source }
      specify { expect(%w[:source => localhost]).to result_in("localhost").source }
    end
  end
end

module GemfileSorter
  module Line
    RSpec.describe Gem do
      describe "sorting" do
        let(:gem_1) { Gem.new("awesome_print") }
        let(:gem_2) { Gem.new("zeitwerk") }

        it "correctly notices greater and lesser" do
          expect(gem_1).to be < gem_2
          expect(gem_2).to be > gem_1
          expect(gem_1).to be == gem_1
        end

        it "handles bad conditions" do
          expect { gem_1 <=> nil }.to raise_error(InvalidLineComparisonError)
          expect { gem_1 <=> "3" }.to raise_error(InvalidLineComparisonError)
        end
      end

      describe "output" do
        it "prints just the line without comments" do
          gem = Gem.new("zeitwerk", line: %(gem "zeitwerk", "1.2.3"))
          expect(gem.to_s).to eq(%(gem "zeitwerk", "1.2.3"\n))
        end
      end

      describe "extract groups" do
        it "extracts a symbol based single group", :aggregate_failures do
          expect(%w[]).to result_in_group(nil)
          expect(%w[group: :development]).to result_in_group("development")
          expect(%w[group: development]).to result_in_group("development")
          expect(%w[:group => development]).to result_in_group("development")
          expect(%w[group => development]).to result_in_group("development")
          expect(%w[group: \[:development :test\]]).to result_in_group("development, test")
          expect(%w[group: \[:test :development\]]).to result_in_group("development, test")
        end
      end
    end
  end
end

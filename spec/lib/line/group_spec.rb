module GemfileSorter
  module Line
    RSpec.describe Group do
      describe "normalized names", :aggregate_failures do
        it "can normalize names" do
          expect("development").to normalize_to("development")
          expect(":development").to normalize_to("development")
          expect(%w[:development :test]).to normalize_to("development, test")
          expect(%w[:test :development]).to normalize_to("development, test")
        end
      end
    end
  end
end

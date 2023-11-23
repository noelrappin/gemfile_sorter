module GemfileSorter
  RSpec.describe Parser do
    describe "splitting a line", :aggregate_failures do
      it "correctly splits a simple gem line" do
        expect(%(gem "zeitwerk")).to be_split_into(%w[gem zeitwerk])
        expect(%(gem    "zeitwerk")).to be_split_into(%w[gem zeitwerk])
        expect(%(gem "zeitwerk", "1.2.3"))
          .to be_split_into(%w[gem zeitwerk 1.2.3])
        expect(%(gem 'zeitwerk')).to be_split_into(%w[gem zeitwerk])
        expect(%[gem("zeitwerk")]).to be_split_into(%w[gem zeitwerk])
        expect("# frozen_string_literal: true")
          .to be_split_into(%w[# frozen_string_literal: true])
        expect(%(gem "bootsnap", require: false))
          .to be_split_into(%w[gem bootsnap require: false])
        expect(%(gem "bootsnap", :require => false))
          .to be_split_into(%w[gem bootsnap :require => false])
        expect(%(gem "zeitwerk", "1.2.3", group: :development))
          .to be_split_into(%w[gem zeitwerk 1.2.3 group: :development])
        expect(%(gem "zeitwerk", "1.2.3", group: "development"))
          .to be_split_into(%w[gem zeitwerk 1.2.3 group: development])
        expect(%(gem "zeitwerk", "1.2.3", :group => "development"))
          .to be_split_into(%w[gem zeitwerk 1.2.3 :group => development])
        expect(%(gem "zeitwerk", "1.2.3", "group" => "development"))
          .to be_split_into(%w[gem zeitwerk 1.2.3 group => development])
        expect(%(gem "zeitwerk", "1.2.3", group: [:development, :test]))
          .to be_split_into(%w[gem zeitwerk 1.2.3 group: \[:development :test\]])
      end
    end

    describe "parsing a line" do
      let(:parser) { Parser.new("filename") }

      it "parses a gem" do
        result = parser.parse_line(%(gem "zeitwerk", "1.2.3"), 1)
        expect(result).to be_a(GemfileSorter::Line::Gem)
        expect(result.name).to eq("zeitwerk")
        expect(result.line_number).to eq(1)
        expect(result.line).to eq(%(gem "zeitwerk", "1.2.3"))
        expect(result.options).to eq(%w[1.2.3])
        expect(parser.top_level_gems.gems).to eq({"zeitwerk" => result})
      end

      it "parses a commented gem" do
        result = parser.parse_line(%(# gem "zeitwerk", "1.2.3"), 1)
        expect(result).to be_a(GemfileSorter::Line::Gem)
        expect(result.name).to eq("zeitwerk")
        expect(result.line_number).to eq(1)
        expect(result.line).to eq(%(# gem "zeitwerk", "1.2.3"))
        expect(result.options).to eq(%w[1.2.3])
        expect(parser.top_level_gems.gems).to eq({"zeitwerk" => result})
      end

      it "parses a comment" do
        result = parser.parse_line(%(# comment), 1)
        expect(result).to be_a(GemfileSorter::Line::Comment)
        expect(result).to have_attributes(
          line: %(# comment),
          line_number: 1
        )
        expect(parser.current_comments.comments).to eq([result])
      end

      it "adds current comments to next gem" do
        comment = parser.parse_line(%(# comment), 1)
        gem = parser.parse_line(%(# gem "zeitwerk", "1.2.3"), 1)
        expect(gem.comment_group.comments).to eq([comment])
        expect(parser.current_comments.comments).to eq([])
      end
    end
  end
end

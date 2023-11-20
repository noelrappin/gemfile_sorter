module GemfileSorter
  class Parser
    include GemHolder
    attr_reader :filename, :groups
    attr_accessor :current_comments, :leading_comments, :current_group

    def self.parse(filename)
      parser = new(filename)
      parser.parse
      parser.output
    end

    def initialize(filename)
      @filename = filename
      @gems = {}
      @leading_comments = CommentGroup.new
      @current_comments = CommentGroup.new
      @current_group = nil
      @groups = Groups.new
    end

    def contents
      @contents ||= File.readlines(filename)
    end

    def parse
      contents.each_with_index do |line, index|
        parse_line(line, index + 1)
      end
    end

    # handle % delimiters?
    def split_line(line)
      line.strip.split(/\s|\(|\)|,/)
        .map { _1.gsub(/\A"|"\Z|\A'|'\Z/, "") }
        .map { _1.strip }
        .reject { _1.empty? }
    end

    def output
      leading_comments.to_s +
        gem_string +
        groups.to_s +
        current_comments.extra_line_unless_empty +
        current_comments.to_s
    end

    def parse_line(line, line_number)
      case split_line(line)
      in ["gem", name, *options]
        handle_gem(name, *options, line:, line_number:)
      in ["#", "gem", name, *options]
        handle_gem(name, *options, line:, line_number:)
      in ["#", *_rest]
        handle_comment(*_rest, line:, line_number:)
      in ["group", *names, "do"]
        handle_group(names, line:, line_number:)
      in ["end"]
        handle_end
      in []
        handle_blank_line
      else
        # treat other lines like comments
        handle_comment(*_rest, line:, line_number:)
      end
    end

    def group_for_gem(gem)
      group = nil
      group_name = gem.extract_group
      if group_name
        group = groups.add_group(group_name, line: "group :#{group_name} do\n", line_number: gem.line_number)
      end
      group || current_group || self
    end

    def handle_gem(name, *options, line:, line_number:)
      result = Line::Gem.new(name, current_comments, *options, line_number:, line:)
      group_for_gem(result).add_gem(result)
      self.current_comments = CommentGroup.new
      result
    end

    def handle_group(names, line:, line_number:)
      group = groups.add_group(names, line:, line_number:)
      self.current_group = group
    end

    def handle_end
      self.current_group = nil
    end

    def handle_comment(*_rest, line:, line_number:)
      result = Line::Comment.new(line:, line_number:)
      current_comments << result
      result
    end

    def handle_blank_line
      if gems.empty?
        leading_comments << current_comments unless current_comments.empty?
        leading_comments << GemfileSorter::Line::BlankLine.new unless leading_comments.empty?
        self.current_comments = CommentGroup.new
      elsif !current_comments.empty?
        current_comments << GemfileSorter::Line::BlankLine.new
      end
    end
  end
end

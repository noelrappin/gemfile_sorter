module GemfileSorter
  class Parser
    attr_reader :filename, :groups, :block_stack, :top_level_gems, :sources
    attr_accessor :current_comments, :leading_comments

    def self.parse(filename)
      parser = new(filename)
      parser.parse
      parser.output
    end

    def initialize(filename)
      @filename = filename
      @top_level_gems = BlockOfGems.new("top_level", line: "", line_number: nil)
      @leading_comments = CommentGroup.new
      @current_comments = CommentGroup.new
      @block_stack = [@top_level_gems]
      @groups = Groups.new
      @sources = Sources.new
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
        top_level_gems.gem_string +
        groups.to_s +
        sources.to_s +
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
        handle_block(:groups, names, line:, line_number:)
      in ["source", name, "do"]
        handle_block(:sources, name, line:, line_number:)
      in ["end"]
        handle_end
      in []
        handle_blank_line
      else
        # treat other lines like comments
        handle_comment(*_rest, line:, line_number:)
      end
    end

    def current_block_map_container
      block_stack.last.container? ? block_stack.last : self
    end

    def block_for_gem(gem)
      group = add_inline_gem(gem)
      group || block_stack.last
    end

    def add_inline_gem(gem)
      return unless gem.inline_match?
      block_map = (gem.inline_kind == "group") ? groups : sources
      block_map.add_gem(gem)
    end

    def handle_gem(name, *options, line:, line_number:)
      result = Line::Gem.new(name, current_comments, *options, line_number:, line:)
      block_for_gem(result).add(result)
      self.current_comments = CommentGroup.new
      result
    end

    def handle_block(block_map_name, name, line:, line_number:)
      block = current_block_map_container.send(block_map_name).add(name, line:, line_number:)
      block_stack.push(block)
    end

    def handle_end
      block_stack.pop
    end

    def handle_comment(*_rest, line:, line_number:)
      result = Line::Comment.new(line:, line_number:)
      current_comments << result
      result
    end

    def handle_blank_line
      if top_level_gems.empty?
        leading_comments << current_comments unless current_comments.empty?
        leading_comments << GemfileSorter::Line::BlankLine.new unless leading_comments.empty?
        self.current_comments = CommentGroup.new
      elsif !current_comments.empty?
        current_comments << GemfileSorter::Line::BlankLine.new
      end
    end
  end
end

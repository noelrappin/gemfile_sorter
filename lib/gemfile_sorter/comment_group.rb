module GemfileSorter
  class CommentGroup
    include Enumerable
    include LineGrouping
    attr_accessor :comments

    def initialize(*comments)
      @comments = comments.flatten
    end

    def to_s
      comments.map { _1.to_s }.join
    end

    def contents = comments

    def add(comment)
      self.comments += comment.comments
    end

    def <<(comment) = add(comment)

    def empty? = comments.empty?

    def each = comments.each
  end
end

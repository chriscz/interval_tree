module IntervalTree
  VERSION = "0.1.0"

  class Error < Exception
  end

  # TODO test tree behaviour when using round half even
  INTEGER_CENTER = ->(intervals : Array(Interval(Int32))) {
    ((
      intervals.map(&.begin).min +
      intervals.map(&.end).max
    ) / 2).round(mode = Number::RoundingMode::TIES_AWAY).to_i
  }

  class Interval(T)
    def self.from_range(v : Range(T, T))
      new(v.begin, v.end, v.exclusive?)
    end

    def initialize(@begin : T, @end : T, @exclusive : Bool = false)
    end

    def begin
      @begin
    end

    def end
      @end
    end

    def exclusive?
      @exclusive
    end

    def includes?(v : T)
      v >= @begin && (exclusive? ? v < @end : v <= @end)
    end

    def contains?(v : Interval(T))
      v.begin >= @begin && v.end <= @end
    end

    def overlaps_begin?(v : Interval(T))
    end

    def ==(other)
      # BROKEN IN CRYSTAL 1. To be fixed in 1.10
      # return false unless other.is_a?(self.class)
      return false unless other.is_a?(Interval(T))
      self.begin == other.begin && self.end == other.end && exclusive? == other.exclusive?
    end

    def inspect
      if exclusive?
        "(#{self.begin.inspect}...#{self.end.inspect})"
      else
        "(#{self.begin.inspect}..#{self.end.inspect})"
      end
    end
  end

  class Tree(T)
    @ranges : Array(Interval(T))
    @find_center : Array(Interval(T)) -> T
    @root : Node(T) | Node::Null(T)

    getter root

    def initialize(
      ranges : Enumerable(Interval(T)),
      interval_factory : (T, T) -> Interval(T),
      @find_center : Array(Interval(T)) -> T
    )
      @ranges = require_exclusive(ranges)
      @root = divide_intervals(@ranges)
    end

    def search(query : Interval(T)) : Array(Interval(T))
      @root.search(query)
    end

    def search(query : T) : Array(Interval(T))
      @root.search(query)
    end

    def search(query : Range(T, T))
      search(Interval(T).from_range(query))
    end

    def center
      @root.center
    end

    def divide_intervals(intervals)
      return Node::Null(T).new if intervals.empty?

      x_center = @find_center.call(intervals)
      s_center = [] of Interval(T)
      s_left = [] of Interval(T)
      s_right = [] of Interval(T)

      intervals.each do |i|
        case
        when i.end < x_center
          s_left << i
        when i.begin > x_center
          s_right << i
        else
          s_center << i
        end
      end

      Node(T).new(
        x_center,
        s_center,
        divide_intervals(s_left),
        divide_intervals(s_right)
      )
    end

    def require_exclusive(intervals)
      intervals.each do |i|
        raise "Expected interval #{i} to be exclusive" unless i.exclusive?
      end

      intervals.to_a
    end
  end

  class Node(T)
    class Null(T)
      def search(interval)
        return [] of Interval(T)
      end

      def center
        raise Error.new("empty node has no center")
      end

      def left
        self
      end

      def right
        self
      end

      def ==(other)
        other.is_a?(Null)
      end

      def inspect(indent = 0)
        "  "*indent + "()"
      end
    end

    getter center
    getter left
    getter right
    getter intervals

    def initialize(
      @center : T,
      @intervals : Array(Interval(T)),
      @left : Node(T) | Null(T) = Null(T).new,
      @right : Node(T) | Null(T) = Null(T).new
    )
    end

    def search(query : Interval(T))
      result = search_intervals(query)

      if query.begin < center
        result += left.search(query)
      end

      if query.end > center
        result += right.search(query)
      end

      result
    end

    def search(query : T)
      result = search_intervals(query)

      if query < center
        result += left.search(query)
      end

      if query > center
        result += right.search(query)
      end

      result
    end

    def search_intervals(query : T)
      intervals.select { |k| k.includes?(query) }
    end

    def search_intervals(query : Interval(T)) : Array(Interval(T))
      intervals.select do |k|
        ( # k is entirely contained within the query
          (k.begin >= query.begin) &&
            (k.end <= query.end)
        ) || ( # k's start overlaps with the query
          (k.begin >= query.begin) &&
            (k.begin < query.end)
        ) || ( # k's end overlaps with the query
          (k.end > query.begin) &&
            (k.end <= query.end)
        ) || ( # k is bigger than the query
          (k.begin < query.begin) &&
            (k.end > query.end)
        )
      end
    end

    def ==(other)
      return false unless other.is_a?(Node(T))
      center == other.center &&
        left == other.left &&
        right == other.right
    end

    def inspect(indent = 0)
      ivals = intervals.map(&.inspect).join(" ")
      lines = [
        "  " * indent + "(#{center.inspect}: #{ivals}",
        left.inspect(indent + 1),
        right.inspect(indent + 1),
        "  "*indent+ ")"
      ].join("\n")
    end
  end
end

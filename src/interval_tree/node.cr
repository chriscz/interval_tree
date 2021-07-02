module IntervalTree
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
        "  "*indent + ")",
      ].join("\n")
    end
  end
end

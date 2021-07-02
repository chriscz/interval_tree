module IntervalTree
  class Tree(T)
    @ranges : Array(Interval(T))
    @find_center : Enumerable(Interval(T)) -> T
    @root : Node(T) | Node::Null(T)

    getter root

    def initialize(
      ranges : Enumerable(Interval(T)),
      @find_center : Enumerable(Interval(T)) -> T
    )
      @ranges = require_exclusive(ranges)
      @root = divide_intervals(@ranges)
    end

    def initialize(
      ranges : Enumerable(Range(T, T)),
      find_center
    )
      initialize(
        ranges: ranges.map { |r| Interval(T).from(r) },
        find_center: find_center
      )
    end

    def initialize(
      ranges : Enumerable(Range(Int, Int)),
      find_center = Centering(T).integer
    )
      initialize(
        ranges: ranges.map { |r| Interval(T).from(r) },
        find_center: find_center
      )
    end

    def search(query : Interval(T)) : Array(Interval(T))
      @root.search(query)
    end

    def search(query : T) : Array(Interval(T))
      @root.search(query)
    end

    def search(query : Range(T, T))
      search(Interval(T).from(query))
    end

    def center
      @root.center
    end

    def divide_intervals(intervals)
      return Node::Null(T).new if intervals.empty?

      midpoint = @find_center.call(intervals.as(Enumerable(Interval(T))))

      left = [] of Interval(T)
      right = [] of Interval(T)
      center = [] of Interval(T)

      intervals.each do |i|
        case
        when i.end < midpoint
          left << i
        when i.begin > midpoint
          right << i
        else
          center << i
        end
      end

      Node(T).new(
        midpoint,
        center,
        divide_intervals(left),
        divide_intervals(right)
      )
    end

    def require_exclusive(intervals)
      intervals.each do |i|
        raise "Expected interval #{i} to be exclusive" unless i.exclusive?
      end

      intervals.to_a
    end
  end
end

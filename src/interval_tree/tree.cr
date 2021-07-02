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
      find_center)
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

      x_center = @find_center.call(intervals.as(Enumerable(Interval(T))))
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
end

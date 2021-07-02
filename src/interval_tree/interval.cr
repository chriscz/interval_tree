module IntervalTree
  class Interval(T)
    def self.from(v : Range(T, T))
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

    def overlaps_end?(v : Interval(T))
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
end

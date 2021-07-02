module IntervalTree
  class Interval(T)
    def self.from(v : Range(T, T))
      new(v.begin, v.end, v.exclusive?)
    end

    def self.from(v : T)
      new(v, v, false)
    end

    def self.from(v : Interval(T))
      v
    end

    def initialize(@begin : T, @end : T, @exclusive : Bool = false)
      raise Error.new("begin must be before end: #{@begin} < #{@end}") if @end < @begin
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

    def inclusive?
      !exclusive?
    end

    def includes?(v : T)
      v >= @begin && (exclusive? ? v < @end : v <= @end)
    end

    def overlap?(v : Interval(T))
      (@begin < v.end || v.inclusive? && @begin == v.end) && (@end > v.begin || inclusive? && @end == v.begin)
    end

    def overlap?(v : T)
      includes?(v)
    end

    def overlap?(r : Range(T, T))
      overlap?(self.class.from(r))
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

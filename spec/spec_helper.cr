require "spec"
require "../src/interval_tree"

struct Range
  def to_interval
    IntervalTree::Interval.from(self)
  end
end

class Array
  def to_intervals
    map do |r|
      IntervalTree::Interval.from(r)
    end
  end
end

struct Tuple
  def to_intervals
    map do |r|
      IntervalTree::Interval.from(r)
    end
  end
end

def ieq(v)
  case v
  when Enumerable
    eq(v.map { |r| IntervalTree::Interval.from(r) }.to_a)
  else
    eq(IntervalTree::Interval.from(v))
  end
end


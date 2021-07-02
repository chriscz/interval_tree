require "../spec_helper"

def ranges_to_intervals(ranges)
  ranges.map do |r|
    r.to_interval
  end
end

def int_tree(*ranges : Range(Int32, Int32))
  IntervalTree::Tree(Int32).new(
    ranges_to_intervals(ranges),
    ->(a : Int32, b : Int32) { IntervalTree::Interval.new(a, b) },
    IntervalTree::INTEGER_CENTER
  )
end

def int_tree
  IntervalTree::Tree(Int32).new(
    ([] of IntervalTree::Interval(Int32)),
    ->(a : Int32, b : Int32) { IntervalTree::Interval.new(a, b) },
    IntervalTree::INTEGER_CENTER
  )
end


def test_tree
  int_tree(
      10...14,
      2...20,
      0...5,
      0...8,
      3...6,
      15...20,
      16...21,
      17...25,
      21...24,
  )
end

def inclusive_ranges_to_exclusive(*ranges : Range(Int, Int))
  ranges.map do |r|
    if r.exclusive?
      r
    else
      r.begin...(r.end + 1)
    end
  end
end


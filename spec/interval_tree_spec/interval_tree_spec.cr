require "../spec_helper"

def int_tree(*ranges : Range(Int32, Int32))
  IntervalTree::Tree(Int32).new(
    ranges
  )
end

def int_tree
  IntervalTree::Tree(Int32).new(([] of Range(Int32, Int32)))
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

describe "integer usage example" do
  it "runs" do
    tree = IntervalTree::Tree(Int32).new([(1...3), (4...5)])
    tree.search((1..4))
  end
end

describe "time usage example" do
  it "runs" do
    now = Time.utc
    calculate_center = ->(intervals : Enumerable(IntervalTree::Interval(Time))) {
      min = intervals.map(&.begin).min
      min + (intervals.map(&.end).max - min) / 2
    }

    tree = IntervalTree::Tree(Time).new(
      [
        (now...(now + 1.day)),
        (now + 1.day)...(now + 2.days),
      ],
      calculate_center
    )

    tree.search(now) # => [Interval.new(now, now + 1.day, exclusive = true)]
  end
end

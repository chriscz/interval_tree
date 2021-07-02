require "../spec_helper"


def int_tree(*ranges : Range(Int32, Int32))
  IntervalTree::Tree(Int32).new(
    ranges
  )
end

def int_tree
  IntervalTree::Tree(Int32).new(([] of Range(Int32, Int32)),)
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

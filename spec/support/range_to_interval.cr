require "../../src/interval_tree"
struct Range
  def to_interval
    IntervalTree::Interval.new(self.begin, self.end, self.exclusive?)
  end
end


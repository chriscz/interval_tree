module IntervalTree
  module Centering(T)
    # Centering function used for integers, currently uses
    # TODO test tree behaviour when using round half even
    def self.integer(rounding_mode = Number::RoundingMode::TIES_AWAY)
      return ->(intervals : Enumerable(Interval(T))) { ((
        intervals.map(&.begin).min +
          intervals.map(&.end).max
      ) / 2).round(mode = rounding_mode).to_i }
    end
  end
end

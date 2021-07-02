require "../spec_helper"

describe IntervalTree::Interval do
  describe ".from_range" do
    context "given (1..2)" do
      it "returns the closed Interval(1, 2)" do
        IntervalTree::Interval(Int32).from_range((1..2)).should eq(IntervalTree::Interval(Int32).new(1, 2, false))
      end
    end

    context "given (1...2)" do
      it "returns the open Interval(1, 2)" do
        IntervalTree::Interval(Int32).from_range((1...2)).should eq(IntervalTree::Interval(Int32).new(1, 2, true))
      end
    end
  end

  describe "==" do
    context "same values" do
      it "should be true" do
        x = IntervalTree::Interval(Int32).new(20, 30, true)
        y = IntervalTree::Interval(Int32).new(20, 30, true)

        x.should eq(y)
      end
    end

    context "different values" do
      it "should be false if values differ" do
        x = IntervalTree::Interval(Int32).new(20, 30, true)
        y = IntervalTree::Interval(Int32).new(20, 31, true)

        x.should_not eq(y)
      end
    end
  end
end

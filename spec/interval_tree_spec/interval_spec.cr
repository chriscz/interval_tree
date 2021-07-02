require "../spec_helper"

describe IntervalTree::Interval do
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

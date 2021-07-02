require "../spec_helper"

describe IntervalTree::Node do
  describe ".new" do
    context "given (0, [])" do
      it "returns a Node object" do
        x = [] of IntervalTree::Interval(Int32)
        IntervalTree::Node(Int32).new(
          0,
          x,
        ).should be_a IntervalTree::Node(Int32)
      end
    end
  end
end

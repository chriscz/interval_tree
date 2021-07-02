require "../spec_helper"

describe IntervalTree::Node do
  describe ".new" do
    context "given (0, [], nil, nil)" do
      it "returns a Node object" do
        x = [] of IntervalTree::Interval(Int32)
        IntervalTree::Node(Int32).new(
          0,
          x,
          IntervalTree::Node::Null(Int32).new,
          IntervalTree::Node::Null(Int32).new,
        ).should be_a IntervalTree::Node(Int32)
      end
    end
  end
end

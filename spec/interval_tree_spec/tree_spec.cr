require "../spec_helper"

LARGE_EXAMPLE = {
  10...14,
  2...20,
  0...5,
  0...8,
  3...6,
  15...20,
  16...21,
  17...25,
  21...24,
}

EMPTY_INTERVALS = [] of IntervalTree::Interval(Int32)

describe IntervalTree::Tree do
  context "given []" do
    tree = int_tree
    describe "#center" do
      it "raises an error" do
        expect_raises(IntervalTree::Error, /empty/) do
          tree.center
        end
      end
    end

    describe "#search" do
      context "given 5" do
        it "returns []" do
          tree.search(5).should eq(EMPTY_INTERVALS)
        end
      end

      context "given (1..2)" do
        it "returns []" do
          tree.search((1..2)).should eq(EMPTY_INTERVALS)
        end
      end

      context "given (1...2)" do
        it "returns []" do
          tree.search((1...2)).should eq(EMPTY_INTERVALS)
        end
      end
    end
  end

  context "given [(1...5)]" do
    tree = int_tree(1...5)

    describe "#center" do
      it "returns 3" do
        tree.center.should eq(3)
      end
    end

    describe "#search" do
      context "given 3" do
        it "returns [(1...5)]" do
          tree.search(3).should ieq([(1...5)])
        end
      end

      context "given 5 (right corner case)" do
        it "returns []" do
          tree.search(5).should eq(EMPTY_INTERVALS)
        end
      end

      context "given 1 (left corner case)" do
        it "returns [(1...5)]" do
          tree.search(1).should ieq([(1...5)])
        end
      end
    end
  end

  context "given [(1...5), (2...6)]" do
    ranges = {(1...5), (2...6)}
    tree = int_tree(*ranges)
    describe "#center" do
      it "returns 4" do
        tree.center.should eq(4)
      end
    end

    describe "#search" do
      context "given 3" do
        it "returns all intervals" do
          tree.search(3).should ieq(ranges)
        end
      end
    end
  end

  context "given [(1...5), (2...6), (3...7)]" do
    tree = int_tree((1...5), (2...6), (3...7))
    describe "#center" do
      it "returns 4" do
        tree.center.should eq(4)
      end
    end
  end

  context "given [(1..5), (2..6), (3..7)]" do
    tree = int_tree(
      *inclusive_ranges_to_exclusive(
        (1..5),
        (2..6),
        (3..7)
      )
    )
    describe "#center" do
      it "returns 5" do
        tree.center.should eq(5)
      end
    end
  end

  context "given [(0...8), (1...5), (2...6)]" do
    ranges = {(0...8), (1...5), (2...6)}

    tree = int_tree(*ranges)

    describe "#search" do
      context "given 3" do
        it "returns all intervals" do
          tree.search(3).should ieq(ranges)
        end
      end

      context "given (1...4)" do
        it "returns all intervals" do
          tree.search((1...4)).should ieq(ranges)
        end
      end
    end
  end

  context "given [(1...3), (3...5), (4...8)] " do
    ranges = {(1...3), (3...5), (4...8)}
    all_intervals = ranges.to_intervals.to_a

    tree = int_tree(*ranges)

    describe "#search" do
      context "given (3...5)" do
        it "returns [(3...5), (4...8)]" do
          tree.search((3...5)).should ieq([(3...5), (4...8)])
        end
      end
    end
  end

  context "given [(1...3), (3...5), (3...9), (4...8)] " do
    ranges = {(1...3), (3...5), (3...9), (4...8)}
    all_intervals = ranges.to_intervals.to_a

    tree = int_tree(*ranges)

    describe "#search" do
      context "given (3...5)" do
        it "returns [(3...5), (3...9), (4...8)]" do
          tree.search((3...5)).should ieq([(3...5), (3...9), (4...8)])
        end
      end
    end
  end

  context "given [(1...3), (3...5)] " do
    ranges = {(1...3), (3...5)}

    tree = int_tree(*ranges)

    describe "#search" do
      context "given (3...9)" do
        it "returns [(3...5)]" do
          tree.search((3...5)).should ieq([(3...5)])
        end
      end
    end
  end

  context "given [(5...9)] " do
    ranges = {(5...9)}

    tree = int_tree(*ranges)

    describe "#search" do
      context "given (1...2)" do
        it "returns []" do
          tree.search((1...2)).should eq(EMPTY_INTERVALS)
        end
      end

      context "given (1...5)" do
        it "returns []" do
          tree.search((1...5)).should eq(EMPTY_INTERVALS)
        end
      end

      context "given (1...6)" do
        it "returns [(5...9)]" do
          tree.search((1...6)).should ieq([(5...9)])
        end
      end

      context "given (6...8)" do
        it "returns [(5...9)]" do
          tree.search((6...8)).should ieq([(5...9)])
        end
      end

      context "given (8...10)" do
        it "returns [(5...9)]" do
          tree.search((8...10)).should ieq([(5...9)])
        end
      end

      context "given (9...10)" do
        it "returns []" do
          tree.search((9...10)).should eq(EMPTY_INTERVALS)
        end
      end

      context "given (10...11)" do
        it "returns []" do
          tree.search((9...10)).should eq(EMPTY_INTERVALS)
        end
      end
    end
  end

  context "given #{LARGE_EXAMPLE.inspect}" do
    tree = int_tree(*LARGE_EXAMPLE)

    describe "#search" do
      context "given (-5...3)" do
        it "returns [(2...20), (0...5), (0...8)]" do
          tree.search((-5...3).to_interval).should ieq(
            [
              2...20,
              0...5,
              0...8,
            ]
          )
        end
      end
    end

    describe "dividing intervals" do
      left_node = IntervalTree::Node(Int32).new(
        4,
        [0...5, 0...8, 3...6].to_intervals,
      )

      right_right_node = IntervalTree::Node.new(
        23,
        [21...24].to_intervals
      )

      right_node = IntervalTree::Node(Int32).new(
        20,
        [15...20, 16...21, 17...25].to_intervals,
        right: right_right_node,
      )

      root_node = IntervalTree::Node(Int32).new(
        13,
        [10...14, 2...20].to_intervals,
        left_node,
        right_node
      )

      it "calculates root node correctly" do
        tree.root.should eq(root_node)
      end

      it "calculates the left node correctly" do
        tree.root.left.should eq(left_node)
      end

      it "calculates the right node correctly" do
        tree.root.right.should eq(right_node)
      end

      it "calculates the right right node correctly" do
        tree.root.right.right.should eq(right_right_node)
      end
    end
  end
end

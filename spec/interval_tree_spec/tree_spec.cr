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
          tree.search((1..2).to_interval).should eq(EMPTY_INTERVALS)
        end
      end

      context "given (1...2)" do
        it "returns []" do
          tree.search((1...2).to_interval).should eq(EMPTY_INTERVALS)
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
          tree.search(3).should eq([(1...5).to_interval])
        end
      end

      context "given 5 (right corner case)" do
        it "returns []" do
          tree.search(5).should eq(EMPTY_INTERVALS)
        end
      end

      context "given 1 (left corner case)" do
        it "returns [(1...5)]" do
          tree.search(1).should eq([(1...5).to_interval])
        end
      end
    end
  end

  context "given [(1...5), (2...6)]" do
    intervals = {(1...5), (2...6)}
    tree = int_tree(*intervals)
    describe "#center" do
      it "returns 4" do
        tree.center.should eq(4)
      end
    end

    describe "#search" do
      context "given 3" do
        it "returns all intervals" do
          tree.search(3).should eq(intervals.map(&.to_interval).to_a)
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
    intervals = {(0...8), (1...5), (2...6)}
    all_intervals = intervals.map(&.to_interval).to_a

    tree = int_tree(*intervals)

    describe "#search" do
      context "given 3" do
        it "returns all intervals" do
          tree.search(3).should eq(all_intervals)
        end
      end

      context "given (1...4)" do
        it "returns all intervals" do
          tree.search((1...4).to_interval).should eq(all_intervals)
        end
      end
    end
  end

  context "given [(1...3), (3...5), (4...8)] " do
    intervals = {(1...3), (3...5), (4...8)}
    all_intervals = intervals.map(&.to_interval).to_a

    tree = int_tree(*intervals)

    describe "#search" do
      context "given (3...5)" do
        it "returns [(3...5), (4...8)]" do
          tree.search((3...5).to_interval).should eq(
            [(3...5), (4...8)].map(&.to_interval)
          )
        end
      end
    end
  end

  context "given [(1...3), (3...5), (3...9), (4...8)] " do
    intervals = {(1...3), (3...5), (3...9), (4...8)}
    all_intervals = intervals.map(&.to_interval).to_a

    tree = int_tree(*intervals)

    describe "#search" do
      context "given (3...5)" do
        it "returns [(3...5), (3...9), (4...8)]" do
          tree.search((3...5).to_interval).should eq(
            [(3...5), (3...9), (4...8)].map(&.to_interval)
          )
        end
      end
    end
  end

  context "given [(1...3), (3...5)] " do
    intervals = {(1...3), (3...5)}
    all_intervals = intervals.map(&.to_interval).to_a

    tree = int_tree(*intervals)

    describe "#search" do
      context "given (3...9)" do
        it "returns [(3...5)]" do
          tree.search((3...5).to_interval).should eq(
            [(3...5)].map(&.to_interval)
          )
        end
      end
    end
  end

  context "given #{LARGE_EXAMPLE.inspect}" do
    tree = int_tree(*LARGE_EXAMPLE)

    describe "#search" do
      context "given (-5...3)" do
        it "returns [(2...20), (0...5), (0...8)]" do
          tree.search((-5...3).to_interval).should eq(
            [
              2...20,
              0...5,
              0...8,
            ].map(&.to_interval)
          )
        end
      end
    end

    describe "dividing intervals" do
      left_node = IntervalTree::Node(Int32).new(
        4,
        [0...5, 0...8, 3...6].map(&.to_interval),
      )

      right_right_node = IntervalTree::Node.new(
        23,
        [21...24].map(&.to_interval)
      )

      right_node = IntervalTree::Node(Int32).new(
        20,
        [15...20, 16...21, 17...25].map(&.to_interval),
        right: right_right_node,
      )

      root_node = IntervalTree::Node(Int32).new(
        13,
        [10...14, 2...20].map(&.to_interval),
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

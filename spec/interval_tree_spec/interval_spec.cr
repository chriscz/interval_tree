require "../spec_helper"

describe IntervalTree::Interval do
  describe ".from" do
    context "given (1..2)" do
      it "returns the closed Interval(1, 2)" do
        IntervalTree::Interval(Int32).from((1..2)).should eq(IntervalTree::Interval(Int32).new(1, 2, false))
      end
    end

    context "given (1...2)" do
      it "returns the open Interval(1, 2)" do
        IntervalTree::Interval(Int32).from((1...2)).should eq(IntervalTree::Interval(Int32).new(1, 2, true))
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

    describe "#overlap?" do
      context "given (1...2) and (2..3)" do
        it "should return false" do
          (1...2).to_interval.overlap?((2..3)).should eq(false)
        end
      end

      context "given (1..2) and (2..3)" do
        it "should return false" do
          (1..2).to_interval.overlap?((2..3)).should eq(true)
        end
      end

      context "given (1..2) and (3..4)" do
        it "should return false" do
          (1..2).to_interval.overlap?((3..4)).should eq(false)
        end
      end

      context "given (1..10) and (3..4)" do
        it "should return true" do
          (1..10).to_interval.overlap?((3..4)).should eq(true)
        end
      end

      context "given (1...2) and (1...2)" do
        it "should return true" do
          (1...2).to_interval.overlap?((1...2)).should eq(true)
        end
      end

      context "given (1..2) and (1..2)" do
        it "should return true" do
          (1..2).to_interval.overlap?((1..2)).should eq(true)
        end
      end
    end
  end
end

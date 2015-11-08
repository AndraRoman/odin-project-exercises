require "bubble_sort"

describe "pass!" do
  it "handles sorted array" do
    array = [1, 2, 3, 4, 5]
    finished = pass!(array)
    expect(array).to eq(array)
    expect(finished).to be(true)
  end

  it "handles unsorted array" do
    array = [1, 0, 4, 2, 5, 1]
    finished = pass!(array)
    expect(array).to eq([0, 1, 2, 4, 1, 5])
    expect(finished).to be(false)
  end
end

describe "bubble_sort" do
  it "sorts an array" do
    array = [1, 0, 4, 2, 5, 1]
    sorted = bubble_sort(array)
    expect(sorted).to eq([0, 1, 1, 2, 4, 5])
  end
end

describe "bubble_sort_by" do
  it "works" do
    array = [1, 0, 4, 2, 5, 1]
    sorted = bubble_sort_by(array) { |x, y|
      if x < y
        result = 1
      elsif x == y
        result = 0
      else
        result = -1
      end
    }
    expect(sorted).to eq([5, 4, 2, 1, 1, 0])
  end
end

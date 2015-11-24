require 'knights_travails'

describe "in_bounds" do
  it "returns true if all elements in an array are in the range (0...8)" do
    expect(in_bounds([0, 1, 2, 3, 7])).to be(true)
    expect(in_bounds([])).to be(true)
  end

  it "returns false otherwise" do
    expect(in_bounds([-1, 3])).to be(false)
    expect(in_bounds([5, 8])).to be(false)
  end
end

describe "possible_moves" do
  it "returns all 8 moves from a point where none go out bounds" do
    result = [[6, 4], [6, 2], [5, 5], [5, 1], [3, 5], [3, 1], [2, 4], [2, 2]]
    expect(array_equiv?(possible_moves([4, 3]), result)).to be(true)
  end

  it "filters out out-of-bounds moves when applicable" do
    expect(array_equiv?(possible_moves([0, 0]), [[2, 1], [1, 2]])).to be(true)
  end
end

describe "propagate_tree" do
  it "" do
    node = MoveTree.new([4, 3])
    propagate_tree(node)
    child_coords = node.children.map { |c| c.point }
    expect(array_equiv?(child_coords, possible_moves([4, 3]))).to be(true)
  end
end

describe "get_path" do
  it "returns sequence of points from root to current node" do
    tree = MoveTree.new([1, 1])
    a = MoveTree.new([2, 2])
    b = MoveTree.new([3, 3])
    c = MoveTree.new([4, 4])
    d = MoveTree.new([5, 5])
    b.add_child(d)
    [b, a, c].each { |i| tree.add_child(i) }
    path = get_path(d)
    result = [[1, 1], [3, 3], [5, 5]]
    expect(array_equiv?(path, result)).to be(true)
  end
end

describe "knight_moves" do
  it "works on two sample cases" do
    expect(array_equiv?(knight_moves([0,0],[1,2]), [[0,0],[1,2]])).to be(true)
    expect(array_equiv?(knight_moves([3,3],[0,0]), [[3,3],[2, 1],[0,0]])).to be(true)
  end
end

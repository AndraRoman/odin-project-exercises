require 'binary_search_trees'

describe "rotate_left" do
  it "rotates a tree counterclockwise" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    rotated = tree.rotate_left
    expect(rotated.value).to be(6)
    expect(rotated.right_child.value).to be(7)
    expect(rotated.left_child.value).to be(4)
    expect(rotated.left_child.right_child.value).to be(5)
  end
end

describe "rotate_right" do
  it "rotates a tree clockwise" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    rotated = tree.rotate_right
    expect(rotated.value).to be(2)
    expect(rotated.right_child.value).to be(4)
    expect(rotated.left_child.value).to be(1)
    expect(rotated.right_child.left_child.value).to be(3)
  end
end

describe "insert" do
  it "inserts new node when root has no subtree on that side" do
    tree = Node.new(3)
    tree.insert(1)
    tree.insert(4)
    expect(tree.left_child.value).to be(1)
    expect(tree.right_child.value).to be(4)
  end

  it "inserts new node when root does have a subtree on that side" do
    tree = build_tree_from_sorted([2, 4, 6, 8, 10, 12, 14])
    tree.insert(9)
    tree.insert(3)
    expect(tree.right_child.left_child.left_child.value).to be(9)
    expect(tree.left_child.left_child.right_child.value).to be(3)
  end
end

describe "build_tree_from_sorted" do
  it "builds a balanced binary search tree from a sorted array" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    expect(tree.value).to be(4)
    expect(tree.left_child.value).to be(2)
    expect(tree.left_child.right_child.value).to be(3)
    expect(tree.right_child.right_child.value).to be(7)
    expect(tree.right_child.right_child.right_child).to be(nil)
  end
end

describe "build_tree" do
  it "builds a balanced binary search tree from a sorted array" do
    tree = build_tree([6, 7, 4, 5, 2, 3, 1]) # should be identical to tree created in test of rotate_left
    expect(tree.value).to be(6)
    expect(tree.right_child.value).to be(7)
    expect(tree.left_child.value).to be(4)
    expect(tree.left_child.right_child.value).to be(5)
  end
end



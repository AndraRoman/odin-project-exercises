require 'binary_search_trees'

describe "add_left_child" do
  it "adds (or replaces) a left child with correct parent" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    tree.add_left_child(Node.new(0))
    expect(tree.left_child.value).to be(0)
    expect(tree.left_child.parent.value).to be(3)
  end

  it "does not throw exception if child is nil" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    tree.add_left_child(nil)
    expect(tree.left_child).to be(nil)
  end
end

describe "add_right_child" do
  it "adds (or replaces) a left child with correct parent" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    tree.add_right_child(Node.new(10))
    expect(tree.right_child.value).to be(10)
    expect(tree.right_child.parent.value).to be(3)
  end

  it "does not throw exception if child is nil" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    tree.add_right_child(nil)
    expect(tree.right_child).to be(nil)
  end
end

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

  it "inserted node has correct parent" do
    tree = build_tree_from_sorted([2, 4, 6, 8, 10, 12, 14])
    tree.insert(9)
    tree.insert(3)
    expect(binary_search(tree, 3).value).to be(3)
    expect(binary_search(tree, 3).parent.value).to be(2)
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

  it "ensures nodes have correct parents" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    expect(tree.parent).to be(nil)
    expect(tree.left_child.parent.value).to be(4)
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

describe "binary_search" do
  it "returns node with a target value if present in tree" do
    tree = Node.new(5)
    tree.insert(3)
    tree.insert(7)
    tree.insert(1)
    tree.insert(2)
    expect(binary_search(tree, 5)).to be(tree)
    expect(binary_search(tree, 1)).to be(tree.left_child.left_child)
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(binary_search(tree, 5)).to be(nil)
  end
end

describe "depth_first_search" do
  it "returns node with a target value if present in tree" do
    tree = Node.new(5)
    tree.insert(3)
    tree.insert(7)
    tree.insert(1)
    tree.insert(2)
    expect(depth_first_search(tree, 5)).to be(tree)
    expect(depth_first_search(tree, 3)).to be(tree.left_child)
    expect(depth_first_search(tree, 1)).to be(tree.left_child.left_child)
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(depth_first_search(tree, 5)).to be(nil)
  end
end

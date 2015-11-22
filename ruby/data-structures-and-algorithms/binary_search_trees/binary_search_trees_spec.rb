require 'binary_search_trees'

# Binary search tree

describe "initialize tree" do
  it "creates a new tree with given value and no parent or children" do
    tree = Node.new(0)
    expect(tree.value).to be(0)
    expect(tree.parent).to be(nil)
    expect(tree.left_child).to be(nil)
    expect(tree.right_child).to be(nil)
  end
end

describe "minimal_copy" do
  it "creates a new tree with same value as self but no parents or children" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    copy = binary_search(tree, 2).minimal_copy
    expect(copy.equiv?(Node.new(2))).to be(true)
    expect(copy.parent).to be(nil)
  end
end

describe "remove_from_parent" do
  it "removes node from parent's children" do
    tree = build_tree([1, 2])
    child = tree.right_child
    child.remove_from_parent
    expect(tree.equiv?(Node.new(1))).to be(true)
  end

  it "does not affect node's @parent value" do
    tree = build_tree([1, 2])
    child = tree.right_child
    child.remove_from_parent
    expect(child.parent).to be(tree)
  end
end

describe "add_left_child" do
  it "adds (or replaces) a left child with correct parent" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    tree.add_left_child(Node.new(0))
    expect(tree.left_child.value).to be(0)
    expect(tree.left_child.parent.value).to be(3)
  end

  it "does nothing if child is nil" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    tree.add_left_child(nil)
    expect(tree.left_child).to be(nil)
  end

  it "removes child from its original parent" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    child = tree.left_child
    new_tree = Node.new(10)
    new_tree.add_left_child(child)
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

  it "does nothing if child is nil" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    tree.add_right_child(nil)
    expect(tree.right_child).to be(nil)
  end

  it "removes child from its original parent" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    child = tree.right_child
    new_tree = Node.new(0)
    new_tree.add_right_child(child)
    expect(tree.right_child).to be(nil)
  end
end

describe "add_child" do
  it "adds child on appropriate side" do
    tree = Node.new(3)
    child = Node.new(4)
    tree.add_child(child)
    expect(tree.right_child).to be(child)

    new_child = Node.new(2)
    tree.add_child(new_child)
    expect(tree.left_child).to be(new_child)
  end

  it "does nothing if child's value is equal to parent's" do
    tree = Node.new(3)
    child = Node.new(3)
    tree.add_child(child)
    expect(tree.right_child).to be(nil)
  end
end

describe "uncle" do
  it "returns nil for root node" do
    tree = Node.new(3)
    expect(tree.uncle).to be(nil)
  end

  it "returns nil for child of root node" do
    tree = Node.new(3)
    tree.insert(2)
    expect(tree.left_child.uncle).to be(nil)
  end

  it "returns nil when grandfather has only one child" do
    tree = build_tree([3, 4, 5, 6, 2, 1, 0])
    expect(binary_search(tree, 0).uncle).to be(nil)
  end

  it "returns uncle node when uncle exists" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    expect(tree.left_child.left_child.uncle).to be(binary_search(tree, 6))
  end
end

describe "size" do
  it "gives the size of a tree" do
    tree = build_tree_from_sorted([1, 2])
    expect(tree.size).to be(2)
    tree = build_tree_from_sorted([1, 2, 3, 4, 5])
    expect(tree.size).to be(5)
    expect(tree.left_child.size).to be(2)
    expect(tree.left_child.left_child.size).to be(1)
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

  it "returns nil when value is already in tree" do
    tree = Node.new(3)
    expect(tree.insert(3)).to be(nil)
  end
end

describe "equiv?" do
  it "returns true for equivalent trees" do
    a = build_explicit_tree([3, [2, [0], []], [4]])
    expect(a.equiv?(a)).to be(true)
  end

  it "returns false for trees with different structures" do
    a = build_explicit_tree([3, [2, [0], []], [4]])
    b = build_explicit_tree([3, [2, [0], [1]], [4]])
    expect(a.equiv?(b)).to be(false)
    expect(b.equiv?(a)).to be(false)
  end

  it "returns false for trees with different values" do
    a = build_explicit_tree([3, [2, [0], []], [4]])
    b = build_explicit_tree([3, [2, [0], []], [5]])
    expect(a.equiv?(b)).to be(false)
    expect(b.equiv?(a)).to be(false)
  end
end

describe "rotate_left" do
  it "rotates a tree counterclockwise" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    tree = tree.rotate_left
    expect(tree.parent).to be(nil)
    expect(tree.equiv?(build_explicit_tree([6, [4, [2, [1], [3]], [5]], [7]])))
  end

  it "rotated subtree is pasted properly back into parent tree" do
    tree = build_tree_from_sorted([0, 1, 3, 4, 5, 6, 7])
    rotated = tree.left_child.rotate_left
    expect(rotated.parent).to be(tree)
    expect(tree.left_child.equiv?(rotated)).to be(true)
    expect(tree.left_child).to be(rotated)
  end

  it "works on case where tree is rotated from root" do
    tree = build_tree_from_sorted([1, 2, 3])
    rotated = tree.rotate_left
    expect(tree).to be(rotated)
    expect(tree.equiv?(build_explicit_tree([3, [2, [1], []], []]))).to be(true)
  end

  it "returns false when rotation is impossible" do
    tree = build_explicit_tree([1, [2, [3], []], []])
    expect(tree.rotate_left).to be(false)
  end
end

describe "rotate_right" do
  it "rotates a tree clockwise" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    tree = tree.rotate_right
    expect(tree.parent).to be(nil)
    expect(tree.equiv?(build_explicit_tree([2, [1], [4, [3], [6, [5], [7]]]])))
  end

  it "rotated subtree is pasted properly back into parent tree" do
    tree = build_tree_from_sorted([0, 1, 3, 4, 5, 6, 7])
    rotated = tree.left_child.rotate_right
    expect(rotated.parent).to be(tree)
    expect(tree.left_child).to be(rotated)
  end

  it "returns false when rotation is impossible" do
    tree = build_explicit_tree([1, [], [2, [], [3]]])
    expect(tree.rotate_right).to be(false)
  end
end

# Tree-building functions

describe "build_tree_from_sorted" do
  it "builds a balanced binary search tree from a sorted array" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    result = build_explicit_tree([4, [2, [1], [3]], [6, [5], [7]]])
    expect(tree.equiv?(result)).to be(true)
  end

  it "ensures nodes have correct parents" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    expect(tree.parent).to be(nil)
    expect(tree.left_child.parent.value).to be(4)
  end
end

describe "build_explicit_tree" do
  it "builds a tree with specified structure" do
    array = [5, [3, [], [1, [], []]], []]
    tree = build_explicit_tree(array)
    expect(tree.size).to be(3)
    expect(tree.value).to be(5)
    expect(tree.left_child.value).to be(3)
    expect(tree.left_child.left_child).to be(nil)
    expect(tree.left_child.right_child.value).to be(1)
    expect(tree.right_child).to be(nil)
  end
end

describe "build_tree" do
  it "builds a binary search tree from an array" do
    tree = build_tree([6, 7, 4, 5, 2, 3, 1])
    result = build_explicit_tree([6, [4, [2, [1], [3]], [5]], [7]])
    expect(tree.equiv?(result)).to be(true)
  end
end

# Search functions

describe "binary_search" do
  it "returns node with a target value if present in tree" do
    tree = build_tree([5, 3, 7, 1, 2])
    expect(binary_search(tree, 5)).to be(tree)
    expect(binary_search(tree, 3)).to be(tree.left_child)
    expect(binary_search(tree, 1)).to be(tree.left_child.left_child)
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(binary_search(tree, 5)).to be(nil)

    tree = nil
    expect(binary_search(tree, 5)).to be(nil)
  end
end

describe "breadth_first_search" do
  it "returns node with a target value if present in tree" do
    tree = build_tree([5, 3, 7, 1, 2])
    expect(breadth_first_search(tree, 5)).to be(binary_search(tree, 5))
    expect(breadth_first_search(tree, 3)).to be(binary_search(tree, 3))
    expect(breadth_first_search(tree, 1)).to be(binary_search(tree, 1))
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(breadth_first_search(tree, 5)).to be(nil)

    tree = nil
    expect(breadth_first_search(tree, 5)).to be(nil)
  end
end

describe "depth_first_search" do
  it "returns node with a target value if present in tree" do
    tree = build_tree([5, 3, 7, 1, 2])
    expect(depth_first_search(tree, 5)).to be(binary_search(tree, 5))
    expect(depth_first_search(tree, 3)).to be(binary_search(tree, 3))
    expect(depth_first_search(tree, 1)).to be(binary_search(tree, 1))
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(depth_first_search(tree, 5)).to be(nil)

    tree = nil
    expect(depth_first_search(tree, 5)).to be(nil)
  end
end

describe "recursive depth-first search" do
  it "returns node with a target value if present in tree" do
    tree = build_tree([5, 3, 7, 1, 2])
    expect(dfs_rec(tree, 5)).to be(binary_search(tree, 5))
    expect(dfs_rec(tree, 3)).to be(binary_search(tree, 3))
    expect(dfs_rec(tree, 1)).to be(binary_search(tree, 1))
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(dfs_rec(tree, 5)).to be(nil)
  end
end

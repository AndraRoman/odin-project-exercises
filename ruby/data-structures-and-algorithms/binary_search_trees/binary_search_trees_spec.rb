require 'binary_search_trees'
require 'red_black_trees'

# Binary search tree

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

describe "rotate_left!" do
  it "rotates a tree counterclockwise" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    tree.rotate_left!
    expect(tree.parent).to be(nil)
    expect(tree.value).to be(6)
    expect(tree.right_child.value).to be(7)
    expect(tree.left_child.value).to be(4)
    expect(tree.left_child.right_child.value).to be(5)
  end

  it "gives rotated tree as return value" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    rotated = tree.rotate_left!
    expect(rotated).to be(tree)

    rotated = tree.left_child.rotate_left!
    expect(rotated).to be(tree.left_child)
  end

  it "keeps correct relationship to parent" do
    tree = build_tree_from_sorted([0, 1, 3, 4, 5, 6, 7])
    tree.insert(2) # left child of 3
    left = tree.left_child.rotate_left!
    expect(tree.left_child).to be(left)
    expect(left.parent).to be(tree)
  end
end

describe "rotate_right!" do
  it "rotates a tree clockwise" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    tree.rotate_right!
    expect(tree.parent).to be(nil)
    expect(tree.value).to be(2)
    expect(tree.right_child.value).to be(4)
    expect(tree.left_child.value).to be(1)
    expect(tree.right_child.left_child.value).to be(3)
  end

  it "gives rotated tree as return value" do
    tree = build_tree_from_sorted([1, 2, 3, 4, 5, 6, 7])
    rotated = tree.rotate_right!
    expect(rotated).to be(tree)

    rotated = tree.left_child.rotate_right!
    expect(rotated).to be(tree.left_child)
  end

  it "keeps correct relationship to parent" do
    tree = build_tree_from_sorted([0, 2, 3, 4, 5, 6, 7])
    tree.insert(1) # right child of 0
    left = tree.left_child.rotate_right!
    expect(tree.left_child).to be(left)
    expect(left.parent).to be(tree)
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

# Misc methods

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
  it "builds a binary search tree from an array" do
    tree = build_tree([6, 7, 4, 5, 2, 3, 1])
    expect(tree.value).to be(6)
    expect(tree.right_child.value).to be(7)
    expect(tree.left_child.value).to be(4)
    expect(tree.left_child.right_child.value).to be(5)
  end
end

describe "binary_search" do
  it "returns node with a target value if present in tree" do
    tree = build_tree([5, 3, 7, 1, 2])
    expect(binary_search(tree, 5)).to be(tree)
    expect(binary_search(tree, 1)).to be(tree.left_child.left_child)
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(binary_search(tree, 5)).to be(nil)
  end
end

describe "breadth_first_search" do
  it "returns node with a target value if present in tree" do
    tree = build_tree([5, 3, 7, 1, 2])
    expect(breadth_first_search(tree, 5)).to be(tree)
    expect(breadth_first_search(tree, 3)).to be(tree.left_child)
    expect(breadth_first_search(tree, 1)).to be(tree.left_child.left_child)
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(breadth_first_search(tree, 5)).to be(nil)
  end
end

describe "depth_first_search" do
  it "returns node with a target value if present in tree" do
    tree = build_tree([5, 3, 7, 1, 2])
    expect(depth_first_search(tree, 5)).to be(tree)
    expect(depth_first_search(tree, 3)).to be(tree.left_child)
    expect(depth_first_search(tree, 1)).to be(tree.left_child.left_child)
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(depth_first_search(tree, 5)).to be(nil)
  end
end

describe "recursive depth-first search" do
  it "returns node with a target value if present in tree" do
    tree = build_tree([5, 3, 7, 1, 2])
    expect(dfs_rec(tree, 5)).to be(tree)
    expect(dfs_rec(tree, 3)).to be(tree.left_child)
    expect(dfs_rec(tree, 1)).to be(tree.left_child.left_child)
  end

  it "returns nil otherwise" do
    tree = Node.new(1)
    expect(dfs_rec(tree, 5)).to be(nil)
  end
end

# Red-black tree

describe "initialize red-black tree" do
  it "creates a black node" do
    tree = RedBlackNode.new(3)
    expect(tree.value).to be(3)
    expect(tree.color).to be(:black)
  end
end

describe "balance a red-black tree" do
  it "changes color to black when parent is nil" do
    tree = RedBlackNode.new(3)
    tree.color = :red
    tree.balance!
    expect(tree.color).to be(:black)
  end

  it "does nothing when parent is black" do
    tree = RedBlackNode.new(1)
    tree.rb_insert(0)
    expect(binary_search(tree, 0).color).to be(:red)
  end

  xit "handles case where parent and uncle are red" do
    tree = build_rb_tree([0, 6, 7])
    node = RedBlackNode.new(4)
    node.color = :red
    tree.left_child.add_right_child(node)
    node.balance!
    expect(node.color).to be(:red)
    expect(tree.left_child.color).to be(:black) # was red before
    expect(tree.right_child.color).to be(:black) # was red before
  end

  it "handles case where parent is red, parent is in left subtree, and child is in right subtree" do
    # TODO
  end

  it "handles case where parent is red, parent is in right subtree, and child is in left subtree" do
    # TODO
  end

  it "handles case where parent is red, parent is in left subtree, and child is in left subtree" do
    # TODO
  end

  it "handles case where parent is red, parent is in right subtree, and child is in right subtree" do
    # TODO
  end
end

describe "balance_left_left!" do
  it "balances an otherwise balanced tree with a red left subtree of a red left subtree" do
    tree = RedBlackNode.new(3)
    a = RedBlackNode.new(2)
    tree.add_left_child(a)
    b = RedBlackNode.new(1)
    b.color = :red
    tree.left_child.add_left_child(b)
    c = RedBlackNode.new(0)
    c.color = :red
    tree.left_child.left_child.add_left_child(c)
    tree.left_child.left_child.left_child.balance_left_left!
    expect(tree.value).to be(3)
    expect(tree.color).to be(:black)
    expect(tree.left_child.value).to be(1)
    expect(tree.left_child.color).to be(:red)
    expect(tree.left_child.left_child.value).to be(0)
    expect(tree.left_child.left_child.color).to be(:black)
    expect(tree.left_child.right_child.value).to be(2)
    expect(tree.left_child.right_child.color).to be(:black)
  end
end

describe "balance_right_right!" do
  it "balances an otherwise balanced tree with a red right subtree of a red right subtree" do
    tree = RedBlackNode.new(0)
    a = RedBlackNode.new(1)
    tree.add_right_child(a)
    b = RedBlackNode.new(2)
    b.color = :red
    tree.right_child.add_right_child(b)
    c = RedBlackNode.new(3)
    c.color = :red
    tree.right_child.right_child.add_right_child(c)
    tree.right_child.right_child.right_child.balance_right_right!
    expect(tree.value).to be(0)
    expect(tree.color).to be(:black)
    expect(tree.right_child.value).to be(2)
    expect(tree.right_child.color).to be(:red)
    expect(tree.right_child.right_child.value).to be(3)
    expect(tree.right_child.right_child.color).to be(:black)
    expect(tree.right_child.left_child.value).to be(1)
    expect(tree.right_child.left_child.color).to be(:black)
  end
end

describe "balance_left_right!" do
  it "balances an otherwise balanced tree with a red right subtree of a red left subtree" do
    tree = RedBlackNode.new(3)
    a = RedBlackNode.new(2)
    tree.add_left_child(a)
    b = RedBlackNode.new(0)
    b.color = :red
    c = RedBlackNode.new(1)
    c.color = :red
    tree.left_child.add_left_child(b)
    tree.left_child.left_child.add_right_child(c)
    tree.left_child.left_child.right_child.balance_left_right!
    expect(tree.value).to be(3)
    expect(tree.color).to be(:black)
    expect(tree.left_child.value).to be(1)
    expect(tree.left_child.color).to be(:red)
    expect(tree.left_child.left_child.value).to be(0)
    expect(tree.left_child.left_child.color).to be(:black)
    expect(tree.left_child.right_child.value).to be(2)
    expect(tree.left_child.right_child.color).to be(:black)
  end
end

describe "balance_right_left!" do
  it "balances an otherwise balanced tree with a red left subtree of a red right subtree" do
    tree = RedBlackNode.new(0)
    a = RedBlackNode.new(1)
    tree.add_right_child(a)
    b = RedBlackNode.new(3)
    b.color = :red
    c = RedBlackNode.new(2)
    c.color = :red
    tree.right_child.add_right_child(b)
    tree.right_child.right_child.add_left_child(c)
    tree.right_child.right_child.left_child.balance_right_left!
    expect(tree.value).to be(0)
    expect(tree.color).to be(:black)
    expect(tree.right_child.value).to be(2)
    expect(tree.right_child.color).to be(:red)
    expect(tree.right_child.right_child.value).to be(3)
    expect(tree.right_child.right_child.color).to be(:black)
    expect(tree.right_child.left_child.value).to be(1)
    expect(tree.right_child.left_child.color).to be(:black)
  end
end



describe "build_rb_tree" do
  # TODO
end

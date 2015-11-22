require 'red_black_trees'

# Red-black tree

describe "initialize red-black tree" do
  it "creates a black node by default" do
    tree = RedBlackNode.new(3)
    expect(tree.value).to be(3)
    expect(tree.color).to be(:black)
  end

  it "creates node with specified color if given as argument" do
    tree = RedBlackNode.new(3, :red)
    expect(tree.value).to be(3)
    expect(tree.color).to be(:red)
  end
end

describe "minimal_copy for red-black tree" do
  it "creates a new tree with same value and color as self but no parents or children" do
    tree = build_rb_tree([1, 2, 3, 4, 5, 6, 7])
    copy = binary_search(tree, 4).minimal_copy
    expect(copy.equiv?(RedBlackNode.new(4, :red))).to be(true)
    expect(copy.parent).to be(nil)
  end
end

describe "insert in red-black tree" do
  it "balances after insertion" do
    tree = RedBlackNode.new(10)
    array = [11, 12, 13, 14, 15]
    array.each { |i| tree.insert(i) }
    expect(balanced?(tree)).to be(2)
  end

  it "does nothing, returns nil, if value already in tree" do
    tree = build_rb_tree([1, 2, 3])
    expect(tree.insert(3)).to be(nil)
    expect(tree.equiv?(build_rb_tree([1, 2, 3]))).to be(true)
  end
end

describe "equiv? for red-black tree" do
  it "returns true for equivalent trees" do
    a = build_explicit_rb_tree([3, :black, [2, :red, [0, :black], []], [4, :red]])
    expect(a.equiv?(a)).to be(true)
  end

  it "returns false for trees with different structures" do
    a = build_explicit_rb_tree([3, :black, [2, :red, [0, :black], []], [4, :red]])
    b = build_explicit_rb_tree([3, :black, [2, :red, [0, :black], [1, :black]], [4, :red]])
    expect(a.equiv?(b)).to be(false)
    expect(b.equiv?(a)).to be(false)
  end

  it "returns false for trees with different values" do
    a = build_explicit_rb_tree([3, :black, [2, :red, [0, :black], []], [4, :black]])
    b = build_explicit_rb_tree([3, :black, [2, :red, [0, :black], []], [4, :red]])
    expect(a.equiv?(b)).to be(false)
    expect(b.equiv?(a)).to be(false)
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
    tree.insert(0)
    expect(binary_search(tree, 0).color).to be(:red)
  end

  it "handles case where parent and uncle are red" do
    array = [7, :black, [5, :black, [3, :red, [], [4, :red]], [6, :red]], []]
    tree = build_explicit_rb_tree(array)
    result_array = [7, :black, [5, :red, [3, :black, [], [4, :red]], [6, :black]], []]
    result = build_explicit_rb_tree(result_array)
    binary_search(tree, 4).balance!
    expect(tree.equiv?(result)).to be(true)
  end

  it "handles case where parent is red, parent is in left subtree, and child is in right subtree" do
    array = [3, :black, [2, :black, [0, :red, [], [1, :red]], []], []]
    tree = build_explicit_rb_tree(array)
    result_array = [3, :black, [1, :black, [0, :red, [], []], [2, :red]], []]
    result = build_explicit_rb_tree(result_array) 
    tree.left_child.left_child.right_child.balance!
    expect(tree.equiv?(result)).to be(true)   
  end

  it "handles case where parent is red, parent is in right subtree, and child is in left subtree" do
    array = [0, :black, [], [1, :black, [], [3, :red, [2, :red], []]]]
    tree = build_explicit_rb_tree(array)
    result_array = [0, :black, [], [2, :black, [1, :red], [3, :red]]]
    result = build_explicit_rb_tree(result_array) 
    tree.right_child.right_child.left_child.balance!
    expect(tree.equiv?(result)).to be(true)   
  end

  it "handles case where parent is red, parent is in left subtree, and child is in left subtree" do
    array = [3, :black, [2, :black, [1, :red, [0, :red], []], []], []]
    tree = build_explicit_rb_tree(array)
    result_array = [3, :black, [1, :black, [0, :red], [2, :red]], []]
    result = build_explicit_rb_tree(result_array) 
    tree.left_child.left_child.left_child.balance!
    expect(tree.equiv?(result)).to be(true)   
  end

  it "handles case where parent is red, parent is in right subtree, and child is in right subtree" do
    array = [0, :black, [], [1, :black, [], [2, :red, [], [3, :red]]]]
    tree = build_explicit_rb_tree(array)
    result_array = [0, :black, [], [2, :red, [1, :black], [3, :black]]]
    result = build_explicit_rb_tree(result_array) 
    tree.right_child.right_child.right_child.balance!
  end

 it "generates a balanced tree from a random array" do
    srand(3333)
    array = Array.new(1000) { rand(100_000_000) }
    tree = build_rb_tree(array)
    expect(balanced?(tree)).to be(6)
  end

  it "generates another balanced tree from another random array" do
    srand(5)
    array = Array.new(2000) { rand(100_000_000) }
    tree = build_rb_tree(array)
    expect(balanced?(tree)).to be(7)
  end
end

describe "balance_red_uncle!" do
  it "balances an otherwise balanced tree where both parent and uncle of new node are red" do
    array = [7, :black, [5, :black, [3, :red, [], [4, :red]], [6, :red]], []]
    tree = build_explicit_rb_tree(array)
    result_array = [7, :black, [5, :red, [3, :black, [], [4, :red]], [6, :black]], []]
    result = build_explicit_rb_tree(result_array)
    binary_search(tree, 4).balance_red_uncle!
    expect(tree.equiv?(result)).to be(true)
  end
end

describe "balance_left_left!" do
  it "balances an otherwise balanced tree with a red left subtree of a red left subtree" do
    array = [3, :black, [2, :black, [1, :red, [0, :red], []], []], []]
    tree = build_explicit_rb_tree(array)
    result_array = [3, :black, [1, :black, [0, :red], [2, :red]], []]
    result = build_explicit_rb_tree(result_array) 
    tree.left_child.left_child.left_child.balance_left_left!
    expect(tree.equiv?(result)).to be(true)   
  end

  it "works when whole tree is being rotated" do
    array = [99, :black, [78, :red, [61, :red], []], []]
    tree = build_explicit_rb_tree(array)
    balanced = tree.left_child.left_child.balance_left_left!
    result_array = [78, :black, [61, :red], [99, :red]]
    result = build_explicit_rb_tree(result_array)
    expect(tree.equiv?(result)).to be(true)
  end
end

describe "balance_right_right!" do
  it "balances an otherwise balanced tree with a red right subtree of a red right subtree" do
    array = [0, :black, [], [1, :black, [], [2, :red, [], [3, :red]]]]
    tree = build_explicit_rb_tree(array)
    result_array = [0, :black, [], [2, :black, [1, :red], [3, :red]]]
    result = build_explicit_rb_tree(result_array) 
    tree.right_child.right_child.right_child.balance_right_right!
    expect(tree.equiv?(result)).to be(true)   
  end
end

describe "balance_left_right!" do
  it "balances an otherwise balanced tree with a red right subtree of a red left subtree" do
    array = [3, :black, [2, :black, [0, :red, [], [1, :red]], []], []]
    tree = build_explicit_rb_tree(array)
    result_array = [3, :black, [1, :black, [0, :red], [2, :red]], []]
    result = build_explicit_rb_tree(result_array) 
    tree.left_child.left_child.right_child.balance_left_right!
    expect(tree.equiv?(result)).to be(true)   
  end
end

describe "balance_right_left!" do
  it "balances an otherwise balanced tree with a red left subtree of a red right subtree" do
    array = [0, :black, [], [1, :black, [], [3, :red, [2, :red], []]]]
    tree = build_explicit_rb_tree(array)
    result_array = [0, :black, [], [2, :black, [1, :red], [3, :red]]]
    result = build_explicit_rb_tree(result_array) 
    tree.right_child.right_child.left_child.balance_right_left!
    expect(tree.equiv?(result)).to be(true)   
  end
end

# Tree-building methods

describe "build_explicit_rb_tree" do
  it "builds an rb tree without rebalancing" do
    tree = RedBlackNode.new(5, :red)
    l = RedBlackNode.new(3, :red)
    lr = RedBlackNode.new(1, :black)
    l.add_right_child(lr)
    tree.add_left_child(l)
    array = [5, :red, [3, :red, [], [1, :black]], []]
    built_tree = build_explicit_rb_tree(array)
    expect(tree.equiv?(built_tree)).to be(true)
  end
end

describe "build_rb_tree" do
  it "builds a balanced rb tree from an array" do
    array = [1, 2, 3, 4, 5, 6, 7]
    tree = build_rb_tree(array)
    result = build_explicit_rb_tree([2, :black, [1, :black], [4, :red, [3, :black], [6, :black, [5, :red], [7, :red]]]])
    expect(tree.equiv?(result)).to be(true)
  end
end

# Other methods

describe "balanced?" do
  it "if all paths from root to a nil child have the same black_height, returns that height" do
    tree = build_explicit_rb_tree([4, :black, [2, :red, [1, :black], [3, :black]], [6, :black]])
    p tree.to_a
    expect(balanced?(tree)).to be(2)
  end

  it "returns false otherwise" do
    tree = build_explicit_rb_tree([4, :black, [2, :red, [1, :black], [3, :black]], [6, :red]])
    expect(balanced?(tree)).to be(false)
  end
end

require 'set'

class Unreachable < Exception; end

class Node

  attr_accessor :value, :left_child, :right_child, :parent

  def initialize(value, parent = nil)
    @value = value
    @parent = parent
    @left_child = nil
    @right_child = nil
    self
  end

  # replaces current (sub)tree with one in which @right_child is the root
  def rotate_left!
    if @right_child
      right = @right_child
      left = self.clone
      right.parent = self.parent
      left.add_right_child(right.left_child)
      right.add_left_child(left)
      replace_self(right)
    end
    self
  end

  # replaces current (sub)tree with one in which @left_child is the root
  def rotate_right!
    if @left_child
      left = @left_child # color is changing
      right = self.clone
      left.parent = self.parent
      right.add_left_child(left.right_child)
      left.add_right_child(right)
      replace_self(left)
    end
    self
  end

  def replace_self(tree)
    @value = tree.value
    @parent = tree.parent
    @left_child = tree.left_child
    @right_child = tree.right_child
  end

  def uncle
    if parent.nil? || parent.parent.nil?
      nil
    else
      if parent.value < parent.parent.value
        parent.parent.right_child
      else
        parent.parent.left_child
      end
    end
  end

  def add_left_child(child)
    @left_child = child # why is @ necessary here?
    child.parent = self unless child.nil?
  end

  def add_right_child(child)
    @right_child = child
    child.parent = self unless child.nil?
  end

  def insert(n)
    child = self.class.new(n)
    if n < value
      if left_child
        left_child.insert(n)
      else
        add_left_child(child)
        child
      end
    elsif n > value
      if right_child
        right_child.insert(n)
      else
        add_right_child(child)
        child
      end
    elsif n == value
      nil
    end
  end

  # not actually used
  def size
    1 + [left_child, right_child].compact.inject(0) { |x, y| x + y.size }
  end

end

# balanced
def build_tree_from_sorted(array)
  if array == []
    nil
  else
    center = array.length / 2
    result = Node.new(array[center])
    result.add_left_child(build_tree_from_sorted(array[0 ... center]))
    result.add_right_child(build_tree_from_sorted(array[center + 1 .. -1]))
    result
  end
end

def build_tree(array)
  tree = Node.new(array[0])
  array[1..-1].each do |i|
    tree.insert(i)
  end
  tree
end

# assumes tree isn't nil
def breadth_first_search(tree, target)
  queue = [tree]
  visited_values = Set.new()
  result = nil
  while queue.length > 0 do
    current_node = queue.shift
    if current_node.value == target
      result = current_node
      break
    else
      queue += [current_node.left_child, current_node.right_child].compact
    end
  end
  result
end

# assumes tree isn't nil
def depth_first_search(tree, target)
  stack = [tree]
  current_node = tree
  visited_values = Set.new()
  result = nil
  while stack.length > 0
    if current_node.value == target
      result = current_node
      break
    elsif current_node.left_child && !visited_values.include?(current_node.left_child.value)
      current_node = current_node.left_child
      stack.push(current_node)
      visited_values.add(current_node.value)
    elsif current_node.right_child && !visited_values.include?(current_node.right_child.value)
      current_node = current_node.right_child
      stack.push(current_node)
      visited_values.add(current_node.value)
    else
      current_node = stack.pop
    end
  end
  result
end

def dfs_rec(tree, target)
  if tree.nil?
    nil
  elsif tree.value == target
    tree
  else
    dfs_rec(tree.left_child, target) || dfs_rec(tree.right_child, target)
  end
end

def binary_search(tree, target)
  if tree.nil?
    nil
  elsif tree.value == target
    tree
  elsif tree.value > target
    binary_search(tree.left_child, target)
  else
    binary_search(tree.right_child, target)
  end
end

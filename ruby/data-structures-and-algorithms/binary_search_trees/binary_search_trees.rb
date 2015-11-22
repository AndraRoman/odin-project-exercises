require 'set'

class Unreachable < Exception; end

class Node

  attr_accessor :value, :left_child, :right_child, :parent

  def initialize(value)
    @value = value
    @parent = nil
    @left_child = nil
    @right_child = nil
    self
  end

  def minimal_copy
    node = self.class.new(@value)
  end

  # for testing
  def display
    array = [@value]
    left_child ? array.push(left_child.display) : array.push([])
    right_child ? array.push(right_child.display) : array.push([])
    array
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

  def remove_from_parent
    if parent
      if @value < parent.value
        parent.left_child = nil
      elsif @value > parent.value
        parent.right_child = nil
      end
    end
  end

  def add_left_child(child)
    child.remove_from_parent if child
    @left_child = child
    child.parent = self unless child.nil?
  end

  def add_right_child(child)
    child.remove_from_parent if child
    @right_child = child
    child.parent = self unless child.nil?
  end

  def add_child(child)
    if child.value < @value
      add_left_child(child)
    elsif @value < child.value
      add_right_child(child)
    end
  end

  def insert(n)
    node = self.class.new(n)
    insert_node(node)
  end

  def insert_node(node)
    n = node.value
    if n < value
      if left_child
        left_child.insert_node(node)
      else
        add_left_child(node)
        node
      end
    elsif n > value
      if right_child
        right_child.insert_node(node)
      else
        add_right_child(node)
        node
      end
    elsif n == value
      nil
    end
  end

  def size
    1 + [left_child, right_child].compact.inject(0) { |x, y| x + y.size }
  end

  # does NOT check parent
  def equiv?(tree)
    tree_value = tree.nil? ? nil : tree.value # makes it easier to modify for rb trees
    if @value != tree_value
      return false
    elsif [@left_child, @right_child, tree.left_child, tree.right_child].all? { |t| t.nil? }
      return true
    elsif @left_child.nil?
      return (tree.left_child.nil? && @right_child.equiv?(tree.right_child))
    elsif @right_child.nil?
      return (tree.right_child.nil? && @left_child.equiv?(tree.left_child))
    else
      return (@left_child.equiv?(tree.left_child) && @right_child.equiv?(tree.right_child))
    end
  end

  # creates new subtree; pastes into position in parent tree if parent exists
  def rotate_left
    if @right_child
      new_left = minimal_copy
      new_left.add_right_child(@right_child.left_child)
      new_left.add_left_child(@left_child)

      @value = @right_child.value
      add_right_child(@right_child.right_child)
      add_left_child(new_left)

      parent.add_child(self) if parent
      self
    else
      false # not possible to rotate
    end
  end

  # creates new subtree; pastes into position in parent tree if parent exists
  def rotate_right
    if @left_child
      new_right = minimal_copy
      new_right.add_left_child(@left_child.right_child)
      new_right.add_right_child(@right_child)

      @value = @left_child.value
      add_left_child(@left_child.left_child)
      add_right_child(new_right)

      parent.add_child(self) if parent
      self
    else
      false # not possible to rotate
    end
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

def build_explicit_tree(array)
  if array.length == 0
    nil
  else
    node = Node.new(array[0])
    if array.length > 1
      node.add_left_child(build_explicit_tree(array[1]))
      node.add_right_child(build_explicit_tree(array[2]))
    end
  end
  node
end

def breadth_first_search(tree, target)
  queue = []
  queue.push(tree) unless tree.nil?
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

def depth_first_search(tree, target)
  stack = []
  stack.push(tree) unless tree.nil?
  visited_values = Set.new()
  result = nil
  while stack.length > 0
    current_node = stack[-1] # peek
    visited_values.add(current_node.value)
    if current_node.value == target
      result = current_node
      break
    elsif current_node.left_child && !visited_values.include?(current_node.left_child.value)
      stack.push(current_node.left_child)
    elsif current_node.right_child && !visited_values.include?(current_node.right_child.value)
      stack.push(current_node.right_child)
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

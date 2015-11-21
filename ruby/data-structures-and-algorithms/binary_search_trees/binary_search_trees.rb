require 'set'

class Node

  attr_accessor :value, :left_child, :right_child, :parent

  def initialize(value)
    @value = value
    @left_child = nil
    @right_child = nil
    @parent = nil
  end

  # returns new tree in which @right_child is the root
  def rotate_left
    if @right_child
      rotated = Node.new(@right_child.value) # no parent
      rotated.add_left_child(Node.new(@value))
      rotated.left_child.add_left_child(@left_child)
      rotated.left_child.add_right_child(@right_child.left_child)
      rotated.add_right_child(@right_child.right_child)
      rotated
    else
      self.copy
    end
  end

  # returns new tree in which @left_child is the root
  def rotate_right
     if @left_child
      rotated = Node.new(@left_child.value) # no parent
      rotated.add_right_child(Node.new(@value))
      rotated.right_child.add_right_child(@right_child)
      rotated.right_child.add_left_child(@left_child.right_child)
      rotated.add_left_child(@left_child.left_child)
      rotated
    else
      self.copy
    end
  end

  def add_left_child(child)
    @left_child = child
    child.parent = self unless child.nil?
  end

  def add_right_child(child)
    @right_child = child
    child.parent = self unless child.nil?
  end

  def insert(n)
    if n < @value
      if @left_child
        @left_child.insert(n)
      else
        add_left_child(Node.new(n))
      end
    elsif n > @value
      if @right_child
        @right_child.insert(n)
      else
        add_right_child(Node.new(n))
      end
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

def breadth_first_search(tree, target)
  if tree.nil?
    nil
  else
  end
end

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

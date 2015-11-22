require 'set'
require 'binary_search_trees'

class RedBlackNode < Node

  attr_accessor :color

  def initialize(n, color=:black)
    @color = color
    super(n)
  end

  def insert(n)
    node = super
    if node
      node.color = :red
      node.balance! 
    end
  end

  # for rotation
  def minimal_copy
    node = super
    node.color = @color
    node
  end

  # for testing
  def display
    array = [@value, @color]
    left_child ? array.push(left_child.display) : array.push([])
    right_child ? array.push(right_child.display) : array.push([])
    array
  end

  def balance!
    if parent.nil?
      @color = :black
    elsif parent.color == :black
    elsif parent.color == :red && !uncle.nil? && uncle.color == :red
      balance_red_uncle!
    elsif parent.value < value && value < parent.parent.value
      balance_left_right!
    elsif parent.parent.value < value && value < parent.value
      balance_right_left!
    elsif value < parent.value && parent.value < parent.parent.value
      result = balance_left_left!
    elsif parent.parent.value < parent.value && parent.value < value
      balance_right_right!
    else raise Unreachable # only happens in trees not balanced on each insertion
    end
  end

  def balance_red_uncle!
    parent.color = :black
    uncle.color = :black
    parent.parent.color = :red
    parent.parent.balance!
  end

  def balance_left_right!
    result = parent.rotate_left
    result.left_child.balance_left_left!
  end

  def balance_right_left!
    rotated = parent.rotate_right
    rotated.right_child.balance_right_right!
  end

  def balance_left_left!
    result = parent.parent.rotate_right
    result.color = :black 
    result.right_child.color = :red
    result
  end

  def balance_right_right!
    result = parent.parent.rotate_left
    result.color = :black
    result.left_child.color = :red
    result
  end

  #for testing
  def equiv?(tree)
    tree_color = tree.nil? ? :black : tree.color
    if tree_color == @color
      super
    else
      false
    end
  end

end

def build_rb_tree(array)
  tree = RedBlackNode.new(array[0])
  array[1..-1].each do |i|
    tree.insert(i)
  end
  tree
end

# for testing - no balancing
# [value, color, left_child, right_child]
def build_explicit_rb_tree(array)
  if array.length == 0
    nil
  else
    node = RedBlackNode.new(array[0])
    node.color = array[1]
    if array.length > 2
      node.add_left_child(build_explicit_rb_tree(array[2]))
      node.add_right_child(build_explicit_rb_tree(array[3]))
    end
  end
  node
end


def balanced?(tree)
  stack = []
  stack.push([tree, 0]) unless tree.nil?
  height = 0
  visited_values = Set.new()
  while stack.length > 0
    current_node, current_height = stack[-1] # peek
    current_height += 1 if current_node.nil? || current_node.color == :black
    visited_values.add(current_node.value)
    if !current_node.left_child || !current_node.right_child
      if current_height
        if height == 0
          height = current_height
        elsif height != current_height
          return false
        end
      end
      if !current_node.left_child && !current_node.right_child
        stack.pop
      elsif !current_node.right_child && !visited_values.include?(current_node.left_child.value)
        stack.push(current_node.left_child)
      elsif !current_node.right_child
        stack.pop
      elsif !current_node.left_child && !visited_values.include?(current_node.right_child.value)
        stack.push([current_node.right_child, current_height])
      elsif !current_node.left_child
        stack.pop
      end
    elsif !visited_values.include?(current_node.left_child.value)
      stack.push([current_node.left_child, current_height])
    elsif !visited_values.include?(current_node.right_child.value)
      stack.push([current_node.right_child, current_height])
    else
      stack.pop
    end
  end
  height
end

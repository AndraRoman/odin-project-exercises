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
      rotated = Node.new(@right_child.value)
      rotated.left_child = Node.new(@value)
      rotated.left_child.left_child = @left_child
      rotated.left_child.right_child = @right_child.left_child
      rotated.right_child = @right_child.right_child
      rotated
    else
      self.copy
    end
  end

  # returns new tree in which @left_child is the root
  def rotate_right
     if @left_child
      rotated = Node.new(@left_child.value)
      rotated.right_child = Node.new(@value)
      rotated.right_child.right_child = @right_child
      rotated.right_child.left_child = @left_child.right_child
      rotated.left_child = @left_child.left_child
      rotated
    else
      self.copy
    end
  end

  def insert(n)
    if n < @value
      if @left_child
        @left_child.insert(n)
      else
        @left_child = Node.new(n)
      end
    elsif n > @value
      if @right_child
        @right_child.insert(n)
      else
        @right_child = Node.new(n)
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
    result.left_child = build_tree_from_sorted(array[0 ... center])
    result.right_child = build_tree_from_sorted(array[center + 1 .. -1])
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

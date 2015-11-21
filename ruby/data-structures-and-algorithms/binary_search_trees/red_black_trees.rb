require 'set'
require 'binary_search_trees'

# don't care enough to handle deletion for now
class RedBlackNode < Node

  # only used for testing
  attr_accessor :color

  def initialize(n)
    @color = :black
    super
  end

  # TODO rejigger stuff so this doesn't need a separate name
  def rb_insert(n)
    node = insert(n)
    unless node.nil?
      node.color = :red
      puts "calling balance from insert(#{n})"
      node.balance!
    end
    node
  end

  def replace_self(tree)
    @color = tree.color
    super
  end

  # return value not used
  def balance!
    if parent.nil?
      @color = :black
    elsif parent.color == :black # do nothing
    elsif parent.color == :red && uncle.color == :red
      balance_red_uncle!
    elsif parent.value < value && value < parent.parent.value
      balance_left_right!
    elsif parent.parent.value < value && value < parent.value
      balance_right_left!
    elsif value < parent.value && parent.value < parent.parent.value
      balance_left_left!
    elsif parent.parent.value < parent.value && parent.value < value
      balance_right_right!
    else raise Unreachable
    end
  end

  def balance_red_uncle!
    # TODO (calls balance)
  end

  def balance_left_right!
    parent.rotate_left!
    @left_child.balance_left_left!
  end

  def balance_right_left!
    parent.rotate_right!
    @right_child.balance_right_right!
  end

  def balance_left_left!
    @color = :black
    parent.parent.rotate_right!
  end

  def balance_right_right!
    @color = :black
    parent.parent.rotate_left!
  end

end


def build_rb_tree(array)
  tree = RedBlackNode.new(array[0])
  array[1..-1].each do |i|
    tree.rb_insert(i)
  end
  tree
end

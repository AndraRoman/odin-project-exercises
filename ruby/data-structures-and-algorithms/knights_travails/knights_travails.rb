require 'set'

class MoveTree

  attr_reader :point, :children
  attr_accessor :parent

  def initialize(point)
    @point = point
    @parent = nil
    @children = []
  end

  def add_child(child)
    child.parent = self
    @children.push(child)
  end

end

def possible_moves(point)
  x, y = point
  relative_moves = [[2, 1], [2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
  unfiltered_moves = relative_moves.map { |i|  [i[0] + x, i[1] + y] }
  unfiltered_moves.select { |i| in_bounds(i) }
end

def in_bounds(point)
  point.all? { |i| (0...8).include?(i) }
end

# MoveTree -> MoveTree
def propagate_tree(node)
  moves = possible_moves(node.point)
  moves.each do |m|
    node.add_child(MoveTree.new(m))
  end
end

def get_path(node)
  path = []
  current_node = node
  while current_node
    path.push(current_node.point)
    current_node = current_node.parent
  end
  path.reverse
end

# return nil if not possible to get from start to finish (eg for a silly board size/shape)
# point, point -> [point]
def knight_moves(start, finish)
  tree = MoveTree.new(start)
  queue = [tree]
  result = nil
  visited_points = Set.new()
  while queue.length > 0
    current_node = queue.shift
    visited_points.add(current_node.point)
    if current_node.point == finish
      result = get_path(current_node)
      break
    else
      propagate_tree(current_node)
      queue += current_node.children.reject { |n| visited_points.include?(n.point) }
    end
  end
  result
end

# for testing
def array_equiv?(a, b)
  pairs = a.zip(b)
  (a.length == b.length) && pairs.all? { |x, y| x == y }
end

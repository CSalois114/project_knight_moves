class Square
  attr_accessor :children, :parent
  attr_reader :coord

  def initialize(coord)
    @coord = coord
    @children = []
    @parent = nil
  end
end

class Board
  attr_reader :squares_hash
 
  def initialize
    @squares_hash = {}
    (1..8).each {|x| (1..8).each {|y| squares_hash[[x,y]] = Square.new([x, y])}}
    populate_children
  end

  def populate_children
    possible_moves_offset_values = [[2,-1],[2,1],[1,2],[-1,2],[-2,1],[-2,-1],[-1,-2],[1,-2]]
    @squares_hash.values.each do |square|
      possible_moves_offset_values.each do |move|
        if @squares_hash[new_coord(square.coord, move)]
          square.children.push(@squares_hash[new_coord(square.coord, move)])
        end
      end
    end
  end

  def new_coord(coord, offset)
      return [coord[0] + offset[0], coord[1] + offset[1]]
  end
end

def find_path(starting_coord, ending_coord)
  board = Board.new
  queue = [board.squares_hash[starting_coord]]
  already_checked = []
  until queue.length == 0
    square = queue.shift

    return path_to(square) if square.coord == ending_coord 

    already_checked.push(square)

    square.children.each do |child| 
      unless already_checked.include?(child)
        child.parent = square
        queue.push(child)
      end 
    end
  end
end

def path_to(square)
  path = [square.coord]
  until square.parent == nil
    square = square.parent
    path.unshift(square.coord)
  end
  return path
end

p find_path([1,1],[8,8])        
p find_path([4,1],[3,2])
p find_path([5,7],[7,6])
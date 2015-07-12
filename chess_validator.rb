require 'pry'

class ParserPosition
	def parser position
		array_position = get_char position
		x = parser_char array_position[0]
		y = array_position[1]
		return [x, y]
	end

	def get_char position
		position.split('')
	end

	def parser_char pos_x
		case pos_x
		when "a"
			return 0
		when "b"
			return 1
		when "c"
			return 2
		when "d"
			return 3
		when "e"
			return 4
		when "f"
			return 5
		when "g"
			return 6
		when "h"
			return 7
		end
	end
end

class Board

	def initialize pieces
		@pieces = pieces
		@board = Array.new(8) { Array.new(8) }
		@board = set_pieces pieces

	end

	def set_pieces pieces
		pieces.each do |piece|
			@board[piece.position[0]][piece.position[1]] = piece
		end
		#binding.pry
		return @board
	end

	def show_board
		#binding.pry
		@board.each do |array1|
			array1.each do |array2|
				if array2 != nil
					print "#{array2.name}  "
				else
					print "--  "
				end
			end
			puts ""
		end
	end
end

class Piece
	attr_reader :name
	attr_accessor :position

	def initialize name, position
		@name = name
		@position = position
	end

	
end

class Rook < Piece
	attr_accessor :name
	def initialize color, position
		@name = color + "R"
		super @name, position
	end

	def is_a_possible_move position
		if @position[0] == position[0] || @position[1] == position[1]
			return true
		else
			return false
		end
	end

end

class Bishop < Piece
	attr_accessor :name
	def initialize color, position
		@name = color + "B"
		super @name, position
	end

	def is_a_possible_move position
		if @position[0] == @position[1] && position[0] == position[1]
			return true
		else
			return check_position position
		end
	end

	def check_position position
		x = position[0]
		y = position[1]
		op_x = check_operators @position[0], x
		op_y = check_operators @position[1], y
		validate_position position, op_x, op_y
	end

	def out_of_board x, y
		if x >= 0 && x < 8 && y >= 0 && y < 8
			return false
		else
			return true
		end
	end

	def check_operators a, b
		if(a > b)
			return "-"
		else
			return "+"
		end
	end

	def validate_position position, op_x, op_y
		pos = @position.clone
		validated = false
		while !validated && !out_of_board(pos[0], pos[1])
			pos[0] = calculate_new_position op_x, pos[0]
			pos[1] = calculate_new_position op_y, pos[1]
			if pos[0] == position[0] && pos[1] == position[1] 
				return true
			end
		end
		return false
	end

	def calculate_new_position op, pos
		if op == "-"
			pos -= 1
		else
			pos += 1
		end
	end

end

class Knight < Piece
	attr_accessor :name
	def initialize color, position
		@name = color + "N"
		super @name, position
	end

	def is_a_possible_move position
		if position[0] < @position[0]
			return go_north position
		else
			return go_south position
		end
	end

	def go_north position
		i = 1
		j = 2
		while i <= 2
			if position[1] < @position[1]
				if go_west position, [@position[0]-i, @position[1]], j
					return true
				end
			else
				if go_east position, [@position[0]-i, @position[1]], j
					return true
				end
			end
			j -= 1
			i += 1
		end
		return false
	end

	def go_south position
		i = 1
		j = 2
		#binding.pry
		while i <= 2
			if position[1] > @position[1]
				if go_east position, [@position[0]+i, @position[1]], j
					return true
				end
			else
				if go_west position, [@position[0]+i, @position[1]], j
					return true
				end
			end
			j -= 1
			i += 1
		end
		return false
	end

	def go_west position, current_position, j
		check_position position, [current_position[0], current_position[1]-j]
	end

	def go_east position, current_position, j
		check_position position, [current_position[0], current_position[1]+j]
	end

	def check_position position, current_position
		position == current_position
	end

end

class Pawn < Piece
	attr_accessor :name
	def initialize color, position
		@name = color + "P"
		super @name, position
		@color = color
		@firs_move = is_first_move
	end

	def is_first_move
		if @position[0] == 6 && @color == "w"
			return true
		elsif @position[0] == 1 && @color == "b"
			return true
		else
			return false
		end
	end

	def is_a_possible_move position
		if position[1] == @position[1]
			return check_move position
		else
			return false
		end			
	end

	def check_move position
		if @color == "w"
			return check_move_white_piece position
		else
			return check_move_black_piece position
		end
	end

	def check_move_white_piece position
		if check_position @position[0]-1, position[0]
			return true
		else
			if @firs_move
				return check_position @position[0]-2, position[0]
			end
		end
		return false
	end

	def check_move_black_piece position
		if check_position @position[0]+1, position[0]
			return true
		else
			if @firs_move
				return check_position @position[0]+2, position[0]
			end
		end
		return false
	end

	def check_position y1, y2
		y1 == y2
	end

end

class Queen < Piece
	attr_accessor :name
	def initialize color, position
		@color = color
		@name = color + "Q"
		@position = position
		super @name, @position
	end

	def is_a_possible_move position
		b = Bishop.new @color, @position
		r = Rook.new @color, @position
		if r.is_a_possible_move(position) || b.is_a_possible_move(position)
			return true
		else
			return false
		end
	end

end

class King < Piece
	attr_accessor :name
	def initialize color, position
		@name = color + "K"
		super @name, position
	end

end



# puts ParserPosition.new.parser("a2")

# bR1 = Rook.new("b", [0, 0])
# bR2 = Rook.new("b", [0, 1])
# wR1 = Rook.new("w", [0, 1])
# wR2 = Rook.new("w", [0, 1])

# bB1 = Bishop.new("b", [0, 0])
# bB2 = Bishop.new("b", [0, 1])
# wB1 = Bishop.new("w", [0, 1])
# wB2 = Bishop.new("w", [0, 1])

# r1 = Rook.new("b", [5, 4])
# r2 = Rook.new("w", [3, 5])
# puts r1.is_a_possible_move [0,2]
# puts r2.is_a_possible_move [0,2]

# b1 = Bishop.new("b", [2, 3])
# b2 = Bishop.new("w", [4, 1])

# n1 = Knight.new("b", [4, 3])
# n2 = Knight.new("w", [1, 0])

# p1 = Pawn.new("b", [1, 4])
# p2 = Pawn.new("w", [6, 2])
# p3 = Pawn.new("b", [2, 0])
# p4 = Pawn.new("w", [4, 6])

q1 = Queen.new("b", [1, 1])
q2 = Queen.new("w", [5, 4])

b = Board.new [q1, q2]

# puts n1.is_a_possible_move [2,2]
# puts n1.is_a_possible_move [2,4]
# puts n1.is_a_possible_move [3,2]
# puts n1.is_a_possible_move [3,4]
# puts n1.is_a_possible_move [5,1]
# puts n1.is_a_possible_move [5,5]
# puts n1.is_a_possible_move [6,2]
# puts n1.is_a_possible_move [6,4]
# puts n2.is_a_possible_move [0,2]

# puts p1.is_a_possible_move [2,4]
# puts p1.is_a_possible_move [3,4]
# puts p2.is_a_possible_move [5,2]
# puts p2.is_a_possible_move [4,2]
# puts p3.is_a_possible_move [3,0]
# puts p3.is_a_possible_move [1,0]
# puts p4.is_a_possible_move [2,6]
# puts p4.is_a_possible_move [3,6]

puts q1.is_a_possible_move [2,2]
puts q1.is_a_possible_move [1,6]
puts q1.is_a_possible_move [3,2]
puts q2.is_a_possible_move [4,6]
puts q2.is_a_possible_move [3,6]
puts q2.is_a_possible_move [5,1]

b.show_board
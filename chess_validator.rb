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
			true
		else
			false
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
			true
		else
			check_position position
		end
	end

	def check_position position
		x = position[0]
		y = position[1]
		#binding.pry
		op_x = check_operators @position[0], x
		op_y = check_operators @position[1], y
		validate_position position, op_x, op_y
	end

	def out_of_board x, y
		if x >= 0 && x < 8 && y >= 0 && y < 8
			false
		else
			true
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
		pos = @position
		#binding.pry
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

class Queen < Piece
	attr_accessor :name
	def initialize color, position
		@name = color + "Q"
		super @name, position
	end

	def is_a_possible_move position

	end

end

class King < Piece
	attr_accessor :name
	def initialize color, position
		@name = color + "K"
		super @name, position
	end

end

class Knight < Piece
	attr_accessor :name
	def initialize color, position
		@name = color + "N"
		super @name, position
	end

	def is_a_posible_move position

	end

	def calculate_new_position position
		if position[0] < @position[0]
			go_north
		else
			go_south
		end
	end

	def go_north position
		if position[1] < @position[1]
			i = 0
			while i < 2
				go_west
			end
		else
			i = 0
			while i < 2
				go_east
			end
		end
	end

	def go_south position
		if position[1] > @position[1]
			i = 1
			while i <= 2
				@position[1] += i
				go_east
			end
		else
			i = 1
			while i <= 2
				go_west
			end
		end
	end

	def go_west position

	end

	def go_east position

	end

end

class Pawn < Piece
	attr_accessor :name
	def initialize color, position
		@name = color + "P"
		super @name, position
		@firs_move = is_first_move position
	end

	def is_first_move position
		if position[1] == 6 && color == "w"
			true
		elsif position[1] == 1 && color == "b"
			true
		else
			false
		end
	end

	# def is_a_possible_move position
	# 	if !@first_move
	# 		return check_position position
	# 	else
	# 		false
	# 	end
			
	# end

	# def check_position position
	# 	if 
	# end

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

# r1 = Rook.new("b", [0, 1])
# r2 = Rook.new("w", [3, 5])
# puts r1.is_a_possible_move [0,2]
# puts r2.is_a_possible_move [0,2]

b1 = Bishop.new("b", [2, 3])
b2 = Bishop.new("w", [4, 1])
b = Board.new [b1, b2]

puts b1.is_a_possible_move [5,6]
puts b2.is_a_possible_move [0,2]
b.show_board
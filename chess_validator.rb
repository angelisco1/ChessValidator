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

	def is_a_possible_move position
		if @position[0]+1 == position[0] && @position[1] == position[1]
			return true
		elsif @position[0]-1 == position[0] && @position[1] == position[1]
			return true
		elsif @position[0] == position[0] && @position[1]+1 == position[1]
			return true
		elsif @position[0] == position[0] && @position[1]-1 == position[1]
			return true
		elsif @position[0]+1 == position[0] && @position[1]+1 == position[1]
			return true
		elsif @position[0]+1 == position[0] && @position[1]-1 == position[1]
			return true
		elsif @position[0]-1 == position[0] && @position[1]-1 == position[1]
			return true
		elsif @position[0]-1 == position[0] && @position[1]+1 == position[1]
			return true
		else
			return false
		end
	end

end


bP1 = Pawn.new("b", [1, 0])
bP2 = Pawn.new("b", [1, 1])
bP3 = Pawn.new("b", [1, 2])
bP4 = Pawn.new("b", [1, 3])
bP5 = Pawn.new("b", [1, 4])
bP6 = Pawn.new("b", [1, 5])
bP7 = Pawn.new("b", [1, 6])
bP8 = Pawn.new("b", [1, 7])

wP1 = Pawn.new("w", [6, 0])
wP2 = Pawn.new("w", [6, 1])
wP3 = Pawn.new("w", [6, 2])
wP4 = Pawn.new("w", [6, 3])
wP5 = Pawn.new("w", [6, 4])
wP6 = Pawn.new("w", [6, 5])
wP7 = Pawn.new("w", [6, 6])
wP8 = Pawn.new("w", [6, 7])

bR1 = Rook.new("b", [7, 0])
bR2 = Rook.new("b", [7, 7])
wR1 = Rook.new("w", [0, 0])
wR2 = Rook.new("w", [0, 7])

bN1 = Knight.new("b", [7, 1])
bN2 = Knight.new("b", [7, 6])
wN1 = Knight.new("w", [0, 1])
wN2 = Knight.new("w", [0, 6])

bB1 = Bishop.new("b", [7, 2])
bB2 = Bishop.new("b", [7, 5])
wB1 = Bishop.new("w", [0, 2])
wB2 = Bishop.new("w", [0, 5])

bQ1 = Queen.new("b", [7, 3])
bK1 = King.new("b", [7, 4])

wQ1 = Queen.new("w", [0, 3])
wK1 = King.new("w", [0, 4])

b = Board.new [bP1, bP2, bP3, bP4, bP5, bP6, bP7, bP8, 
				wP1, wP2, wP3, wP4, wP5, wP6, wP7, wP8,
				bR1, bR2, wR1, wR2, bN1, bN2, wN1, wN2,
				bB1, bB2, wB1, wB2, bQ1, bK1, wQ1, wK1]

b.show_board
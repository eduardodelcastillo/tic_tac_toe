#tic_tac_toe.rb 

# Draw a board 3 x 3
  # A hash corresponds to the slot of the board and would contain X or O
# Player goes first - X
# Then computer goes next - O
# When all slots have been filled - determine a winner
require 'pry'

def initialize_board
  board = {}
  (1..9).each { |k| board[k] = '' }
  board
end

def draw_board(board)
  system 'clear'
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
  puts "---------------"
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}  "
  puts "---------------"
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
end

def empty_positions(board) #determines which squares are empty
  board.select { |k, v| v == ''}.keys
end

def count_empty(board) #determine how many squares are empty
  board.select { |k, v| v == ''}.length
end

def first_turn?(board)
  count = 0
  board.each_value { |v| if v.empty? then count += 1 end }
  if count >= 2
    false
  else
    true
  end
end

def two_in_a_row(board)
  winning_lines = [[1, 2, 3], [1, 4, 7], [1, 5, 9], [2, 5, 8], [3, 5, 7], [4, 5, 6], [3, 6, 9], [7, 8, 9]]
  winning_lines.each do |line|
    if board[line[0]] == 'X' && board[line[1]] == 'X' && board[line[2]].empty? 
      board[line[2]] = 'O'
      break
    elsif board[line[1]] == 'X' && board[line[2]] == 'X' && board[line[0]].empty?
      board[line[0]] == 'O'
      break
    elsif board[line[0]] == 'X' && board[line[2]] == 'X' && board[line[1]].empty?
      board[line[1]] = 'O'
      break   
    end
  end
end

def player_picks_square(board)
  loop do
    puts "Pick a square (1 - 9): "
    position = gets.chomp.to_i
    if board[position].empty?
      board[position] = 'X'
      break
    else
      puts "That square is already taken."
    end
  end
end

def computer_picks_square(board)
  board_before = count_empty(board)
  two_in_a_row(board)
  # if nothing was done in two_in_a_row, then just pick randomly
  if board_before == count_empty(board)
    position = empty_positions(board).sample      
    board[position] = 'O'
  end
end

def pick_winner(board)
  winning_lines = [[1, 2, 3], [1, 4, 7], [1, 5, 9], [2, 5, 8], [3, 5, 7], [4, 5, 6], [3, 6, 9], [7, 8, 9]]
  winning_lines.each do |line|
    if board[line[0]] == 'X' && board[line[1]] == 'X' && board[line[2]] == 'X'
      return 'Player'
    elsif board[line[0]] == 'O' && board[line[1]] == 'O' && board[line[2]] == 'O'
      return 'Computer'
    end
  end
end

#game begins
board = initialize_board
draw_board(board)

begin
  player_picks_square(board)
  computer_picks_square(board)
  draw_board(board)
  winner = pick_winner(board)
end until empty_positions(board).empty? || (winner == 'Player' || winner == 'Computer')

if winner == 'Player' || winner == 'Computer' 
  puts "#{winner} wins!"
else
  puts "It's a tie!"
end


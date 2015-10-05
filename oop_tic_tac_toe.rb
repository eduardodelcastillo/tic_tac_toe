#oop_tic_tac_toe.rb

# Board - initialize, draw, all_squares_filled
# Square - empty_squares, count_empty
# Player - human, computer, pick_square
# Game - play, pick_winner

require 'pry'

class Square
  attr_accessor :value
  attr_reader :marker

  def initialize(value)
    @value = value
  end

  def empty?
    value == ' '
  end

  def has_content?
    value != " "
  end

  def mark(marker)
    self.value = marker
  end

  def to_s
    value
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [1, 4, 7], [1, 5, 9], [2, 5, 8], [3, 5, 7], [4, 5, 6], [3, 6, 9], [7, 8, 9]]  
  attr_reader :data, :marker, :position

  def initialize
    @data = {}
    (1..9).each { |position| @data[position] = Square.new(' ') }
  end

  def draw
    system 'clear'
    puts "     |     |      "
    puts "  #{data[1]}  |  #{data[2]}  |  #{data[3]}  "
    puts "     |     |      "    
    puts "-----+-----+------"
    puts "     |     |      "    
    puts "  #{data[4]}  |  #{data[5]}  |  #{data[6]}  "
    puts "     |     |      "      
    puts "-----+-----+------"
    puts "     |     |      "    
    puts "  #{data[7]}  |  #{data[8]}  |  #{data[9]}  "
    puts "     |     |      "    
  end

  def mark_board(position, marker)
    data[position].mark(marker)
  end 

  def empty?(position)
    data[position].empty?
  end 

  def remaining_squares
    data.select { |_, v| v.empty? }
  end

  def no_more_squares
    data.select { |_, v| v.empty? }.length == 0
  end    

  def three_in_a_row?(marker)
    WINNING_LINES.each do |line|
      return true if data[line[0]].value == marker && data[line[1]].value == marker && data[line[2]].value == marker
    end
    false
  end  

  #This attempts to give the computer some intelligence mainly to fill up the slot if it detects two in a row markers
  def two_in_a_row(marker)
    WINNING_LINES.each do |line|
      if (data[line[0]].value == marker && data[line[1]].value == marker) && data[line[2]].empty?
        return line[2]
        break
      elsif (data[line[1]].value == marker && data[line[2]].value == marker) && data[line[0]].empty?
        return line[0]
        break
      elsif (data[line[0]].value == marker && data[line[2]].value == marker) && data[line[1]].empty?
        return line[1]
        break
      end
    end
    nil
  end
end

class Player
  attr_reader :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Game
  attr_accessor :position, :board
  attr_reader :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new('You','X')
    @computer = Player.new('Red','O')
    @current_player = @human
  end

  def player_marks_square
    if @current_player == human
      loop do
        begin
          puts "Pick a square (1 - 9): "
          self.position = gets.chomp.to_i
        end until (1..9).include?(self.position)
        if board.empty?(self.position)
          break
        else
          puts "That square is already taken."
        end   
      end
    else
      self.position = board.two_in_a_row(human.marker)
      if self.position == nil
        self.position = board.remaining_squares.keys.sample
      end
    end
    board.mark_board(self.position, @current_player.marker)
  end  

  def alternate_player
    if @current_player == human
      @current_player = computer
    else
      @current_player = human
    end
  end

  def pick_winner
    if board.three_in_a_row?(@current_player.marker)
      puts "#{@current_player.name} won!"
    else
      puts "It's a tie!"
    end
  end 

  def play
    begin
      board.draw
      player_marks_square
      board.draw
      if board.three_in_a_row?(@current_player.marker)
        break
      end
      alternate_player
    end until board.no_more_squares
    pick_winner
  end
end

game = Game.new.play
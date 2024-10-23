require 'yaml'
require 'pry'

MESSAGES = YAML.load_file('ttt_messages.yml')

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
                   [1, 4, 7], [2, 5, 8], [3, 6, 9], # cols
                   [1, 5, 9], [3, 5, 7]             # diagonals
  ]
  attr_reader :squares

  def initialize
    @squares = (1..9).each_with_object({}) do |key, hash| 
      hash[key] = Square.new
    end
  end

  def get_square_at(key)
    squares[key] # returns a Square object
  end

  def set_square_at(key, marker)
    squares[key].marker = marker
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!detect_winner
  end

  def count_human_marker(squares)
    squares.map(&:marker).count(TTTGame::HUMAN_MARKER)
  end

  def count_computer_marker(squares)
    squares.map(&:marker).count(TTTGame::COMPUTER_MARKER)
  end

  # returns winning marker or nil
  def detect_winner
    WINNING_LINES.each do |line|
      current_squares = squares.values_at(*line)
      if count_human_marker(current_squares) == 3
        return TTTGame::HUMAN_MARKER
      elsif count_computer_marker(current_squares) == 3
        return TTTGame::COMPUTER_MARKER
      end
    end
    nil
  end


end

class Square
  INITIAL_MARKER = ' '
  
  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

# Orchestration Engine
class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def prompt(message)
    puts MESSAGES[message]
  end

  def display_welcome_message
    prompt('welcome')
    puts ""
  end

  def display_goodbye_message
    prompt('goodbye')
  end

  def display_markers
    puts format(MESSAGES['markers'], human: human.marker,
                                     computer: computer.marker)
  end

  def display_board
    system 'clear'
    display_markers
    puts ""
    puts "     |     |"
    puts "  #{board.get_square_at(1)}  |  #{board.get_square_at(2)}  |  #{board.get_square_at(3)}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_square_at(4)}  |  #{board.get_square_at(5)}  |  #{board.get_square_at(6)}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_square_at(7)}  |  #{board.get_square_at(8)}  |  #{board.get_square_at(9)}  "
    puts "     |     |"
    puts ""
  end

  def display_move_options
    puts format(MESSAGES['choose'], numbers: board.unmarked_keys.join(', '))
  end

  def display_result
    display_board

    case board.detect_winner
    when human.marker
      prompt('human_won')
    when computer.marker
      prompt('computer_won')
    else
      prompt('tie')
    end

  end

  def human_moves
    display_move_options
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      prompt('invalid_choice')
    end

    board.set_square_at(square, human.marker)
  end

  def computer_moves
    board.set_square_at(board.unmarked_keys.sample, computer.marker)
  end

  def play
    display_welcome_message
    display_board
    loop do
      human_moves
      break if board.someone_won? || board.full?

      computer_moves
      break if board.someone_won? || board.full?

      display_board
    end
    display_result
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
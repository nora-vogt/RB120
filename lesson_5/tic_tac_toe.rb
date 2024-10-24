require 'yaml'
require 'pry'

MESSAGES = YAML.load_file('ttt_messages.yml')

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
                   [1, 4, 7], [2, 5, 8], [3, 6, 9], # cols
                   [1, 5, 9], [3, 5, 7]             # diagonals
  ]

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}  "
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}  "
    puts "     |     |"
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def count_human_marker(squares)
    squares.map(&:marker).count(TTTGame::HUMAN_MARKER)
  end

  def count_computer_marker(squares)
    squares.map(&:marker).count(TTTGame::COMPUTER_MARKER)
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      current_squares = @squares.values_at(*line)
      if count_human_marker(current_squares) == 3
        return TTTGame::HUMAN_MARKER
      elsif count_computer_marker(current_squares) == 3
        return TTTGame::COMPUTER_MARKER
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
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
    display_markers
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_move_options
    puts format(MESSAGES['choose'], numbers: board.unmarked_keys.join(', '))
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
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

    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def play_again?
    answer = nil
    loop do
      prompt('ask_play_again')
      answer = gets.chomp.downcase
      break if %w(y yes n no).include? answer
      prompt('invalid_play_again')
    end

    ['y', 'yes'].include?(answer)
  end
  
  def clear
    system 'clear'
  end

  def display_play_again_message
    prompt('play_again')
    puts ''
  end

  def reset
    board.reset
    clear
  end

  def play
    clear
    display_welcome_message

    loop do
      display_board

      loop do
        human_moves
        break if board.someone_won? || board.full?

        computer_moves
        break if board.someone_won? || board.full?

        clear_screen_and_display_board
      end
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end
end

game = TTTGame.new
game.play
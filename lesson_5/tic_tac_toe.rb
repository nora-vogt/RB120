require 'yaml'
require 'pry'

MESSAGES = YAML.load_file('ttt_messages.yml')

class Board
  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
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

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
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
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if all_identical_markers?(squares)
        return squares[0].marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def all_identical_markers?(squares)
    return false unless squares.all?(&:marked?)
    squares.all? { |square| square.same_marker?(squares[0]) }
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

  def marked?
    marker != INITIAL_MARKER
  end

  def same_marker?(other)
    marker == other.marker
  end
end

class Player
  attr_accessor :marker
  attr_reader :name

  def prompt(message)
    puts MESSAGES[message]
  end

  private

  attr_writer :name
end

class Human < Player
  def set_name
    prompt('ask_name')
    name = nil
    loop do
      name = gets.strip
      break unless name.empty?
      prompt('invalid_name')
    end

    self.name = name
  end
end

class Computer < Player
  def set_name
    self.name = ["Mosscap", "Hal", "Bender"].sample
  end
end

# Orchestration Engine
class TTTGame
  X_MARKER = 'X'
  O_MARKER = 'O'

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @current_player = human
  end

  def play
    clear
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  attr_writer :current_player

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
                                     computer_name: computer.name,
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

  def joinor(numbers, delimiter=', ', word='or')
    case numbers.size
    when 0 then ''
    when 1 then numbers[0].to_s
    when 2 then numbers.join(" #{word} ")
    else
      numbers[-1] = "#{word} #{numbers[-1]}"
      numbers.join(delimiter)
    end
  end

  def display_move_options
    puts format(MESSAGES['choose'], numbers: joinor(board.unmarked_keys))
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

  def display_player_names
    puts format(MESSAGES['display_names'], human: human.name, computer: computer.name)
    puts ""
    sleep 1.5
  end

  def set_player_names
    [human, computer].each(&:set_name)
  end

  def set_current_player
    #
  end

  def set_human_marker
    prompt('ask_marker')
    choice = nil
    loop do
      choice = gets.to_i
      break if [1, 2, 3].include?(choice)
      prompt('invalid_marker')
    end

    case choice
    when 1 then human.marker = X_MARKER
    when 2 then human.marker = O_MARKER
    when 3 then human.marker = [X_MARKER, O_MARKER].sample
    end
  end

  def set_computer_marker
    computer.marker = (human.marker == X_MARKER ? O_MARKER : X_MARKER)
  end

  def set_player_markers
    set_human_marker
    set_computer_marker
    puts ""
    puts "Ok. You're #{human.marker}!"
    sleep 1.5
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

  def switch_current_player
    @current_player = if @current_player == human
                        computer
                      else
                        human
                      end
  end

  def current_player_moves
    if human_turn?
      human_moves
    else
      computer_moves
    end

    switch_current_player
  end

  def human_turn?
    @current_player == human
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

    # shouldn't need this, will re-initialize when a new game starts
    # so delete when making this change
    @current_player = human
    clear
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def main_game
    loop do
      #set_current_player
      set_player_names
      display_player_names
      set_player_markers
      clear_screen_and_display_board
      player_move
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
  end
end

game = TTTGame.new
game.play

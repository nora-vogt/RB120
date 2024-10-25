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
    configure_settings
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
    pause(1)
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

  def display_computer_moving
    print "#{computer.name} is moving"
    %w(. . .).each do |period|
      sleep 0.5
      print "."
    end
  end

  def display_play_again_message
    prompt('play_again')
    puts ''
  end

  def configure_settings
    clear
    set_player_names
    clear
    set_player_markers
    clear
    set_current_player
  end

  def set_player_names
    [human, computer].each(&:set_name)
    display_player_names
  end

  def ask_one_two_three_choice
    loop do
      choice = gets.chomp
      return choice if %w(1 2 3).include?(choice)
      prompt('invalid_number')
    end
  end

  def ask_yes_or_no
    loop do
      answer = gets.chomp.downcase
      break answer if %w(y yes n no).include? answer
      prompt('invalid_yes_no')
    end
  end

  def set_human_marker
    prompt('ask_marker')
    choice = ask_one_two_three_choice.to_i

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
    print "Ok! "
    display_markers
    sleep 1.5
  end

  def set_current_player
    puts format(MESSAGES['ask_first_player'], computer: computer.name)
    choice = ask_one_two_three_choice.to_i

    case choice
    when 1 then @current_player = human
    when 2 then @current_player = computer
    when 3 then @current_player = [human, computer].sample
    end

    puts ""
    puts format(MESSAGES['first_player'], player: @current_player.name)
    sleep 1.5
  end

  def human_moves
    display_move_options
    square = nil
    loop do
      square = gets.chomp
      break if board.unmarked_keys.map(&:to_s).include?(square)
      prompt('invalid_choice')
    end

    board[square.to_i] = human.marker
  end

  def computer_moves
    # commented out for testing - uncomment later
    #display_computer_moving 
    board[board.unmarked_keys.sample] = computer.marker
  end

  def alternate_current_player
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

    alternate_current_player
  end

  def human_turn?
    @current_player == human
  end

  def play_again?
    prompt('ask_play_again')
    answer = ask_yes_or_no
    ['y', 'yes'].include?(answer)
  end

  def reset_settings?
    prompt('ask_change_settings')
    answer = ask_yes_or_no
    ['y', 'yes'].include?(answer)
  end

  def clear
    system 'clear'
  end

  def pause(seconds=0.5)
    sleep seconds
  end

  def reset
    configure_settings if reset_settings?
    board.reset
    clear
  end

  def player_move
    loop do
      clear_screen_and_display_board
      current_player_moves
      break if board.someone_won? || board.full?
    end
  end

  def main_game
    loop do
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

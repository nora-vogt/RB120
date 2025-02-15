require 'yaml'

MESSAGES = YAML.load_file('ttt_messages.yml')

module Formatable
  def prompt(message, options = {})
    puts "=> #{format(MESSAGES[message], options)}"
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
end

module TTTGameDisplay
  def display_welcome_message
    puts(MESSAGES['welcome'])
    pause 1
  end

  def clear_screen_and_display_rules
    clear
    prompt('rules', score: self.class::DEFAULT_WINNING_SCORE)
    prompt('exit')
    gets
  end

  def display_goodbye_message
    prompt('goodbye')
  end

  def display_round_number
    puts "ROUND #{@round}".center(20, '-')
  end

  def display_scoreboard
    display_round_number
    [human, computer].each { |player| puts "#{player.name}: #{player.score}" }
    puts '-' * 20
    puts ''
  end

  def display_markers
    puts format(MESSAGES['scoreboard_markers'], human: human.marker,
                                                computer_name: computer.name,
                                                computer: computer.marker)
  end

  def display_board
    display_scoreboard
    display_markers
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_round_results
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      prompt('human_won_round')
    when computer.marker
      prompt('computer_won_round', name: computer.name)
    else
      prompt('tie')
    end

    pause 1.5
  end

  def display_player_names
    puts ""
    prompt('display_names', human: human.name, computer: computer.name)
    pause 1.5
  end

  def display_marker_choice
    puts ""
    prompt('markers', human: human.marker,
                      computer_name: computer.name,
                      computer: computer.marker)
    pause 1.5
  end

  def display_winning_score
    puts ""
    if winning_score == self.class::DEFAULT_WINNING_SCORE
      prompt('keep_default', number: winning_score)
    else
      prompt('winning_score', number: winning_score,
                              round: (winning_score == 1 ? 'round' : 'rounds'))
    end
    pause 1.5
  end

  def display_first_player
    puts ""
    prompt('first_player', player: @first_player.name)
    pause 1.5
  end

  def display_computer_moving
    print "#{computer.name} is moving"
    %w(. . .).each do |period|
      pause 0.2
      print period
    end
  end

  def display_game_winner
    winner = [human, computer].find { |player| player.score == winning_score }
    puts ""
    if winner == human
      prompt('human_won_game', number: winning_score)
    else
      prompt('computer_won_game', name: winner.name,
                                  number: self.class::DEFAULT_WINNING_SCORE)
    end
    puts ""
  end

  def clear_screen_and_display_play_again
    clear
    prompt('yes_play_again')
    puts ""
  end
end

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

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def [](key)
    @squares[key]
  end

  def top_line(numbers)
    numbers.each do |num|
      print "    #{square_number(num)}#{num == numbers[-1] ? "\n" : '|'}"
    end
  end

  def middle_line(numbers)
    numbers.each do |num|
      print "  #{@squares[num]}  #{num == numbers[-1] ? "\n" : '|'}"
    end
  end

  def bottom_line
    puts "     |     |"
  end

  def divider_line
    puts "-----+-----+-----"
  end

  def draw_section(numbers)
    top_line(numbers)
    middle_line(numbers)
    bottom_line
    divider_line unless numbers == [7, 8, 9]
  end

  def draw
    lines = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    lines.each { |line| draw_section(line) }
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

  def winning_marker
    WINNING_LINES.each do |line|
      squares = find_squares(line)
      if all_identical_markers?(squares)
        return squares[0].marker
      end
    end
    nil
  end

  def square_needed_to_win(marker)
    WINNING_LINES.each do |line|
      markers = find_squares(line).map(&:marker)
      if markers.count(marker) == 2
        unmarked_square = line.find { |key| @squares[key].unmarked? }
        return unmarked_square if unmarked_square
      end
    end

    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def square_number(key)
    @squares[key].unmarked? ? key : Square::INITIAL_MARKER
  end

  def find_squares(keys)
    @squares.values_at(*keys)
  end

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
  include Formatable

  attr_accessor :marker, :score
  attr_reader :name

  def initialize
    @score = 0
  end

  def update_score
    self.score += 1
  end

  def reset_score
    self.score = 0
  end

  def same_score?(other)
    score == other.score
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
    self.name = ["Mosscap", "HAL", "Bender", "Rosie"].sample
  end
end

class TTTGame
  X_MARKER = 'X'
  O_MARKER = 'O'
  MIDDLE_SQUARE = 5
  DEFAULT_WINNING_SCORE = 5

  include TTTGameDisplay, Formatable

  attr_reader :board, :human, :computer, :winning_score

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @round = 1
  end

  def play
    clear
    display_welcome_message
    clear_screen_and_display_rules if read_rules?
    configure_settings
    main_game
    display_goodbye_message
  end

  private

  attr_writer :current_player, :winning_score

  def configure_settings
    clear_screen_and_set_player_names
    display_player_names
    clear_screen_and_set_player_markers
    display_marker_choice
    clear_screen_and_set_winning_score
    display_winning_score
    clear_screen_and_set_first_player
    display_first_player
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
      return answer if %w(y yes n no).include? answer
      prompt('invalid_yes_no')
    end
  end

  def read_rules?
    prompt('ask_rules')
    puts ""
    choice = ask_yes_or_no
    ['y', 'yes'].include?(choice)
  end

  def clear_screen_and_set_player_names
    clear
    [human, computer].each(&:set_name)
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

  def clear_screen_and_set_player_markers
    clear
    set_human_marker
    set_computer_marker
  end

  def ask_default_or_custom_score
    prompt('ask_default_or_custom_score', number: DEFAULT_WINNING_SCORE)
    loop do
      choice = gets.chomp.downcase
      return choice if ['y', 'yes', 'n', 'no'].include?(choice)
      prompt('invalid_yes_no')
    end
  end

  def ask_winning_score
    score = nil
    prompt('ask_winning_score')
    loop do
      score = nil
      score = gets.chomp
      break if ('1'..'50').include?(score)
      prompt('invalid_score')
    end

    self.winning_score = score.to_i
  end

  def clear_screen_and_set_winning_score
    clear
    choice = ask_default_or_custom_score

    if ['y', 'yes'].include?(choice)
      clear
      ask_winning_score
    else
      self.winning_score = DEFAULT_WINNING_SCORE
    end
  end

  def clear_screen_and_set_first_player
    clear
    prompt('ask_first_player', computer: computer.name)
    choice = ask_one_two_three_choice.to_i

    case choice
    when 1 then @first_player = human
    when 2 then @first_player = computer
    when 3 then @first_player = [human, computer].sample
    end
  end

  def human_moves
    prompt('choose', numbers: joinor(board.unmarked_keys))
    square = nil
    loop do
      square = gets.chomp
      break if board.unmarked_keys.map(&:to_s).include?(square)
      prompt('invalid_choice')
    end

    board[square.to_i] = human.marker
  end

  def human_square_to_win
    board.square_needed_to_win(human.marker)
  end

  def computer_square_to_win
    board.square_needed_to_win(computer.marker)
  end

  def determine_computer_move
    if computer_square_to_win
      computer_square_to_win
    elsif human_square_to_win
      human_square_to_win
    elsif board[MIDDLE_SQUARE].unmarked?
      MIDDLE_SQUARE
    else
      board.unmarked_keys.sample
    end
  end

  def computer_moves
    display_computer_moving
    board[determine_computer_move] = computer.marker
  end

  def alternate_current_player
    @current_player = if @current_player == human
                        computer
                      else
                        human
                      end
  end

  def set_current_player
    @current_player = if @round == 1
                        @first_player
                      elsif @round_loser
                        @round_loser == human ? human : computer
                      elsif human.same_score?(computer)
                        [human, computer].sample
                      else
                        [human, computer].min_by(&:score)
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

  def update_round_number
    @round += 1
  end

  def update_round_results
    case board.winning_marker
    when human.marker
      human.update_score
      @round_loser = computer
    when computer.marker
      computer.update_score
      @round_loser = human
    end
  end

  def human_turn?
    @current_player == human
  end

  def game_won?
    [human, computer].any? { |player| player.score == winning_score }
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

  def reset_round_number
    @round = 1
  end

  def reset_scores
    [human, computer].each(&:reset_score)
  end

  def reset_round
    update_round_number
    board.reset
    clear
  end

  def reset_game
    clear_screen_and_display_play_again
    configure_settings if reset_settings?
    reset_round
    reset_round_number
    reset_scores
  end

  def player_move
    set_current_player
    loop do
      clear_screen_and_display_board
      current_player_moves
      break if board.someone_won? || board.full?
    end
  end

  def play_rounds_until_game_won
    loop do
      player_move
      update_round_results
      display_round_results
      break if game_won?
      reset_round
    end
  end

  def main_game
    loop do
      play_rounds_until_game_won
      display_game_winner
      break unless play_again?
      reset_game
    end
  end
end

TTTGame.new.play

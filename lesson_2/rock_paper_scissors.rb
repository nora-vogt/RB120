require 'pry'
=begin
# CURRENT: 
- implement different computer personalities
  - left off in Chappie#choose opponent's last move
    - right now, it is pulling the move from the same round (opponent.move)
    - need to pull the LAST round


# NEXT:
# Make history display more of a table
  # when to ask user if they want to see the history?
  - Start yml file for extracting strings

# MISC NOTES
 - Can add @game_number to RPSGame, edit history to show Game# and Round#, then delete #reset_history
 - Add "verb" move output after moves are chosen from http://www.samkass.com/theories/RPSSL.html
 - display a welcome message before choosing a name -- maybe use some kind of GameSetup class, choose name, opponent, see rules, etc, and within that class call RPSGame.new.play?
 - anytime 'Spock' is displayed, make it capitalized
=end
module Printable
  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors! Goodbye!"
  end

  def display_computer_choices(computers)
    computers.each.with_index(1) do |computer, number|
      puts "#{number}. #{computer}"
    end
  end

  def display_moves
    puts
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_round_winner
    puts
    if round_winner
      puts "#{round_winner.name} won!"
    else
      puts "It's a tie! No points are awarded."
    end
  end

  def display_score
    puts "ROUND #{round_number}".center(20, '-')
    [human, computer].each { |player| puts "#{player.name}: #{player.score}" }
    puts '-' * 20
    puts ''
  end

  def display_game_winner(winning_score)
    puts "#{game_winner.name} has #{winning_score} points and wins the game! Congrats!"
  end
end

class Move
  attr_reader :value

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  WIN_COMBINATIONS = { 'rock' => ['scissors', 'lizard'],
                       'paper' => ['rock', 'spock'],
                       'scissors' => ['paper', 'lizard'],
                       'lizard' => ['spock', 'paper'],
                       'spock' => ['scissors', 'rock'] }

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WIN_COMBINATIONS[value].include?(other_move.value)
  end

  def <(other_move)
    WIN_COMBINATIONS[other_move.value].include?(value)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  def set_name
    human_name = ''
    loop do
      puts "What's your name?"
      human_name = gets.chomp
      break unless human_name.empty?
      puts "Sorry, must enter a value."
    end
    self.name = human_name
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or Spock:"
      choice = gets.strip.downcase
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  attr_reader :history, :opponent

  def initialize(opponent, history)
    super()
    @opponent = opponent
    @history = history
  end

  def choose_randomly
    self.move = Move.new(Move::VALUES.sample)
  end
end

class R2D2 < Computer
  def set_name
    self.name = 'R2D2'
  end

  def choose
  end
end

class Hal < Computer
  def set_name
    self.name = 'Hal'
  end

  def choose
    binding.pry
  end
end

class Chappie < Computer
  def set_name
    self.name = 'Chappie'
  end

  def lost_last_two_rounds?
    last_two_rounds = history.move_log.last(2)
    return false if last_two_rounds.size < 2

    last_two_rounds.all? { |round| round['Winner'] == opponent.name }
  end

  def find_opponents_last_move
    history.move_log.last[opponent.name]
  end

  def copy_opponents_last_move
    last_move = find_opponents_last_move
    self.move = Move.new(last_move)
  end

  def beat_opponents_last_move
    last_move = find_opponents_last_move
    beats_last_move = Move::WIN_COMBINATIONS.select do |_, value| 
      value.include?(last_move)
    end.keys

    self.move = Move.new(beats_last_move.sample)
  end

  def choose
    if history.move_log.empty? # If round 1, choose randomly
      choose_randomly
    elsif lost_last_two_rounds? # If lost last 2 rounds, choose to beat the opponent's last move
      beat_opponents_last_move
    else # Choose the user's last move
      copy_opponents_last_move
    end
  end
end

class Mosscap < Computer
  def set_name
    self.name = 'Mosscap'
  end

  def choose
    self.move = Move.new(['lizard', 'rock', 'paper'].sample)
  end
end

class ART < Computer
  def set_name
    self.name = 'ART'
  end

  def choose
    choose_randomly
  end
end

class History
  attr_accessor :move_log

  def initialize
    @move_log = []
  end

  def update(human, computer, round_winner)
    move_log << { human.name => human.move.value, 
                  computer.name => computer.move.value, 
                  'Winner' => (round_winner ? round_winner.name : 'Tie')}
  end

  def display
    puts ''
    puts 'GAME HISTORY:'
    move_log.each do |round, data|
      puts "Round #{round}:"
      data.each do |player, move|
        puts "#{player} - #{move}"
      end
      puts ''
    end
  end

  def reset
    self.move_log = {}
  end

  # def last_round_winner
  #   last_round = move_log.size
  #   move_log[last_round - 1]['Winner']
  # end
end

# Game Orchestration Engine
class RPSGame
  include Printable

  attr_accessor :human, :computer, :round_number, :round_winner, :game_winner, 
                :history

  ONE_POINT = 1
  ZERO_POINTS = 0
  WINNING_SCORE = 5

  def initialize
    @round_number = 1
    @history = History.new
    @human = Human.new
    @computer = choose_computer.new(human, history)
    @round_winner = nil
    @game_winner = nil 
  end

  def choose_computer
    system 'clear'
    computers = Computer.subclasses << 'Choose randomly!'

    puts "Choose your opponent. Enter a number 1-6:"
    choice = ''
    loop do
      display_computer_choices(computers)
      choice = gets.strip
      break if ['1', '2', '3', '4', '5', '6'].include?(choice)
      puts "Invalid choice. Enter a number 1-6:"
    end

    choice == '6' ? computers[0..-2].sample : computers[choice.to_i - 1]
  end

  def set_round_winner
    if human.move > computer.move
      self.round_winner = human
    elsif human.move < computer.move
      self.round_winner = computer
    end
  end

  def update_score
    round_winner.score += ONE_POINT if round_winner
  end

  def update_round_number
    self.round_number += 1
  end

  def update_stats
    history.update(human, computer, round_winner) 
    update_score
    update_round_number unless game_won?
  end

  def prompt_to_continue
    puts "Press ENTER to continue:"
    gets
  end

  def reset_round_winner
    self.round_winner = nil
  end

  def reset_game_winner
    self.game_winner = nil
  end

  def reset_score
    [human, computer].each do |player|
      player.score = ZERO_POINTS
    end
  end

  def reset_round_number
    self.round_number = 1
  end

  def reset_game
    reset_score
    reset_game_winner
    reset_round_number
    history.reset
  end

  def game_won?
    [human, computer].any? do |player|
      self.game_winner = player if player.score == WINNING_SCORE
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'yes', 'n', 'no'].include?(answer)
      puts "Sorry, must enter y or n."
    end

    answer == 'y'
  end

  def play_round
    system 'clear'
    display_score
    human.choose
    computer.choose
    display_moves
    set_round_winner
    display_round_winner
    update_stats
    #history.display
  end

  def play
    system 'clear'
    display_welcome_message
    prompt_to_continue
    loop do
      loop do
        play_round
        
        break if game_won?
        reset_round_winner
        prompt_to_continue
      end

      prompt_to_continue
      system 'clear'
      display_score
      display_game_winner(WINNING_SCORE)

      break unless play_again?
      reset_game
    end

    display_goodbye_message
  end
end

RPSGame.new.play

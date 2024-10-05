require 'pry'
=begin
# CURRENT: 
# Make history display more of a table
  # when to ask user if they want to see the history?

#Computer personalities

We have a list of robot names for our Computer class, but other than the name, there's really nothing different about each of them. It'd be interesting to explore how to build different personalities for each robot. For example, R2D2 can always choose "rock". Or, "Hal" can have a very high tendency to choose "scissors", and rarely "rock", but never "paper". You can come up with the rules or personalities for each robot. How would you approach a feature like this?


# NEXT:
  - Start yml file for extracting strings
  - At start of game, choose computer opponent, or choose randomly

# MISC NOTES
 - Should displaying output be its own class?
 - Can add @game_number to RPSGame, edit history to show Game# and Round#, then delete #reset_history
 - Add "verb" move output after moves are chosen from http://www.samkass.com/theories/RPSSL.html
=end
module Printable
  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors! Goodbye!"
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
  attr_reader :history

  def initialize(history)
    super()
    @history = history
  end

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class History
  attr_accessor :move_log

  def initialize
    @move_log = {}
  end

  def update(round_number, human, computer)
    self.move_log[round_number] = { 
      human.name => human.move.value, 
      computer.name => computer.move.value
    }
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
    @history = History.new
    @human = Human.new
    @computer = Computer.new(history)
    @round_number = 1
    @round_winner = nil
    @game_winner = nil 
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
    history.update(round_number, human, computer) 
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

  def play
    display_welcome_message
    prompt_to_continue
    loop do
      loop do
        system 'clear'
        display_score
        human.choose
        computer.choose
        display_moves
        set_round_winner
        display_round_winner
        update_stats
        #history.display
    
        break if game_won?
        reset_round_winner
        prompt_to_continue
      end
      sleep 2
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

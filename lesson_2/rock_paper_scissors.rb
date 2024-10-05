require 'pry'
=begin
# CURRENT: 


# NEXT:
  - Add clear screen
  - Start yml file for extracting strings

# MISC NOTES
 - Should displaying output be its own class?
 - Can add @game_number to RPSGame, edit history to show Game# and Round#, then delete #reset_history
 - Add "verb" move output after moves are chosen from http://www.samkass.com/theories/RPSSL.html
=end
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
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer, :round_number, :round_winner, :game_winner, 
                :history

  ONE_POINT = 1
  ZERO_POINTS = 0
  WINNING_SCORE = 5

  def initialize
    @human = Human.new
    @computer = Computer.new
    @round_number = 1
    @round_winner = nil
    @game_winner = nil
    @history = {}
  end

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

  def set_round_winner
    if human.move > computer.move
      self.round_winner = human
    elsif human.move < computer.move
      self.round_winner = computer
    end
  end

  def display_round_winner
    puts
    if round_winner
      puts "#{round_winner.name} won!"
    else
      puts "It's a tie! No points are awarded."
    end
  end

  def update_history
    history[round_number] = { 
      human.name => human.move.value, 
      computer.name => computer.move.value
    }
  end

  def update_score
    round_winner.score += ONE_POINT if round_winner
  end

  def update_round_number
    self.round_number += 1
  end

  def update_stats
    update_history
    update_score
    update_round_number unless game_won?
  end

  def display_score
    players = [human, computer]
    puts "ROUND #{round_number}".center(20, '-')
    players.each { |player| puts "#{player.name}: #{player.score}" }
    puts '-' * 20
    puts ''
  end

  def display_history
    puts ''
    puts 'GAME HISTORY:'
    history.each do |round, data|
      puts "Round #{round}:"
      data.each do |player, move|
        puts "#{player} - #{move}"
      end
      puts ''
    end
  end

  def display_game_winner
    puts "#{game_winner.name} has #{WINNING_SCORE} points and wins the game! Congrats!"
  end

  def display_ask_to_continue
    puts "Press ENTER to continue:"
    gets
  end

  def start_next_round
  end

  def reset_round_winner
    self.round_winner = nil
  end

  def reset_game_winner
    self.game_winner = nil
  end

  def reset_score
    players = [human, computer]
    players.each do |player|
      player.score = ZERO_POINTS
    end
  end

  def reset_round_number
    self.round_number = 1
  end

  def reset_history # If we add @game_number later, then don't have to reset history.
    self.history = {}
  end

  def reset_game
    reset_score
    reset_game_winner
    reset_round_number
    reset_history
  end

  def game_won?
    players = [human, computer]
    players.any? do |player|
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

    loop do
      display_ask_to_continue
      loop do
        system 'clear'
        display_score
        human.choose
        computer.choose
        display_moves
        set_round_winner
        display_round_winner
        update_stats
        #display_history
    
        break if game_won?
        reset_round_winner
        display_ask_to_continue
      end
      sleep 2
      system 'clear'
      display_score
      display_game_winner

      break unless play_again?
      reset_game
    end

    display_goodbye_message
  end
end

RPSGame.new.play

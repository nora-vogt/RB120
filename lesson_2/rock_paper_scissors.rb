require 'pry'
=begin
# Implementing score as a state of the Player class (that Human and Computer) will inherit.

Player
  - has a @score attribute, initialize to 0
    - can make the reader public

RPSGame
  - needs a @round_winner
    - maybe a set_round_winner that also updates score?
    - then display_score uses @round_winner
  - needs a @game_winner
  - update_score
  - reset_score (when game is won / before starting a new game)

# MISC NOTES
 - Can #set_round_winner be refactored to just use the round_winner setter?
 - Should displaying output be its own class?

# CURRENT: 
As long as the user doesn't quit, keep track of a history of moves by both the human and computer. What data structure will you reach for? Will you use a new class, or an existing class? What will the display output look like?

- add tracking of round, to be able to display move according to round
- Ask user before choosing a move if they would like to see the move history.

{ round 1: {human => rock, computer => scissors}, round 2: {...}}

{ human: {round1 => rock, round2 => spock}, computer: {round1 => scissors, round2 => lizard} }

<Human object, @name..., @history {round1 => rock, round => spock, ...}

To see all history
iterate through a hash of players [human, computer]
#{player} move list is:
Round 1 - Rock
Round 2 - Spock

#{computer} move list is:
Round 1 - 

OR: Game has a History
- store in a Hash
  - round number is the key, value is a hash {human: rock, computer: scissors}


# NEXT:
  - Add clear screen
  - Start yml file for extracting strings
  - Add press enter to start the next round
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
  
  def display_round_number
    puts "ROUND #{round_number}"
    puts ''
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

  def update_score
    round_winner.score += ONE_POINT if round_winner
  end

  def update_round_number
    self.round_number += 1
  end

  def update_stats
    update_score
    update_round_number
  end

  def display_score
    players = [human, computer]
    puts
    players.each do |player|
      score = player.score
      puts "#{player.name} has #{score} #{score == 1 ? 'point' : 'points'}."
    end
    puts
  end

  def display_game_winner
    puts ''
    puts "#{game_winner.name} has #{WINNING_SCORE} points and wins the game! Congrats!"
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

  def reset_game
    reset_score
    reset_game_winner
    reset_round_number
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
      loop do
        display_round_number
        human.choose
        computer.choose
        display_moves
        set_round_winner
        display_round_winner
        update_stats
        display_score
        reset_round_winner
        break if game_won?
      end

      display_game_winner
      break unless play_again?
      reset_game
    end

    display_goodbye_message
  end
end

RPSGame.new.play

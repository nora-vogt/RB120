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
=end

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
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
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp.downcase
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
  attr_accessor :human, :computer, :round_winner, :game_winner

  ONE_POINT = 1
  ZERO_POINTS = 0
  WINNING_SCORE = 5

  def initialize
    @human = Human.new
    @computer = Computer.new
    @round_winner = nil
    @game_winner = nil
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors! Goodbye!"
  end

  def display_moves
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

  def display_score
    players = [human, computer]
    puts
    players.each do |player|
      score = player.score
      puts "#{player.name} has #{score} #{score == 1 ? 'point' : 'points'}."
    end
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

  def reset_game
    reset_score
    reset_game_winner
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
        human.choose
        computer.choose
        display_moves
        set_round_winner
        display_round_winner
        update_score
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

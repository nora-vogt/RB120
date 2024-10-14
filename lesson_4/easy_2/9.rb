=begin
What would happen if we added a play method to the Bingo class, keeping in mind that there is already a method of this name in the Game class that the Bingo class inherits from.

The `play` method in the `Bingo` class would override the method in the `Game` superclass. When resolving a method name, Ruby will first look within the class of the calling object for that method.

To see that in action, we can define the `play` method in `Bingo` with a different value.
=end

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def play
    "Time to play Bingo!"
  end

  def rules_of_play
    #rules of play
  end
end

game = Bingo.new
p game.play # Time to play Bingo!
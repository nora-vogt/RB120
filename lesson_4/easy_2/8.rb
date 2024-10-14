# class Game
#   def play
#     "Start the game!"
#   end
# end

# class Bingo
#   def rules_of_play
#     #rules of play
#   end
# end

=begin
What can we add to the Bingo class to allow it to inherit the play method from the Game class?

We can add the `<` symbol and then the superclass name after the class name of `Bingo` to make `Bingo` inherit from `Game`. This makes all functionality within `Game` available within `Bingo.`
=end

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

game_of_bingo = Bingo.new
p game_of_bingo.play # => Start the game!
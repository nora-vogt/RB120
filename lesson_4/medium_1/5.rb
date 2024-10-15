=begin  
Write additional code for KrispyKreme such that the puts statements will work as specified below.
=end

class KrispyKreme
  attr_reader :filling_type, :glazing

  def initialize(filling_type, glazing)
    @filling_type = (filling_type ? filling_type : 'Plain')
    @glazing = glazing
  end

  def to_s
    glazing_info = glazing ? " with #{glazing}" : ''
    filling_type + glazing_info
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
  #=> "Plain"

puts donut2
 # => "Vanilla"

puts donut3
 # => "Plain with sugar"

puts donut4
 # => "Plain with chocolate sprinkles"

puts donut5
 # => "Custard with icing"

=begin
# LS Solution
  def to_s
    filling_string = @filling_type ? @filling_type : "Plain"
    glazing_string = @glazing ? " with #{@glazing}" : ''
    filling_string + glazing_string
  end

- same idea, but assigns in #to_s rather than in initialize. Which is better? Depends on use case. If we want donuts to default to "Plain" when no filling type is provided, mine is better. If we want to leave those values as `nil`, then this solution is better.
=end
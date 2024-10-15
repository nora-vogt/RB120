=begin  
What is used in this class but doesn't add any value?

The `explicit`` return in the `self.information` method? Because Ruby will automatically return the result of the last evaluated expression, which is the string.

LS Answer: the explicit `return`
=end

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green"
  end

end
=begin
How could you change the method name below so that the method name is more clear and less repetitive?

First, we can remove the `light` prefix - because an instance of the `Light` class is already going to be calling this method, so that is redundant information. Calling the method would look like: `light.light_status`. We could change the name to simply `status`.

OR, we could change the method name to `#to_s` - overriding the default `#to_s` method, because the intention of this method seems to be to format the information about the light instance in a usable format.
=end

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def status
    "I have a brightness level of #{brightness} and a color of #{color}"
  end

  def to_s
    "I have a brightness level of #{brightness} and a color of #{color}"
  end
end

light = Light.new('dim', 'red')
puts light.status
puts light
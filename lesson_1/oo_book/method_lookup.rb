module Walkable
  def walk
    "I'm walking."
  end
end

module Swimmable
  def swim
    "I'm swimming."
  end
end

module Climbable
  def climb
    "I'm climbing."
  end
end

class Animal
  include Walkable

  def speak
    "I'm an animal, and I speak!"
  end
end

class GoodDog < Animal
  include Swimmable
  include Climbable
end

puts "---Animal method lookup---"
puts Animal.ancestors
  # Animal    - checks current class
  # Walkable  - then module
  # Object
  # Kernel
  # BasicObject

fido = Animal.new
puts fido.speak # Ruby checks `Animal`, finds the `speak` method, executes it, stops looking

puts fido.walk
  # Ruby checks `Animal`, doesn't find method
  # Ruby checks `Walkable`, finds method, executes it, stops looking

# puts fido.swim # => NoMethodError
  # Ruby checks all classes and modules in the ancestors list, doesn't find a `swim` method, throws an error

puts "---GoodDog method lookup---"
puts GoodDog.ancestors
  # GoodDog   - checks current class
  # Climbable - checks last included module
  # Swimmable - checks first included module
  # Animal    - check superclass
  # Walkable  - checks module included in the superlclass
  # Object
  # Kernel
  # BasicObject
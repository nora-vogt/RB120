module Swimmable
  def swim
    "I'm swimming"
  end
end

class Animal; end

class Fish < Animal
  include Swimmable        # mixing in the Swimmable module
end

class Mammal < Animal
end

class Cat < Mammal
end

class Dog < Mammal
  include Swimmable       # mixing in the Swimmable module
end

sparky = Dog.new
neemo  = Fish.new
paws   = Cat.new

p sparky.swim   # "I'm swimming"
p neemo.swim    # "I'm swimming"
p paws.swim     # undefined method `swim' for #<Cat:0x00000001006d4ab0> (NoMethodError)

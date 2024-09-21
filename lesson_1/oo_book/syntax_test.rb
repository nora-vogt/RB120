class GoodDog
  @@number_of_dogs = 0
  attr_accessor :name
  def self.number_of_dogs
    puts "There are #{@@number_of_dogs} dogs."
  end

  def initialize(name)
    self.name = name
    @@number_of_dogs += 1
  end
end

max = GoodDog.new("Max")
p max #<GoodDog:0x0000000101df51b8 @name="Max">
cody = GoodDog.new("Cody")

# Either syntax works, because ::number_of_dogs is defined as a class method. But the first syntax is preferred. Modules and classes share this syntax for calling methods.
GoodDog.number_of_dogs
GoodDog::number_of_dogs
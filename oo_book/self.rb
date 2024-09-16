## self and Instance Methods

class GoodDog
  # p self  # outputs: GoodDog
  attr_accessor :name, :height, :weight
  @@dog_count = 0

  def self.dog_count #alias: GoodDog.dog_count
    "There are currently #{@@dog_count} dogs."
  end

  def initialize(name, height, weight)
    #p self # outputs the GoodDog instance #<GoodDog:0x0000000108834380>
    self.name   = name    # equivalent to @name = name
    self.height = height
    self.weight = weight
    @@dog_count += 1
  end

  def change_info(name, height, weight)
    self.name   = name    # equivalent to @name = name
    self.height = height
    self.weight = weight
  end

  def info
    "#{self.name} weighs #{self.weight} and is #{self.height} tall."
  end

  def what_is_self
    self
  end
end

#p self # outputs main (main scope)
sparky = GoodDog.new('Sparky', '12 inches', '10 lbs')
p sparky.what_is_self # Outputs the instance of GoodDog that the `sparky` local variable references.

# From within the class, when an instance method uses `self`, it references the calling object (the `sparky` object)
  # Within `change_info` method def, calling `self.name=` acts the same as calling `sparky.name=` from outside the class
  # In both cases, the caller is the `sparky` object, aka, the specific instance of the GoodDog class that has been instantiated and assigned to the variable `sparky`

puts GoodDog.dog_count

## self and Class Methods
class MyAwesomeClass
  def self.this_is_a_class_method
  end
end
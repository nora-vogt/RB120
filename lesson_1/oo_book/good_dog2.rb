## Class variable and class method
# class GoodDog
#   @@number_of_dogs = 0

#   def initialize
#     @@number_of_dogs += 1
#   end

#   def self.total_number_of_dogs
#     @@number_of_dogs
#   end
# end

# puts GoodDog.total_number_of_dogs

# dog1 = GoodDog.new
# dog2 = GoodDog.new

# puts GoodDog.total_number_of_dogs

## Constants
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(name, age)
    # have to use the self. syntax to invoke a setter method inside an instance method definition
    # otherwise, Ruby thinks we are reassigning a local variable
    self.name = name              # initializes @name
    self.age = age * DOG_YEARS    # initializes @age
  end

  def to_s  # custom implementation overrides the default to_s
    "This dog's name is #{name} and it is #{age} in dog years."
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky.age     # => 28
#puts sparky  # equivalent to puts sparky.to_s
  # outputs: This dog's name is Sparky and it is 28 in dog years.
"#{sparky}"  # String interpolation automatically calls #to_s


## Overriding #to_s
# class Foo
#   def to_s
#     42
#   end
# end

# foo = Foo.new
# puts foo             # prints: #<Foo:0x000000010a3c4078>
# puts "foo is #{foo}" # prints: foo is #<Foo:0x0000000100760ec0>

# Change 42 on line to a string, then it works as intended:
class Foo
  def to_s
    '42'
  end
end

foo = Foo.new
puts foo             # prints: 42
puts "foo is #{foo}" # prints: foo is 42
#puts Foo.ancestors

## Overriding #to_s only works for instances of the class where it is defined

class Bar
  attr_reader :xyz
  
  def initialize
    @xyz = { a: 1, b: 2 }
  end

  def to_s
    'I am a Bar object!'
  end
end

bar = Bar.new
puts bar        # Prints I am a Bar object!
puts bar.xyz     # Prints {:a=>1, :b=>2}
  # The value returned by `#xyz` is NOT a Bar object, so Bar#to_s does not apply to it.
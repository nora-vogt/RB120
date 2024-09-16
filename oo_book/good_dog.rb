# module Speak
#   def speak(sound)
#     puts sound
#   end
# end

# class GoodDog
#   include Speak
# end

# class HumanBeing
#   include Speak
# end

# sparky = GoodDog.new
# sparky.speak("Woof!!")

# fox_mulder = HumanBeing.new
# fox_mulder.speak("I want to believe.")

# puts "---GoodDog ancestors---"
# puts GoodDog.ancestors
# puts ''
# puts "---HumanBeing ancestors---"
# puts HumanBeing.ancestors

# class GoodDog
#   def initialize
#     puts "This object was initialized!"
#   end
# end

# # The initialize method gets called every time a new instance of GoodDog is created.
# # Instantiating a new object with the `new` method triggers the `initialize` method to be invoked.

# sparky = GoodDog.new

# class GoodDog
#   def initialize(name)
#     @name = name
#   end

#   def bark
#     puts "WOOF WOOF!!!"
#   end
# end

# sparky = GoodDog.new("Sparky")
# fido = GoodDog.new("Fido")

# sparky.bark
# fido.bark
# The string "Sparky" is passed to the `::new` method, which passes it to the `#initialize` method, where the string is assigned to the instance variable `@name`.

# All objects of the same class have the same behaviors. All `GoodDogs` can `speak`.
# Instance methods can be used to expose information about the state of the object, using instance variables:

# class GoodDog
#   # constructor
#   def initialize(name)
#     @name = name
#   end

#   # getter
#   def name  # This was renamed from "get_name"
#     @name
#   end

#   # setter
#   # def name=(n)  # This was renamed from "set_name="
#   #   @name = n
#   # end

#   # Setters always return value passed in as an argument
#   def name=(n)
#     @name = n
#     "Rufus" # value will be ignored
#   end

#   def speak
#     "#{@name} says arf!"
#   end
# end

# sparky = GoodDog.new("Sparky")
# puts sparky.speak # => Arf!
# puts sparky.name  # Sparky
# sparky.name = "Spartacus"  # returns "Spartacus, not "Rufus"
# puts sparky.name  # Spartacus

# Refactored, with `attr_accessor`

# class GoodDog
#   attr_accessor :name # replaces the setter/getter method defs

#   def initialize(name)
#     @name = name
#   end

#   def speak
#     "#{@name} says arf!"
#   end
# end

# sparky = GoodDog.new("Sparky")
# puts sparky.speak
# puts sparky.name # => Sparky
# p sparky.name = "Spartacus" # => "Spartacus"
# puts sparky.name # Spartacus


# Using accessor methods to reference instance variables, instead of doing so directly

# class GoodDog
#   attr_accessor :name

#   def initialize(name)
#     @name = name
#   end

#   def speak
#     "#{name} says arf!"  # this is invoking the `name` accessor (getter) method
#   end
# end

# sparky = GoodDog.new("Sparky")
# puts sparky.speak # => Sparky says arf!


# changing several states at once
class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def speak
    "#{name} says arf!"  # this is invoking the `name` accessor (getter) method
  end

  # def change_info(n, h, w) # This works to change info
  #   @name = n
  #   @height = h
  #   @weight = w
  # end

  # def change_info(n, h, w) # This doesn't work!
  #   name = n
  #   height = h
  #   weight = w
  # end

  def change_info(n, h, w) # have to use `self` syntax to distinguish from local variable
    self.name = n
    self.height = h
    self.weight = w
  end

  # def info
  #   "#{name} weighs #{weight} and is #{height} tall."
  # end

  def info # optional to use the `self` syntax for getter methods
    "#{self.name} weighs #{self.weight} and is #{self.height} tall."
  end

  def some_method
    self.info
  end

  def self.what_am_i # Class method definition
    "I'm a GoodDog class!"
  end
end

sparky = GoodDog.new('Sparky', '12 inches', '10 lbs')
puts sparky.info # Sparky weighs 10 lbs and is 12 inches tall.

sparky.change_info('Spartacus', '36 inches', '80 lbs') # returns "80 lbs", the return value of the last method invoked within the `change_info` method
puts sparky.info # Spartacus weighs 80 lbs and is 36 inches tall.

puts GoodDog.what_am_i


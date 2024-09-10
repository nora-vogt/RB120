=begin
# How do we create an object in Ruby? Give an example of the creation of an object.

Objects can be created by first defining a Class, and then invoking the ::new method on that class.
  LS terms: We create an object by defining a Class, and then instantiating an instance of the class with the `new` method. 
=end
module Identification
  def identify
    "FEDERAL AGENT!!"
  end
end

class FbiAgents
  include Identification
end

dana_scully = FbiAgents.new
fox_mulder = FbiAgents.new
puts "I'm a #{dana_scully.identify}"

# or
string = String.new
array = Array.new(3, 'hi')

p dana_scully
p array

=begin
What is a module? What is its purpose? How do we use them with our classes? Create a module for the class you created in exercise 1 and include it properly.

A module defines behaviors that can be used in multiple classes. In order to use them in classes, we mix in the module using the `include` method within the class.

LS Answer: A module groups reusable code into one place. We use modules in our classes by using the `include` method and passing the module name as an argument.
=end

module Weather
  def rain
    puts "It's raining."
  end

  def sunny
    puts "It's sunny."
  end
end

class Garden
  include Weather
end

class Hike
  include Weather
end

my_garden = Garden.new
print "Let's check the weather in the garden: "
my_garden.rain

new_hike = Hike.new
print "What is the forecast for the hike? "
new_hike.sunny

# Namespacing - used to organize code. Can define classes inside modules. Makes it clear we're talking about a class within the context of the module.

module Careers
  class Dancer
  end

  class CatSnuggler
  end
end

# how to instantiate an instance of a class inside a module
new_job = Careers::CatSnuggler.new

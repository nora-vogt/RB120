=begin
# Exercise 1
Create a class called MyCar. When you initialize a new instance or object of the class, allow the user to define some instance variables that tell us the year, color, and model of the car. Create an instance variable that is set to 0 during instantiation of the object to track the current current_speed of the car as well. Create instance methods that allow the car to current_speed up, brake, and shut the car off.

# Exercise 2
Add an accessor method to your MyCar class to change and view the color of your car. Then add an accessor method that allows you to view, but not modify, the year of your car.

# Exercise 3
You want to create a nice interface that allows you to accurately describe the action you want your program to perform. Create a method called spray_paint that can be called on an object and will modify the color of the car.
=end

class MyCar
  attr_accessor :color
  attr_reader :year
  # We don't want to add an attr_accessor :current_speed here, because we don't want the user to manually set the current speed
  # This means we will reassign the @current_speed instance variable itself, rather than use a setter method (we don't be defining a setter method because we don't want the user to manually set the speed.)

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
  end

  def spray_paint(color)
    self.color = color  # initially had @color = color; but we want to avoid referencing the instance variable directly when possible. 
      # color = color doesn't work, as that appears we are reassigning the local variable `color` to the current value of `color`
      # Need to use the `self.` syntax to reference the color setter method (color=)
    puts "Your new #{color} paint job looks great!"
  end

  def speed_up(number)
    @current_speed += number
    puts "You push the gas and accelerate by #{number} mph."
  end

  def brake(number)
    @current_speed -= number
    puts "You push the break and decelerate by #{number} mph."
  end

  def current_speed # Is this considered a getter method since it outputs info, instead of just returing the value of the @current_speed instance var?
    puts "You are now going #{@current_speed} mph."
  end

  def shut_down
    @current_speed = 0
    puts "Let's park this bad boy!"
  end
end

my_subaru = MyCar.new(2019, "White", "Crosstrek")
my_subaru.current_speed         # current_speed is initialized to 0

my_subaru.speed_up(50)          # increment current_speed by arg
my_subaru.current_speed
my_subaru.brake(15)             # decrements current_speed by arg
my_subaru.current_speed
my_subaru.shut_down 

puts my_subaru.color
my_subaru.color = ("Blue")
puts my_subaru.color
puts my_subaru.year
# my_subaru.year = 2000 # raises a NoMethodError becuase we don't have a setter method

my_subaru.spray_paint("red")
puts my_subaru.color
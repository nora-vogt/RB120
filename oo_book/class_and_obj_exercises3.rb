=begin
## Part 1 Exercises:
# Exercise 1
Create a class called MyCar. When you initialize a new instance or object of the class, allow the user to define some instance variables that tell us the year, color, and model of the car. Create an instance variable that is set to 0 during instantiation of the object to track the current current_speed of the car as well. Create instance methods that allow the car to current_speed up, brake, and shut the car off.

# Exercise 2
Add an accessor method to your MyCar class to change and view the color of your car. Then add an accessor method that allows you to view, but not modify, the year of your car.

# Exercise 3
You want to create a nice interface that allows you to accurately describe the action you want your program to perform. Create a method called spray_paint that can be called on an object and will modify the color of the car.

## Part 2 Exercises:
# Exercise 4
Add a class method to your MyCar class that calculates the gas mileage (i.e. miles per gallon) of any car.
  - miles per gallon: divide # of miles drive by number of gallons


## Part 3 Exercises:
1. Create a superclass called Vehicle for your MyCar class to inherit from and move the behavior that isn't specific to the MyCar class to the superclass. Create a constant in your MyCar class that stores information about the vehicle that makes it different from other types of Vehicles.

Then create a new class called MyTruck that inherits from your superclass that also has a constant defined that separates it from the MyCar class in some way.

2. Add a class variable to your superclass that can keep track of the number of objects created that inherit from the superclass. Create a method to print out the value of this class variable as well.

3. Create a module that you can mix in to ONE of your subclasses that describes a behavior unique to that subclass.

4. Print to the screen your method lookup for the classes that you have created.

5. Move all of the methods from the MyCar class that also pertain to the MyTruck class into the Vehicle class. Make sure that all of your previous method calls are working when you are finished. (Already did in problem 1.)

6. Write a method called age that calls a private method to calculate the age of the vehicle. Make sure the private method is not available from outside of the class. You'll need to use Ruby's built-in Time class to help.
  # Originally referenced the instance variable `@year``, but because there is an `attr_reader`` for `@year`` (meaning there is a getter method), we should use `self.year` to get the year of the current instance.
=end
module Towable
  @attached = false

  def attach_equipment
    @attached = true
    "The towing equipment is attached."
  end

  def equipment_attached?
    @attached
  end

  def towing_status
    if equipment_attached?
      puts "Ready to tow!"
    else
      puts "Please attach the towing equipment."
    end
  end

  def tow(equipment)
    if equipment_attached?
      "Now towing a #{equipment}"
    else
      "Please attach the equipment first."
    end
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model
  @@number_of_vehicles = 0

  def self.miles_per_gallon(miles, gallons)  # Class method
    puts "#{miles / gallons} miles per gallon of gas."
  end

  def self.number_of_vehicles
    "There are currently #{@@number_of_vehicles} Vehicles."
  end

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def spray_paint(color)
    self.color = color 
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

  def current_speed
    puts "You are now going #{@current_speed} mph."
  end

  def shut_down
    @current_speed = 0
    puts "Let's park this bad boy!"
  end

  def age
    puts "This #{model} is #{calculate_age} years old."
  end

  private

  def calculate_age
    Time.now.year - year # or can use self.year
  end
end

class MyCar < Vehicle
  FUEL_TYPE = "gas"

  def to_s
    "This car is a #{color} #{year} #{model}."
  end
end

class MyTruck < Vehicle
  include Towable

  FUEL_TYPE = "diesel"

  def to_s
    "This truck is a #{color} #{year} #{model}."
  end
end

subaru = MyCar.new(2019, "White", "Crosstrek")
tacoma = MyTruck.new(1970, 'silver', 'Tacoma')

puts subaru # This car is a White 2019 Crosstrek.
puts tacoma # This truck is a silver 1970 Tacoma.
puts Vehicle.number_of_vehicles

p tacoma.tow("boat") # => "Please attach equipment first."
tacoma.attach_equipment
tacoma.towing_status # => "Ready to tow!"
p tacoma.tow("boat") # => "Now towing a boat."

puts "---Vehicle method lookup---"
puts Vehicle.ancestors
  # Vehicle
  # Object
  # Kernel 
  # BasicObject

puts "---MyCar method lookup---"
puts MyCar.ancestors
  # MyCar
  # Vehicle
  # Object
  # Kernel
  # BasicObject

puts "---MyTruck method lookup---"
puts MyTruck.ancestors
  # MyTruck
  # Towable
  # Vehicle
  # Object
  # Kernel
  # BasicObject

subaru.age
tacoma.age

=begin
7. Create a class 'Student' with attributes name and grade. Do NOT make the grade getter public, so joe.grade will raise an error. Create a better_grade_than? method, that you can call like so...

puts "Well done!" if joe.better_grade_than?(bob)
=end

class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(name, grade)
    self.name = name
    self.grade = grade
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  attr_reader :grade
end

# LS Solution
# doesn't use any `attr` methods, just initializes the instance vars in the `initialize` method and manually defines the `grade` getter under the `protected` section.
# class Student
#   def initialize(name, grade)
#     @name = name
#     @grade = grade
#   end

#   def better_grade_than?(other_student)
#     grade > other_student.grade
#   end

#   protected

#   def grade
#     @grade
#   end
# end

joe = Student.new('Joe', 97)
bobby = Student.new('Bobby', 88)

puts "Well Done!" if joe.better_grade_than?(bobby)

=begin
8. Given the following code...

bob = Person.new
bob.hi

And the corresponding error message...

NoMethodError: private method `hi' called for #<Person:0x007ff61dbb79f0>
from (irb):8
from /usr/local/rvm/rubies/ruby-2.0.0-rc2/bin/irb:16:in `<main>'

What is the problem and how would you go about fixing it?

This code is attempting to invoke the `Person` class's `private`` instance method `#hi`. `private` methods cannot be called by instances of the class, they can only be invoked within other method definitions within the class (but not directly by an instance). To fix this, we need to either change the type of method from `private` to `protected`, or create another instance method within the class that can invoke the `#hi` method:

# LS language: "`hi` is a private method, therefore it is unavailable to the (calling) object."
=end

class Person
  def initialize(name)
    @name = name
  end

  def say_hi   # the private hi method can be called within another instance method within the class
    puts hi
  end

  private     # or could change this to `protected`, then wouldn't need the `say_hi` method

  def hi
    "Hi from #{@name}."
  end
end

bob = Person.new('Bob')
bob.say_hi
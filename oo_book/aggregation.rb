class Passenger
end

class Car
  def initialize(passengers)
    @passengers = passengers # Passengers are given to the Car at creation
  end
end

# Passengers can exist without Car
passengers = [Passenger.new, Passenger.new]
my_car = Car.new(passengers)

p passengers
p my_car

# A `Car` instance has an `Array` of `Passenger` objects
# `Passenger` objects can also exist independently of the `Car` instance
  # They can be passed to the `Car` object when its instantiated
  # Or at any time before that `Car` instance is destroyed
# The `Passenger` objects will continue to live after the `Car` object is destroyed

# Initialize test
#subaru = Car.initialize # Get a NoMethodError - private method `initialize' called for Car:Class
subaru = Car.new(passengers) # the Car must be instantiated with a Passenger, due to the parameter defined as part of `initialize` method definition

p subaru
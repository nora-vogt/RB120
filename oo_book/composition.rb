class Engine
  def start
    puts "Engine starting..."
  end
end

class Car
  def initialize
    @engine = Engine.new # Engine instance is created when Car is created
  end

  def start
    @engine.start
  end
end

my_car = Car.new
my_car.start # Engine is an integral part of car
  # outputs: Engine starting...

=begin
`Car` has an `Engine` and
`Car` instances contain an `Engine` object
When `Car` is instantiated, `Engine` is also instantiated
When the `Car` object (instance) is destroyed, the composed `Engine` object is also destroyed.
=end

new_engine = Engine.new
p new_engine
new_engine.start # This will still output "Engine starting..."

=begin
I don't see the difference yet between composition and aggregation. Here, an `Engine` instance can be created independently from `Car`. We can even `start` the `Engine` without a car.

Maybe the difference is: The `Car` class's `initialize` method does not take any arguments. We cannot pass a pre-existing `Engine` instance to that method as an argument. Instead, invoking `initialize` creates a new `Engine` (so `Engine` is created within the `Car`) class.

VERSUS: In Aggregation, the `Passenger` objects are NOT instantiated within the `Car` class's `initialize` method. Instead, they are instantiated separately, and then passed in as arguments to `Car.new` (`initialize`)
=end
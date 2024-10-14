=begin
If we have a Car class and a Truck class and we want to be able to go_fast, how can we add the ability for them to go_fast using the module Speed? How can you check if your Car or Truck can now go fast?

To give instances of `Car` and `Truck` the ability to `go_fast`, we need to mix in the module `Speed` to each class by adding `include Speed` to the class definition. This gives both classes access to all methods defined in `Speed`.

This is an example of polymorphism: instances of different classes are responding to the same `#go_fast` method invocation. Specifically, this is polymorphism through mixin modules.

To check if a `Car` or `Truck` can `go_fast`, we need to first create an instance of each class, and then use those instances to invoke the `#go_fast` method.
=end

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed

  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed

  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

camry = Car.new
toyota = Truck.new

[camry, toyota].each do |vehicle|
  vehicle.go_fast
end
# outputs:
# I am a Car and going super fast!
# I am a Truck and going super fast!
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

=begin
In the last question we had a module called Speed which contained a go_fast method. We included this module in the Car class as shown below.

When we called the go_fast method from an instance of the Car class (as shown below) you might have noticed that the string printed when we go fast includes the name of the type of vehicle we are using. How is this done?
=end

small_car = Car.new
small_car.go_fast
I am a Car and going super fast!

=begin
The type of vehicle is included in the string due to the `#{self.class}` interpolation in the string in the `go_fast` method definition. `self` returns the object that is invoking the `go_fast` method, in this case, an instance of the `Car` class. Then the `#class` method is chained to that returned value, returning the class to which that instance belongs - `Car`. Thus, `Car` is interpolated into the string. 


LS NOTES:
We use self.class in the method and this works the following way:

1. `self` refers to the object referenced by `small_car`. In this case, that's a `Car` object.
2. We ask `self` to tell us its class with `.class`. It tells us.
3. We don't need to use `to_s` here because it is inside of a `String` and is interpolated, which means it will take care of the `to_s` for us.
=end
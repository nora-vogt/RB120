class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

=begin
We have an Oracle class and a RoadTrip class that inherits from the Oracle class.

What is the result of the following:
=end

trip = RoadTrip.new
p trip.predict_the_future

=begin
In this code, the `choices` method in `Oracle` is overridden in its subclass `RoadTrip`.

`trip.predict_the_future` will return a string "You will <something>", with `<something>` being one of the three strings listed in the array in the `RoadTrip#choices` method. One of the strings will be randomly returned by `choices.sample`.

For example: `"You will romp in Rome"``

The key is that the strings in `RoadTrip#choices` will be used, not the strings in `Oracle#choices`, because of the subclass overriding the method.

LS NOTES:
- Every time Ruby tries to resolve a method name, it will start with the methods defined on the class you are calling.
- When resolving `choices.sample`, Ruby will first look in the `RoadTrip` class for the method, find it, and use one of those values.
=end
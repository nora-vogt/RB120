=begin
Given the following class, Create a sub-class from Dog called Bulldog overriding the swim method to return "can't swim!"

Instances of a subclass can both override and inherit methods from the superclass.
=end

class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

teddy = Dog.new
puts teddy.speak  # => "bark!"
puts teddy.swim   # => "swimming!"

jessica = Bulldog.new
puts jessica.speak  # => "bark!"
puts jessica.swim   # => "can't swim!"
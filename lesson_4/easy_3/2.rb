class Greeting
  def greet(message)
    puts message
  end
  
  def self.hi
    greeting = Greeting.new
    greeting.greet("Hello!")
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end

  # def self.hi
  #   greeting = Greeting.new
  #   greeting.greet("hello")
  # end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

=begin
If we call Hello.hi we get an error message. How would you fix this?

We could either:
1. Change the current `hi` instance method defined in `Hello` to be a class method by changing its name to `self.hi` -- this actually wouldn't work. Due to the scope change, `greet` on line 9 now references a class method, and the `Hello` class does not have a class method calle `greet` defined!

2. Define a separate class method called `self.hi` in the `Hello class`

3. Define a `self.hi` method in `Greeting`, which will be available in `Hello` because it subclasses from `Greeting`.
=end

Hello.hi
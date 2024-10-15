class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

=begin
# What happens in each of the following cases:
=end

# Case 1
# hello = Hello.new
# hello.hi # Outputs "Hello"

# Case 2
# hello = Hello.new
# hello.bye # Raises a NoMethodError - there is no #bye method defined for the Hello class or its superclass, Greeting.

# Case 3
# hello = Hello.new
# hello.greet  # Raises an ArugumentError - the #greet method is defined with one parameter, so need to pass in one argument when invoking.

# # Case 4
# hello = Hello.new
# hello.greet("Goodbye") # Outputs "Goodbye"

# # Case 5
Hello.hi  # Raises a NoMethodError. The `#hi` method defined in `Hello` is an instance method, which can only be invoked on instances of the class. Here, the class attempts to call the method. We would need a method called `self.hi`.
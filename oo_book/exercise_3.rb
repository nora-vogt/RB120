class Person
  attr_reader :name
  #attr_accessor :name    # Fix 1, comment out line 2
  #attr_writer :name ## also works but then can't access the name

  def initialize(name)
    @name = name
  end

  def name=(name)         # Fix 2, define the instance setter method
    @name = name
  end 
end

bob = Person.new("Steve")
bob.name = "Bob"
p bob.name

=begin
# https://launchschool.com/books/oo_ruby/read/classes_and_objects_part2
We get the following error when running the code below. Why do we get this error, and how do we fix it?

test.rb:9:in `<main>': undefined method `name=' for
  #<Person:0x007fef41838a28 @name="Steve"> (NoMethodError)

On line 9, we attempt to call the `#name=` method on the instance of the `Person` class that is referenced by the local variable `bob`. This is a setter method. However, we have not defined this setter method within our `Person` class. On line 2, we used the `attr_reader` method to create only a *getter* method for `name`, which allows us to retrieve the value of the instance variable `@name`, but does not provide a way to set the value.

To fix this, two options:
  1. Change `attr_reader` on line 2 to `attr_accessor`, which creates both setter and getter methods
  2. Define a `name=` setter method within the class definition
=end
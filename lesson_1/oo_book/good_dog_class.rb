## Inheritance
# class Animal                # superclass
#   def speak
#     "Hello!"
#   end
# end

# class GoodDog < Animal       # GoodDog is a subclass
#   attr_accessor :name

#   def initialize(n)
#     self.name = n
#   end

#   def speak                 # GoodDog#speak overrides the inherited speak method
#     "#{self.name} says arf!"
#   end
# end

# class Cat < Animal
# end

# sparky = GoodDog.new("Sparky")
# paws = Cat.new
# puts sparky.speak
# puts paws.speak

=begin
The `speak` method gets overridden here because Ruby checks the object's class (GoodDog) first for the method before it looks in the superclass.
=end


## Using `super`
# class Animal
#   def speak
#     "Hello!"
#   end
# end

# class GoodDog < Animal
#   def speak
#     super + " from GoodDog class"
#   end
# end

# sparky = GoodDog.new
# p sparky.speak       # => "Hello! from GoodDog class"
=begin
What's happening here.
1. We define the `Animal` class
  a. `Animal` has a `speak` method defined
2. We define the `GoodDog` class and make it inherit from `Animal` (`GoodDog` subclasses `Animal`)
3. `GoodDog` has its own `speak` method defined
  a. this overrides the inherited `Animal#speak` method
4. But, `super` is invoked within the `GoodDog` `speak` method definition
  a. This invokes the `speak` method from the superclass (`Animal`)
5. The string " from GoodDog class" is appended to the string returned by `super`, the new string forms the return value of the `GoodDog` `speak` method
=end 

## Using `super` with `initialize`
class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class GoodDog < Animal
  def initialize(color)
    super
    @color = color
  end
end

bruno = GoodDog.new("brown")
p bruno    #=> #<GoodDog:0x000000010b624bf0 @name="brown", @color="brown">

=begin
What's happening here:
1. `super` forwards the argument that was passed into the method where `super` is invoked
  a. in this case, `super` passes the `color` that was passed to the `GoodDog#initialize` method as an argument
2. `super` passes it back to the `initialize` method that is defined in the `Animal` superclass and invokes that initialize method
  b. this is how "brown" ends up getting assigned to the @name instance variable
3. Finally, the subclass's (`GoodDog`) `initialize` method continues to set the `@color` instance variable
=end

## Calling `super` with specific arguments
# class BadDog < Animal
#   def initialize(age, name)
#     super
#     @age = age
#   end
# end

# bear = BadDog.new(2, "bear")
# p bear #<BadDog:0x000000010e0259e0 @name="bear", @age=2>

=begin
1. A specific argument is passed to `super` within the `BadDog#initialize` method
  a. If we just invoke `super` and don't pass a method on line 91, an ArgumentError is raised, because `GoodDog#initialize`'s two args will be automatically passed to `super`
  b. Since `BadDog#initialize` accepts two arguments, but `Animal#initialize` only accepts one argument, we can't pass both args to `super`. We must explicitly pass one.
  c. BUT! If we call `super()` with parentheses, NO ARGUMENTS will be passed. This also raises an argument error as defined (`Animal#initialize` expects one argument), but see below:
=end

class Animal
  def initialize
  end
end

class Bear < Animal
  def initialize(color)
    super()             # calling `super` with parentheses will pass zero arguments to `super`, whereas if we called without parentheses, it would automatically pass one arg, `color`, raising an ArgumentError.
    @color = color
  end
end

bear = Bear.new("black")
p bear  # #<Bear:0x000000010ac23840 @color="black">
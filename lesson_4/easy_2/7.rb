# class Cat
#   @@cats_count = 0

#   def initialize(type)
#     @type = type
#     @age  = 0
#     @@cats_count += 1
#   end

#   def self.cats_count
#     @@cats_count
#   end
# end

=begin
Explain what the @@cats_count variable does and how it works. What code would you need to write to test your theory?

`@@cats_count` is a class variable. It keeps track of how many instances of the `Cat` class have been created. Class variables are denoted by `@@` at the start of the variable name. When a class variable is created, there is only one copy of that variable, and it is available both to the class and to instances of the class.

To test this, we already have a class method that exposes the value of `@@cats_count`. We can create new instances of `Cat`, check the value of the class var again, and see that it has been successfully incremented by the `initialize` method with each new instance.

We can also add an instance method that exposes the value of `@@cats_count`.
=end

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end

  def cats_count
    puts "There are #{@@cats_count} cats."
  end
end

p Cat.cats_count # => 0
fluffy = Cat.new('tabby')
francis = Cat.new('nebelung')

p Cat.cats_count # => 2
francis.cats_count # => There are 2 cats.
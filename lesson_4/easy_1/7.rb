class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

=begin
You can see in the make_one_year_older method we have used self. What does self refer to here?

`make_one_year_older` is an instance method. `self` refers to the instance of `Cat` that calls the method.

LS Notes:
- instance methods can only be called on instances of the class
=end
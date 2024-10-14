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
end

=begin
In the name of the cats_count method we have used self. What does self refer to in this context?

When `self` is used in the name of a method within a class, it indicates that the method is a class method. `self` refers to the class - in this case, `Cat`.

LS Notes:
You can call `Cat.cats_count`
=end
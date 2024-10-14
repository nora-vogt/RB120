class BeesWax
  def initialize(type)
    @type = type
  end

  def type
    @type
  end

  def type=(t)
    @type = t
  end

  def describe_type
    puts "I am a #{@type} of Bees Wax"
  end
end

=begin
What could you add to this class to simplify it and remove two methods from the class definition while still maintaining the same functionality?

Adding an `attr_accessor` for `@type` will simplify the class. `attr_accessor` creates a setter `type=` and a getter `type` for any instance variable that is passed to the method as a symbol `:type`.

We can also change the reference from `@type` in the string in `describe_type` to referencing the getter `type`, which will return the valye of `@type`. 

LS Notes:
Standard practice to refer to instance variables inside the class without the `@` if the getter method is available.
=end

class BeesWax
  attr_accessor :type
  def initialize(type)
    @type = type
  end

  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end

puts golden = BeesWax.new('comb')

golden.describe_type
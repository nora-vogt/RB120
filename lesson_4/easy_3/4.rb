=begin
Given the class below, if we created a new instance of the class and then called to_s on that instance we would get something like "#<Cat:0x007ff39b356d30>"

How could we go about changing the to_s output on this method to look like this: I am a tabby cat? (this is assuming that "tabby" is the type we passed in during initialization).

To get the desired output, we need to override the `#to_s` method within the `Cat` class definition:
=end

class Cat
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{type} cat!"
  end
end

felix = Cat.new('tabby')
puts felix # I am a tabby cat!

=begin
# LS Notes: in this case, it would actually be more specific to write a `display_type` method because that's what this code is accomplishing:
=end

class Cat
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def display_type
    puts "I am a #{type} cat"
  end
end
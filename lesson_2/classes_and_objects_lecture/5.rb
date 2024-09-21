=begin
Continuing with our Person class definition, what does the below code print out?

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"
=end

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name=(name)
    parse_full_name(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def same_name?(other_person)
    self.name == other_person.name
  end

  def to_s
    name
  end

  private

  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}" # The person's name is: #<Person:0x000000010fbf6480>

# This code will interpolate the entire `Person` object that `bob` references, so we will see the object's identifier (is that the term?). The attributes WON'T be printed too, only if we inspect the whole object with `#p`.
# Put another way: this code will output a string representation of the `Person` object that `bob` references.

p bob # #<Person:0x000000010e7f6430 @first_name="Robert", @last_name="Smith">

# Add a custom #to_s method, and now the code will output "This person's name is Bob."
  # This happens because string interpolation automatically calls #to_s on the interpolated object.
  # Now, when #to_s is called, the `name` getter is invoked, returning bob's name.
puts "The person's name is: #{bob}" # The person's name is: Robert Smith
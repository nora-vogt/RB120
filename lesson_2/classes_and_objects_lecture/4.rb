=begin
Using the class definition from step #3, let's create a few more people -- that is, Person objects.

If we're trying to determine whether the two objects contain the same name, how can we compare the two objects?
  One solution is to create an instance method, `same_name?` that takes the name of the other person as an argument. Within that instance method, we can compare the values of `@name` for both instances using the getter method.

  Or, outside of the class, we can compare bob.name == rob.name
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

  private

  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p bob.name == rob.name # true
p bob.same_name?(rob)  # true
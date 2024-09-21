## private methods
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(name, age)
    self.name = name
    self.age = age
  end

  def public_disclosure
    "#{self.name}'s age in human years is #{human_years}."
  end

  private

  def human_years
    age * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
#p sparky.human_years # Raises error: private method `human_years' called for #<GoodDog:0x0000000109c15098 @name="Sparky", @age=4> (NoMethodError)

puts sparky.public_disclosure # Sparky's age in human years is 28.
  # We cannot use self.human_years, because that is equivalent to sparky.human_years, which is not allowed with private methods


## protected methods
class Person
  def initialize(age)
    @age = age
  end

  def older?(other_person)
    age > other_person.age   # an instance of Person (other_person) is directly invoking the protected #age method
  end

  protected

  attr_reader :age
end

ruby = Person.new(64)
scully = Person.new(42)

ruby.older?(scully) # => true
scully.older?(ruby) # => false

#ruby.age # protected method `age' called for #<Person:0x000000010d733d50 @age=64> (NoMethodError)


## Putting them both together
class Cat
  def initialize(name)
    @name = name
  end

  def reveal_hiding_place
    puts favorite_hiding_place
  end

  def eat
    puts "#{@name} eats #{self.favorite_snack}" # protected, so the current instance of the class (self) can invoke the method
  end

  protected
  def favorite_snack
    "dehydrated chicken."
  end

  private
  def favorite_hiding_place
    "My favorite hiding place is under the bed."
  end
end

sylvie = Cat.new("Sylvie")
#sylvie.favorite_hiding_place private method `favorite_hiding_place' called for #<Cat:0x0000000105722cb0 @name="Sylvie"> (NoMethodError)
sylvie.reveal_hiding_place # My favorite hiding place is under the bed.


#sylvie.favorite_snack # protected method `favorite_snack' called for #<Cat:0x00000001079c2900 @name="Sylvie"> (NoMethodError)

sylvie.eat # Sylvie eats dehydrated chicken.
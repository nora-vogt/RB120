class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

=begin
When objects are created they are a separate realization of a particular class.

Given the class above, how do we create two different instances of this class with separate names and ages?

We need to invoke the `::new` method twice on the `AngryCat` class to create two new instances of `AngryCat`. Each time, we pass the constructor two values - an age and a name. These values will be assigned to the new object's instance variables.
=end

cat1 = AngryCat.new(6, 'Ruby')
cat2 = AngryCat.new(10, 'Zed')

cat1.name # Ruby
cat2.name # Zed
cat2.hiss # Hisssss!!!
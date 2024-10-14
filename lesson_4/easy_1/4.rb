=begin
If we have a class AngryCat how do we create a new instance of this class?

The AngryCat class might look something like this:
=end

class AngryCat
  def hiss
    puts "Hisssss!!!"
  end
end

=begin
To create a new instance of `AngryCat`, we invoke the `::new` class method on the class: `AngryCat.new`. `::new` instantiates and returns a new object of the calling class.
=end

p AngryCat.new # preferred syntax
p AngryCat::new
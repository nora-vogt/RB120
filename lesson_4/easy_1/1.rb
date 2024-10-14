=begin
All of the listed examples are objects. Their class can be determined by invoking the `#class` method on each object.

LS Note: All values in Ruby are objects.
=end

p true.class                     # => TrueClass
p "hello".class                  # => String
p [1, 2, 3, "happy days"].class  # => Array
p 142.class                      # =>Integer
module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

=begin
How do you find where Ruby will look for a method when that method is called? How can you find an object's ancestors?
  Ruby will follow the method lookup chain when resolving a method name. To find out an object's ancestors, which reflects the chain, call the `::ancestors` method on the class.

  General rules: the current class -> modules, from last listed to first -> any superclass -> repeat in the superclass, etc.


What is the lookup chain for Orange and HotSauce?

Orange:
  Orange
  Taste
  Object
  Kernel
  BasicObject

HotSauce
  HotSauce
  Taste
  Object
  Kernel
  BasicObject
=end

p Orange.ancestors
p HotSauce.ancestors
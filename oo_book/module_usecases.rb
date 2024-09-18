## Namespacing - grouping related classes together within a module
module Mammal
  class Dog
    def speak(sound)
      p "#{sound}"
    end
  end

  class Cat
    def say_name(name)
      p "#{name}"
    end
  end
end

# Call classes in a module by appending class name to the module name with two colons ::

buddy = Mammal::Dog.new
sylvie = Mammal::Cat.new
buddy.speak('Arf!')         # => "Arf!"
sylvie.say_name('Sylvie')   # => "Sylvie"


## Module as a container for methods - "Module methods"
module Conversions
  def self.farenheit_to_celsius(num)
    (num - 32) * 5 / 9
  end
end

# In this case, the `self` syntax means this is a module method
# So, the module itself is the caller
value = Conversions.farenheit_to_celsius(32)
p value # 0

# Can also use this syntax, but not preferred:
value2 = Conversions::farenheit_to_celsius(70)
p value2 #21
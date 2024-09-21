class Parent
  def say_hi
    p "Hi from Parent."
  end
end

class Child < Parent
  def say_hi
    p "Hi from Child."
  end

  # def send
  #   p "send from Child..."
  # end

  def instance_of?
    p "I am a fake instance."
  end
end

p Parent.superclass # => Object

child = Child.new
child.say_hi       # "Hi from Child."


## Accidental overridign of Object#send
 # Object#send provides a way to call a method by passing #send the method name as a symbol or a string

son = Child.new
son.send :say_hi   # "Hi from Child."

lad = Child.new
lad.send :say_hi # wrong number of arguments (given 1, expected 0) (ArgumentError)
  # The error occurs beause Child#send overrides Object#send, and Child#send doesn't accept any arguments.

c = Child.new
# p c.instance_of? Child # => true
# p c.instance_of? Parent # => false

heir = Child.new
heir.instance_of? Child # wrong number of arguments (given 1, expected 0) (ArgumentError)

# Snippet 1
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

# Snippet 2
class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    self.template
  end
end

=begin
If we have these two methods in the Computer class,
What is the difference in the way the code works?

The only difference in the code is within the `show_template` method. Snippet 1 uses the getter method created by the `attr_accessor` for `@template`, calling the `template` method to return the value of `@template`.

Snippet 2 also uses the `template` getter method, but calls the method with `self`. `self` in this instance method refers to the instance that is calling the method, so this is an alternate syntax for `template` with the same result. In both cases, the instance invokes the `template` method. 

It is preferred not to explicitly call instance methods with `self` unless necessary for some reason, so Snippet 1 is better.
=end
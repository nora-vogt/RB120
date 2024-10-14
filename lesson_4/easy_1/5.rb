class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

=begin
Which of these two classes would create objects that would have an instance variable and how do you know?

Only the `Pizza` class will create objects with an instance variable as part of their state. A class's `initialize` method is automaticaly invoked by the `::new` method when creating a new instance. In the `Pizza` class, `initialize` initializes the `@name` instance variable and assigns it to the `name` passed in as an argument. This makes each instance of `Pizza` have `@name` as part of its state.

In the `Fruit` class, line 3 simply reassigns the local variable `name` to the value of itself. This is not an instance variable and will not be included in the object's state.
=end

pepperoni_pizza = Pizza.new('pepperoni')
p pepperoni_pizza # <Pizza:0x0000000105a55298 @name="pepperoni">

banana = Fruit.new('banana')
p banana #<Fruit:0x00000001081b4e10>

=begin
# LS Notes
- 2 ways to check:
- Look at the class or ask the object
- use the `#instance_variables` method to see an object's instance variables
=end

p pepperoni_pizza.instance_variables # [:@name]

p banana.instance_variables # []
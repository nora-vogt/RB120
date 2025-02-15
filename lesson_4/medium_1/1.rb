=begin  
Ben asked Alyssa to code review the following code:

Alyssa glanced over the code quickly and said - "It looks fine, except that you forgot to put the @ before balance when you refer to the balance instance variable in the body of the positive_balance? method."

"Not so fast", Ben replied. "What I'm doing here is valid - I'm not missing an @!"

Who is right, Ben or Alyssa, and why?

Ben is correct! The `attr_reader` method creates the getter method for the `@balance` instance variable, making it possible to retrieve the value by calling the name of the getter method, `balance`. 

If we try this as an example, the `positive_balance?` method will work as expected.
=end

class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

my_account = BankAccount.new(1000)
p my_account.positive_balance? # true
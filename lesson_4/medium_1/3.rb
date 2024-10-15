class InvoiceEntry
  #attr_accessor :quantity
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    self.quantity = updated_count if updated_count >= 0
  end

  private
  attr_writer :quantity
end

=begin
In the last question Alan showed Alyssa this code which keeps track of items for a shopping cart application.

Alyssa noticed that this will fail when update_quantity is called. Since quantity is an instance variable, it must be accessed with the @quantity notation when setting it. One way to fix this is to change attr_reader to attr_accessor and change quantity to self.quantity.

Is there anything wrong with fixing it this way?

By adding the `attr_accessor`, this will give us access to the setter method for `@quantity` even outside of the `update_quantity` method, thus losing access to the validation that the method provides. For example:
=end

invoice = InvoiceEntry.new('chocolate bars', 100)
p invoice.quantity # 100
invoice.quantity = (1)
p invoice.quantity # 1

=begin
To avoid this, we could either:
1. Leave the `attr_reader` for `@quantity` and directly reference the instance variable `@quantity` in the `update_quantity` method
2. Make the `attr_writer` (setter) for `@quantity` private, to ensure that the `@quantity` cannot be changed from outside the class:
=end

invoice = InvoiceEntry.new('chocolate bars', 100)
p invoice.quantity # 100
invoice.quantity = (1) # NoMethodError - private method called!
# class InvoiceEntry
#   attr_reader :quantity, :product_name

#   def initialize(product_name, number_purchased)
#     @quantity = number_purchased
#     @product_name = product_name
#   end

#   def update_quantity(updated_count)
#     # prevent negative quantities from being set
#     quantity = updated_count if updated_count >= 0
#   end
# end

=begin  
Alan created the following code to keep track of items for a shopping cart application he's writing.

Alyssa looked at the code and spotted a mistake. "This will fail when update_quantity is called", she says.

Can you spot the mistake and how to address it?


There are two mistakes here. The first is that line 11 creates a local variable called `quanity` and assigns it to `updated_count`, rather than reassigning the value of the `@quantity` variable. 

The second is that there is currently no way to reassign `@quantity` because there is no setter method. Line 2 calls `attr_reader`, which creates only the getter methods for `@quantity`.

So, the fix is two parts:
1. Change `attr_reader` to `attr_accessor` for `@quantity`
2. Reassign `self.quantity`, to tell Ruby that we are invoking the setter method, rather than creating and assigning a local variable.

LS Adds: Or change `update_quantity` to reference the instance variable directly `@quantity = updated_count ...`
=end

# Fix
class InvoiceEntry
  attr_accessor :quantity
  attr_reader :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    self.quantity = updated_count if updated_count >= 0
  end
end

invoice = InvoiceEntry.new('keyboard', 5)
invoice.update_quantity(10)
p invoice.quantity
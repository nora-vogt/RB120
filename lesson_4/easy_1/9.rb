=begin
If we have the class below, what would you need to call to create a new instance of this class?

Call `Bag.new` and pass in two arguments to create a new instance of the `Bag` class.

LS Takeaway:
- The `#initialize` method specifies how many arguments will be needed when creating a new instance of the class with `::new`.
=end

class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

tote_bag = Bag.new('purple', 'cloth')
p tote_bag
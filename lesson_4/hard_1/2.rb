=begin
Building on the prior vehicles question, we now must also track a basic motorboat. A motorboat has a single propeller and hull, but otherwise behaves similar to a catamaran. Therefore, creators of Motorboat instances don't need to specify number of hulls or propellers. How would you modify the vehicles code to incorporate a new Motorboat class?

Motorboat
- 1 propeller
- 1 hull
- otherwise shares Catamaran behavior
Option 1: Create a new Motorboat class, include Movable, set the values for propeller/hull, only provide a reader
=end

module Movable
  attr_accessor :speed, :heading
  attr_writer :fuel_capacity, :fuel_efficiency
  
  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Movable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    # @fuel_efficiency = km_traveled_per_liter
    # @fuel_capacity = liters_of_fuel_capacity
    self.fuel_efficiency = km_traveled_per_liter # LS Solution
    self.fuel_capacity = liters_of_fuel_capacity # LS Solution
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end


class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

class SeaCraft
  include Movable

  attr_reader :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, fuel_efficiency, fuel_capacity)
    @propeller_count = num_propellers
    @hull_count = num_hulls
    self.fuel_efficiency = fuel_efficiency
    self.fuel_capacity = fuel_capacity
  end
end

class Catamaran < SeaCraft
end

class Motorboat < SeaCraft
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end


catamaran = Catamaran.new(4, 2, 50, 30)
p catamaran

boat = Motorboat.new(60, 20)
p boat

# First Solution
# class Motorboat
#   include Movable

#   attr_reader :propeller_count, :hull_count

#   def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
#     @propeller_count = 1
#     @hull_count = 1
#     self.fuel_efficiency = km_traveled_per_liter
#     self.fuel_capacity = liters_of_fuel_capacity
#   end
# end

# LS Solution - create a new superclass to extract common behavior from Catamaran and Motorboat
# Catamaran will automatically use the initialize in SeaCraft
# for Motorboat, accept 2 args for initialize, and just pass in 1 and 1 to super for the value of propellers/hulls


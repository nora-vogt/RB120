=begin
# What is the method lookup path and how is it important?

The method lookup path is the chain that Ruby will follow to determine where a method is defines and therefore what code should be executed. 

The chain:
  1. starts with the current class
  2. next checks modules, from last defined to first
  3. then checks the superclass (if present)
  4. then checks Object
  5. Kernel
  6. BasicObject
=end
=begin
What is the default return value of to_s when invoked on an object? Where could you go to find out if you want to be sure?

To check the default value, look in the docs for the value of `#to_s`. All objects inherit from Object, the Kernel module, and BasicObject class, so start in Object and follow the method lookup chain until finding the definition of `#to_s`.

My guess: a String representation of the object

Yup - Object#to_s is defined

to_s → string

Returns a string representing obj. The default to_s prints the object's class and an encoding of the object id. As a special case, the top-level object that is the initial execution context of Ruby programs returns “main”.

NOTES: to_s prints the object's class and an encoding of the object id
=end
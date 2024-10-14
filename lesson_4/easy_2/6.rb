class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

=begin
Which one of these is a class method (if any) and how do you know? How would you call a class method?

`self.manufacturer` is a class method. Class methods are denoted by prepending `self.` to the method name. This indicates that the class itself will be invoking the method.

Invoke the method on the class: `Television.manufacturer`
=end
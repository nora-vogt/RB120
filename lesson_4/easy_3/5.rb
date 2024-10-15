=begin
What would happen if I called the methods like shown below? What would happen if I called the methods like shown below?
=end

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer # a NoMethodError would be raised - `manfacturer` is a class method
tv.model # the `#model` method would execute

Television.manufacturer # now the class is calling the class method, so the method will execute
Television.model # a NoMethodError would be raised - can't use the class to call an instance method

# takeaways: Classes can only call class method. Instance method must be called by instances of the class.
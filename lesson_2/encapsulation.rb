class Dog
  attr_reader :nickname

  def initialize(nickname)
    @nickname = nickname
  end

  def change_nickname(new_nickname)
    self.nickname = new_nickname
  end

  def greeting
    "#{nickname.capitalize} says Woof Woof!"
  end

  private
    attr_writer :nickname
end

dog = Dog.new("rex")
dog.change_nickname("barny") # changed nickname to "barny"
puts dog.greeting # Displays: Barny says Woof Woof!
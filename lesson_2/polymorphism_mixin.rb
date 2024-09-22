# This is still considered polymorphism through inheritance, just for unrelated classes.

module Cotable
  def coating
    "I'm covered in chocolate!"
  end
end

class JaffaCake
  include Cotable     # mixing in the Cotable module
end

class Raisin
  include Cotable     # mixing in the Cotable module
end

snacks = [JaffaCake.new, Raisin.new]
snacks.each { |snack| puts "#{snack}: #{snack.coating}" }
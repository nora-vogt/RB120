class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

# What is the result of executing the following code:
oracle = Oracle.new # creates a new instance of the Oracle class
p oracle.predict_the_future

# `Oracle.predict_the_future` will return a string that starts with "You will" and then includes one of the strings from the `choices` method that will be randomly returned by `choices.sample`. For example: "You will take a nap soon."
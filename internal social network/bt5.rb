# class Box
#   def initialize width, height
#       @width = width
#       @height = height
#   end
# end

# class Rectangle < Box
#   def getArea
#       @width * @height
#   end
#   def getPerimeter
#         (@width + @height) * 2
#   end
# end

# box =  Rectangle.new 10,10
# p box.getArea
# p box.getPerimeter

# class Square
#  def initialize a
#   @a = a
#   end
#   def getPerimeter
#         @a * 4
#   end
#   def getAreaSquare
#       @a * @a
#   end
# end
# square = Square.new 3
# p square.getPerimeter
# p square.getAreaSquare

class Animal
  attr_accessor :color, :foot

  def initialize(color, foot)
    @color = color
    @foot = foot
  end

  def public_instance
    number_foots
    private_instance
  end

  protected

  def number_foots
    puts "have 2 foots"
  end

  private

  def private_instance
    puts " private_instance is private method!!!!"
  end

  animal = Animal.new "black", "2"
  # p animal.color
  # p animal.public_instance
end

# class Dog
#     def initialize name
#          @name = name
#     end
#     def speak
#         puts 'bark'
#     end
#     def swim
#         puts 'swimming'
#     end
# end
# class BullDog < Dog
#   def swim
#         puts  "#{@name} dont swimming"
#     end
# end

# dog = BullDog.new 'bull'
# p dog.swim

class Banner
  def initialize(message, width = 80)
    @width = [width, 80].min
    @message = message
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def empty_line
    "| #{" " * (@message.size)} |"
  end

  def horizontal_rule
    "+-#{"-" * (@message.size)}-+"
  end

  def message_line
    "| #{@message} |"
  end
end

banner = Banner.new("To boldly ho where no one has gone before.", 70)
puts banner

banner = Banner.new("")
puts banner

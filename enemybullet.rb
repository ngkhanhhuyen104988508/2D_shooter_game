class Enemybullet
  attr_accessor :x, :y, :radius, :window, :image
  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @radius = 4  # Nửa chiều rộng của đạn
    @image = Gosu::Image.new('image/enemybullet.png')  
    
  end
end
class MenuButton
  attr_reader :x, :y, :text, :width, :height, :font, :action
  
  
  def initialize(window, text, x, y, action)
    @window = window
    @text = text
    @x = x
    @y = y
    @width = 320
    @height = 40
    @font = Gosu::Font.new(@window, 'font/quinque-five-font/Quinquefive-0Wonv.ttf', 18)
    @action = action
    @hover = false
  end
  def draw
    color = @hover ? Gosu::Color::YELLOW : Gosu::Color::WHITE
    # Draw button background
    Gosu.draw_rect(@x - 5, @y - 9, @width, @height, Gosu::Color::GRAY, ZOrder::TOP)
    # Draw text
    @font.draw(@text, @x, @y, ZOrder::TOP, 1, 1, color)
  end

  def update
    mouse_x = @window.mouse_x
    mouse_y = @window.mouse_y
    @hover = mouse_x.between?(@x - 10, @x + @width) && mouse_y.between?(@y - 5, @y + @height)
  end

  def clicked?
    @hover && @window.button_down?(Gosu::MsLeft)
  end
end
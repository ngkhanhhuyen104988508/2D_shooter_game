class Enemy
    attr_accessor :x, :y, :radius, :image
    def initialize(window)
        @radius = 20
        @x = rand(window.width - 2 * @radius) + @radius
        @y = 0
        @image = Gosu::Image.new('image/tank_enemy.png')
        @last_shot = nil
    end
end

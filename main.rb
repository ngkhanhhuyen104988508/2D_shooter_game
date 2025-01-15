require 'gosu'
require 'json'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'enemybullet'
require_relative 'explosion'
require_relative 'boss'
require_relative 'star'
require_relative 'player2'
require_relative 'player2bullet'
require_relative 'menubutton'

module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
  end
  
#----------------------------Player-------------------------------------------------------------------
def rotate_right_player1(player1)
    player1.angle += 2.5
end
def rotate_left_player1(player1)
    player1.angle -= 2.5
end

def boost_player1(player1)
    player1.velocity_x += Gosu.offset_x(player1.angle, 1.1)
    player1.velocity_y += Gosu.offset_y(player1.angle, 1.1)
end

def move_player1(player1)
    player1.x += player1.velocity_x
    player1.y += player1.velocity_y
    player1.velocity_x *= 0.9 # increase player speed 
    player1.velocity_y *= 0.9 # increase player speed 
        if player1.x > player1.window.width - player1.radius 
            player1.x = player1.window.width - player1.radius
        end

        if player1.x < player1.radius 
            player1.velocity_x = 0 
            player1.x = player1.radius
        end

        if player1.y > player1.window.height - player1.radius 
            player1.velocity_y = 0
            player1.y = player1.window.height - player1.radius
        end
end
def render_player1(player1)
    player1.image.draw_rot(player1.x, player1.y, 1, player1.angle)
end
#---------------------player2---------------------------------------------

def rotate_right_player2(player2)
    player2.angle += 2.5
end
def rotate_left_player2(player2)
    player2.angle -= 2.5
end

def boost_player2(player2)
    player2.velocity_x += Gosu.offset_x(player2.angle, 1.1)
    
    player2.velocity_y += Gosu.offset_y(player2.angle, 1.1)
end

def move_player2(player2)
    player2.x += player2.velocity_x
    player2.y += player2.velocity_y
    player2.velocity_x *= 0.8 #player 2 speed 
    player2.velocity_y *= 0.9 #player 2 speed
        if player2.x > player2.window.width - player2.radius 
            player2.x = player2.window.width - player2.radius
        end

        if player2.x < player2.radius 
            player2.velocity_x = 0 
            player2.x = player2.radius
        end

        if player2.y > player2.window.height - player2.radius 
            player2.velocity_y = 0
            player2.y = player2.window.height - player2.radius
        end
end
def render_player2(player2)
    player2.image.draw_rot(player2.x, player2.y, 1, player2.angle)
end

#----------------------------------star------------------------------------ 
def move_star_object(star)
    # Move to bottom 
    star.y += 3
    # deleted theM
    star.y < 650
end

def render_star(star)
    img = star.animation[Gosu.milliseconds / 100 % star.animation.size];
    img.draw_rot(star.x, star.y, 1, star.y, 0.5, 0.5, 1, 1, star.color, :add)
end

#----------------------------Boss---------------------------------------------
def move_boss_object(boss)
    boss.y += 1

end
def render_boss(boss)
    boss.image.draw(boss.x-boss.radius, boss.y-boss.radius, 1)
end

#------------------------------------Bullet------------------------------------
# Moves a bullet object on the game screen
def move_bullet_object(bullet)
    bullet.x += Gosu::offset_x(bullet.direction, 5)
    bullet.y += Gosu::offset_y(bullet.direction, 5)
end
def render_bullet(bullet)
    bullet.image.draw_rot(bullet.x - bullet.radius, bullet.y - bullet.radius, 1, bullet.direction)
end
def validate_onscreen(bullet)
    right = bullet.window.width + bullet.radius 
    left = -bullet.radius 
    top = -bullet.radius 
    bottom = bullet.window.height + bullet.radius 
    bullet.x > left and bullet.x < right and bullet.y > top and bullet.y < bottom 
end

#------------------------------------Enemy Bullet------------------------------------
def move_enemy_bullet_object(bullet)
    bullet.y = bullet.y + 3 
end
  
def render_enemy_bullet(bullet)
    bullet.image.draw(bullet.x - bullet.radius, bullet.y - bullet.radius, 1, 0.5, 0.5)
end
#-----------------------------Player2 bullet------------------------------
def move_player2_bullet(player2bullet)
    player2bullet.x += Gosu::offset_x(player2bullet.direction, 5)
    player2bullet.y += Gosu::offset_y(player2bullet.direction, 5)
end
def render_player2_bullet(player2bullet)
    player2bullet.image.draw(player2bullet.x - player2bullet.radius, player2bullet.y - player2bullet.radius, 1)
end
# Checks if the bullet from player 2 is within the game window boundaries
def validate_player2_bullet_onscreen(player2bullet)
    right = player2bullet.window.width + player2bullet.radius 
    left = -player2bullet.radius 
    top = -player2bullet.radius 
    bottom = player2bullet.window.height + player2bullet.radius 
    player2bullet.x > left and player2bullet.x < right and player2bullet.y > top and player2bullet.y < bottom 
end

#--------------------------------Enemy----------------------------------- 
def move_enemy_object(enemy)
    enemy.y += 2
end
def render_enemy(enemy)
    enemy.image.draw(enemy.x-enemy.radius, enemy.y-enemy.radius, 1)
end

#------------------------------Explosion---------------------------------
def render_explosion(explosion)
    if explosion.image_index < explosion.images.count 
        explosion.images[explosion.image_index].draw(explosion.x - explosion.radius, explosion.y - explosion.radius, 2)
        explosion.image_index += 1
    else
        explosion.finished = true
    end
end
#-------------------------------------------------------------------------
    WIDTH = 800
    HEIGHT = 640
    STORY_DURATION = 2000
    ENEMY_FREQUENCY = 0.01 #enemy appear fequency
    BOSS_FREQUENCY = 0.002 #boss appear fequency
    MAX_ENEMIES = 40
    MAX_BOSSES = 100
    MAX_HEART = 10
    MAX_SHIELD = 10
class Spacewar < Gosu::Window
    def initialize 
        super(WIDTH,HEIGHT) 
        self.caption = 'SpaceWar'
        @start_image = Gosu::Image.new('image/startbackground.png')
        @scene = :start
        @start_music = Gosu::Song.new('sound/startmusic.mp3') 
        @start_music.play(false)
        @menu_buttons = [
          MenuButton.new(self, "SINGLE MODE", 250, 400, :single),
          MenuButton.new(self, "MULTIPLAYER MODE", 250, 450, :multiplayer),
          MenuButton.new(self, "LOAD GAME", 250, 500, :load),
          MenuButton.new(self, "INSTRUCTION", 250, 550, :instruction),
          MenuButton.new(self, "QUIT", 250, 600, :quit)
        ]
        @current_pilot = 0
        @pilot_images = [
            Gosu::Image.new('image/pilot1.png'),  
            Gosu::Image.new('image/pilot2.png')   
        ]
        @pause_font = Gosu::Font.new(self, 'font/street-graffiti-font/StreetGraffiti-G3BKG.otf', 33)
        @pause_button = Gosu::Image.new('image/pause.png')  
        @is_paused = false
        @leaderboard = load_leaderboard_data # Initialize leaderboard here
    end

    def draw
      case @scene
      when :start
          draw_start_screen
      when :story
        draw_story_screen 
      when :pilot_select  
        draw_pilot_selection
      when :instruction
          draw_instruction_screen
      when :game_single
          draw_game_single_player
      when :game_multiplayer
          draw_multiplayer_game
      when :end
          draw_end
      end
    end
#pause screen
    def draw_pause_overlay
        Gosu.draw_rect(0, 0, WIDTH, HEIGHT, Gosu::Color.new(180, 0, 0, 0), ZOrder::TOP)
        #GAME PAUSED text
        @pause_font.draw_text("GAME PAUSED", WIDTH/2 - 230, HEIGHT/5 -50, ZOrder::TOP, 3, 3, Gosu::Color::GREEN)
        # menu options
        @pause_font.draw_text("Resume", WIDTH/2 - 68, HEIGHT/2, ZOrder::TOP, 1, 1, Gosu::Color::GREEN)
        @pause_font.draw_text("Save Game", WIDTH/2 - 90, HEIGHT/2 + 60, ZOrder::TOP, 1, 1, Gosu::Color::GREEN)
        @pause_font.draw_text("Retry", WIDTH/2 - 60, HEIGHT/2 + 120, ZOrder::TOP, 1, 1, Gosu::Color::GREEN)
        @pause_font.draw_text("Exit", WIDTH/2 - 50, HEIGHT/2 + 180, ZOrder::TOP, 1, 1, Gosu::Color::GREEN)
        if @save_message && Gosu.milliseconds - @save_message_timer < 3000
            @pause_font.draw_text(@save_message, 
                                WIDTH/2 - 60, 
                                HEIGHT - 70, 
                                ZOrder::TOP, 
                                0.5, 0.5, 
                                Gosu::Color::GREEN)
        end
    end

    def toggle_pause_state
        @is_paused = !@is_paused
        if @is_paused
            @pause_start_time = Time.now
        elsif  @pause_start_time
            @pause_duration += Time.now - @pause_start_time
            @pause_start_time = nil         
        end
    end
    
    def handle_pause_input(id)
        if id == Gosu::KB_RETURN || id == Gosu::MS_LEFT
            mouse_x = mouse_x()
            mouse_y = mouse_y()
            
            # Resume button
            if mouse_y.between?(HEIGHT/2, HEIGHT/2 + 40) && mouse_x.between?(WIDTH/2 - 150, WIDTH/2 + 150)
                @is_paused = false
            end

            # Save game
            if mouse_y.between?(HEIGHT/2 + 60, HEIGHT/2 + 100) && mouse_x.between?(WIDTH/2 - 100, WIDTH/2 + 100)
                save_game_state
            end
            
            # Retry button
            if mouse_y.between?(HEIGHT/2 + 120, HEIGHT/2 + 160) && mouse_x.between?(WIDTH/2 - 60, WIDTH/2 + 60)
                if @scene == :game_single
                    initialize_single_mode
                else
                    initialize_multiplayer_mode
                end
                @is_paused = false
            end
            
            # Exit button
            if mouse_y.between?(HEIGHT/2 + 180, HEIGHT/2 + 220) && mouse_x.between?(WIDTH/2 - 50, WIDTH/2 + 50)
                initialize
                @is_paused = false
            end
        end
    end
#---------------------SAVE GAME PLAYING-------------------------
    def save_game_state
        game_state = {
            scene: @scene,
            timestamp: Time.now.to_s,
            player_data: {
                x: @player.x,
                y: @player.y,
                angle: @player.angle,
                velocity_x: @player.velocity_x,
                velocity_y: @player.velocity_y,
                heart: @player_heart,
                shield: @player_shield,
                score: @player_score
            }
        }
        #if multiplayer mode
        if @scene == :game_multiplayer
            game_state[:player2_data] = {
                x: @player2.x,
                y: @player2.y,
                angle: @player2.angle,
                velocity_x: @player2.velocity_x,
                velocity_y: @player2.velocity_y,
                heart: @player2_heart,
                shield: @player2_shield,
                score: @player2_score
            }
        end
        filename = "saves/spacewar_save_#{Time.now.strftime('%Y%m%d_%H%M%S')}.json" #create file name
        Dir.mkdir('saves') unless Dir.exist?('saves') #make sure file exists
        #save to file
        File.open(filename, 'w') do |file|
            file.puts JSON.generate(game_state)
        end
        @save_message = "Game saved!"
        @save_message_timer = Gosu.milliseconds 
    end 

    def load_game_state(filename)
        return unless File.exist?(filename)
        
        game_state = JSON.parse(File.read(filename))
        
        @scene = game_state['scene'].to_sym
#load player data
        @player.x = game_state['player_data']['x']
        @player.y = game_state['player_data']['y']
        @player.angle = game_state['player_data']['angle']
        @player.velocity_x = game_state['player_data']['velocity_x']
        @player.velocity_y = game_state['player_data']['velocity_y']
        @player_heart = game_state['player_data']['heart']
        @player_shield = game_state['player_data']['shield']
        @player_score = game_state['player_data']['score']
#player 2 data if multiplayer mode
        if game_state['player2_data']
            @player2.x = game_state['player2_data']['x']
            @player2.y = game_state['player2_data']['y']
            @player2.angle = game_state['player2_data']['angle']
            @player2.velocity_x = game_state['player2_data']['velocity_x']
            @player2.velocity_y = game_state['player2_data']['velocity_y']
            @player2_heart = game_state['player2_data']['heart']
            @player2_shield = game_state['player2_data']['shield']
            @player2_score = game_state['player2_data']['score']
        end
        @is_paused = false
    end 


#starting of the program
    def draw_start_screen
        @start_image.draw(0,0,0)
        @menu_buttons.each(&:draw)
    end
    def initialize_instruction_screen
        @scene = :instruction
        @instruction_image = Gosu::Image.new('image/instruction.png')
    end
    def draw_instruction_screen
        @instruction_image.draw(0,0,0)
    end
    def handle_instruction_input(id)
        if id == Gosu::KbR
            initialize
        end
    end

#-------------------------------
# button down for game mode
    def button_down(id)
        case @scene
        when :start 
          @menu_buttons.each do |button|
            if button.clicked?
              case button.action
              when :load
                load_latest_save
              when :single
                initialize_story_mode 

              when :multiplayer  
                initialize_multiplayer_mode 
               
              when :instruction
                initialize_instruction_screen
              when :quit
                close
              end
            end
          end
        when :instruction
          handle_instruction_input(id)
        when :story
            handle_story_input(id)
        when :pilot_select  
            handle_pilot_select_input(id)
        when :game_single, :game_multiplayer
            if id == Gosu::KB_BACKSPACE || 
               (id == Gosu::MS_LEFT && mouse_x.between?(WIDTH/2 - 50, WIDTH) && mouse_y.between?(0, 60))
                toggle_pause_state
            elsif @is_paused
                handle_pause_input(id)
            else
                handle_single_game_input(id) if @scene == :game_single
                handle_multiplayer_game_input(id) if @scene == :game_multiplayer
            end
        when :end
          handle_end_input(id)
        end
    end
#load the newest game
    def load_latest_save
        save_files = Dir['saves/*.json'].sort_by { |f| File.mtime(f) }
        if save_files.any?
            load_game_state(save_files.last)
        end
    end
#storyline before single game mode
    def initialize_story_mode
        @scene = :story
        @story_images = [
            Gosu::Image.new('image/story1.png'),
            Gosu::Image.new('image/story2.png'),
            Gosu::Image.new('image/story3.png'),
            Gosu::Image.new('image/story4.png')
        ]
        @current_story = 0
        @story_start_time = Gosu.milliseconds
    end

    def draw_story_screen
        @story_images[@current_story].draw(0, 0, 0)
    end
#------------------------select pilot before single mode n after storyline-----------------------
    def initialize_pilot_selection
        @scene = :pilot_select
        @current_pilot = 0
    end
    def draw_pilot_selection
        @pilot_images[@current_pilot].draw(0, 0, 0)
    end
    def update_pilot_selection
        if button_down?(Gosu::KbD)
            @current_pilot = 1
        elsif button_down?(Gosu::KbA)
            @current_pilot = 0
        end
    end
    def handle_pilot_select_input(id)
        if id == Gosu::KbL
            @selected_pilot = @current_pilot 
            initialize_single_mode
        end
    end

   
    def update 
        case @scene
        when :start
            @menu_buttons.each(&:update)
        when :story
            update_story_screen
        when :pilot_select 
            update_pilot_selection
        when :game_single
            update_single_game unless @is_paused
        when :game_multiplayer
            update_multiplayer_game unless @is_paused
        end
    end

    def update_story_screen
        current_time = Gosu.milliseconds
        if current_time - @story_start_time >= STORY_DURATION
            @current_story += 1
            @story_start_time = current_time
            
            if @current_story >= @story_images.size
                initialize_pilot_selection
            end
        end
    end

    def handle_start_input(id)
        @menu_buttons.each do |button|
            if button.clicked?
                case button.action
                when :single
                    initialize_story_mode  
                when :multiplayer  
                    initialize_multiplayer_mode
                when :instruction
                    initialize_instruction_screen
                when :quit
                    close
                end
            end
        end
    end
#skip story if needed
    def handle_story_input(id)
        if id == Gosu::KbSpace || id == Gosu::KbReturn || id == Gosu::MsLeft
            initialize_pilot_selection
        end
    end

#------------------------------------------LEADERBOARD FUNCTION-------------------------------------------------
#load the leaderboard from a file
def load_leaderboard_data
    if File.exist?('leaderboard.txt')
        File.readlines('leaderboard.txt').map do |line|
            time, score = line.chomp.split(',')
            [time, score.to_i]
        end.sort_by { |time, _| -time_to_seconds(time) }[0..9] # Keep top 10
    else
        []
    end
end

#save the in4 to the leaderboard
def save_to_leaderboard_data(time, score)
    @leaderboard << [time, score]
    @leaderboard.sort_by! { |t, _| -time_to_seconds(t) }
    @leaderboard = @leaderboard[0..9] # Keep top 10
    
    File.open('leaderboard.txt', 'w') do |file|
        @leaderboard.each do |t, s|
            file.puts "#{t},#{s}"
        end
    end
end

#convert to second to compare
def time_to_seconds(time_str)
    return 0 unless time_str # Add this line to handle nil case
    hours, minutes, seconds = time_str.split(':').map(&:to_i)
    hours * 3600 + minutes * 60 + seconds
end

#------------------------------------------multiplayer game mode------------------------------------------------
def draw_multiplayer_game
#game information
    player1_health_percentage = @player_heart / MAX_HEART.to_f
    player2_health_percentage = @player2_heart / MAX_HEART.to_f
    player1_shield_percentage = @player_shield / MAX_SHIELD.to_f
    player2_shield_percentage = @player2_shield / MAX_SHIELD.to_f
#background of in4
    Gosu.draw_rect(0, 0, 150, 100, Gosu::Color::GRAY, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(650, 0, 150, 100, Gosu::Color::GRAY, ZOrder::TOP, mode=:default)
#labels
    @in_game_font.draw("player2",687,2,2,1,1,Gosu::Color::BLACK)
    @in_game_font.draw("SCORE:#{@player2_score}",687,80,2,1,1,Gosu::Color::BLACK)
    @in_game_font.draw("player1",37,2,2,1,1,Gosu::Color::BLACK)
    @in_game_font.draw("SCORE:#{@player_score}",37,80,2,1,1,Gosu::Color::BLACK)
#black backgr, fixed width
    #player1 bar
    Gosu.draw_rect(37, 23, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(37, 53, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    #player2 bar
    Gosu.draw_rect(687, 23, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(687, 53, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)

    max_bar_width = 97
    Gosu.draw_rect(39, 25, 100 * player1_health_percentage, 20, Gosu::Color::RED, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(39, 55, 100 * player1_shield_percentage, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(689, 25, 100 * player2_health_percentage, 20, Gosu::Color::RED, ZOrder::TOP, mode=:default)
    Gosu.draw_rect(689, 55, 100 * player2_shield_percentage, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)
#icons: heart, shield
    @ingame_heart.draw(-8, 22, 2, ZOrder::TOP)
    @ingame_heart.draw(642, 22, 2, ZOrder::TOP)
    @ingame_shield.draw(0, 55, 2, ZOrder::TOP)
    @ingame_shield.draw(650, 55, 2, ZOrder::TOP)
# Draw pause button in top-right corner
    @pause_button.draw(WIDTH/2 - 20, 8, ZOrder::TOP, 1, 1) unless @is_paused    
# Draw pause screen if game is paused
    draw_pause_overlay if @is_paused    
#create backgound
    @ingame_background.draw(0,0,0)
#player 1
    render_player1(@player)
#player 2
    render_player2(@player2)
#create star
    @stars.each do |star|
        render_star(star)
    end
#create player 1 bullet
    @player_bullets.each do |bullet|
        render_bullet(bullet)
    end
#create player 2 bullet
    @player2_bullets.each do |player2bullet|
        render_player2_bullet(player2bullet)
    end
#create explosion
    @explosions.each do |explosion|
        render_explosion(explosion)
    end
end

def initialize_multiplayer_mode
    @player = Player.new(self) 
    @player2 = Player2.new(self)
    @player_bullets = [] 
    @player2_bullets = [] 
    @explosions = []
    @stars = []
    @player_shield = 10
    @player2_shield = 10
    @scene = :game_multiplayer
    @player_score = 0 
    @player2_score = 0
    @in_game_font = Gosu::Font.new(self, 'font/quinque-five-font/Quinquefive-0Wonv.ttf', 12)
    @star_fall = Gosu::Image::load_tiles("image/star.png", 25, 25)
    @game_music = Gosu::Song.new('sound/ingamemultiplayer.mp3') 
    @game_music.volume = 0.6
    @game_music.play(true)
    @explosion_sound = Gosu::Sample.new('sound/explosion.wav')
    @shooting_sound = Gosu::Sample.new('sound/gunsound.wav')
    @star_sound = Gosu::Sample.new('sound/ability.wav')
    @ingame_background = Gosu::Image.new('image/back.jpg')
    @ingame_heart = Gosu::Image.new('image/heart.png')
    @ingame_shield = Gosu::Image.new('image/shield.png')
    @player_heart = 10
    @player2_heart = 10 
    @start_time = Time.now
    @pause_duration = 0
    @pause_start_time = nil
    @current_time = "00:00:00"
end

def get_current_game_time
    return @current_time if @is_paused
    
    total_time = Time.now - @start_time - @pause_duration
    hours = (total_time / 3600).to_i
    minutes = ((total_time % 3600) / 60).to_i
    seconds = (total_time % 60).to_i
    format("%02d:%02d:%02d", hours, minutes, seconds)
end

def update_multiplayer_game
    return if @is_paused

    @current_time = get_current_game_time
    
#move for player 1 
    rotate_left_player1(@player) if button_down?(Gosu::KbLeft)
    rotate_right_player1(@player) if button_down?(Gosu::KbRight)
    boost_player1(@player) if button_down?(Gosu::KbUp)
    move_player1(@player)
    
#move for player 2
    rotate_left_player2(@player2) if button_down?(Gosu::KbA)
    rotate_right_player2(@player2) if button_down?(Gosu::KbD)
    boost_player2(@player2) if button_down?(Gosu::KbW)
    move_player2(@player2)
#move bullet
    @player_bullets.each do |bullet| #move bullet 
        move_bullet_object(bullet)
    end
#Move bullet
    @player2_bullets.each do |player2bullet| #move bullet 
        move_player2_bullet(player2bullet)
    end
#move star
    @stars.push(Star.new(@star_fall)) if rand(50) == 0 # star appear  
    @stars.each do |star| 
        move_star_object(star) 
    end
#player 1 get star
    @stars.dup.each do |star| 
        distance_player_star = Gosu::distance(star.x, star.y, @player.x, @player.y)
        if distance_player_star < @player.radius + star.radius
            @star_sound.play
            @stars.delete star 
            if @player_heart < MAX_HEART
                @player_heart += 1
            elsif @player_shield < MAX_SHIELD
                @player_shield += 1
            end
        end
    end
#player 2 get star
    @stars.dup.each do |star| 
        distance_player2_star = Gosu::distance(star.x, star.y, @player2.x, @player2.y)
        if distance_player2_star < @player.radius + star.radius
            @star_sound.play
            @stars.delete star 
            if @player2_heart < MAX_HEART
                @player2_heart += 1
            elsif @player2_shield < MAX_SHIELD
                @player2_shield += 1 
            end
        end
    end
#if player 2 is hitted by player 1 bullet
    @player_bullets.dup.each do |bullet|
        distance_player = Gosu.distance(@player2.x, @player2.y, bullet.x, bullet.y) 
        if distance_player < @player2.radius + bullet.radius 
            @player_bullets.delete bullet
            @explosions.push Explosion.new(self, @player2.x, @player2.y)
            @player_score += 1
            if @player2_shield > 0
                @player2_shield -= 1
            else
                @player2_heart -= 1
            end
            @explosion_sound.play
        end
    end
#if player 1 is hitted by player 2 bullet
    @player2_bullets.dup.each do |player2bullet|
        distance_player2 = Gosu.distance(@player.x, @player.y, player2bullet.x, player2bullet.y) 
        if distance_player2 < @player.radius + player2bullet.radius 
            @player2_bullets.delete player2bullet
            @explosions.push Explosion.new(self, @player.x, @player.y)
            @player2_score += 1
            if @player_shield > 0 
                @player_shield -=1
            else
                @player_heart -= 1
            end
            @explosion_sound.play
        end
    end
#delete explosion when finished
    @explosions.dup.each do |explosion| 
        @explosions.delete explosion if explosion.finished
    end
#delete bullet player 1
    @player_bullets.dup.each do |bullet|  
        @player_bullets.delete bullet unless validate_onscreen(bullet)
    end
#delete bullet player 2
    @player2_bullets.dup.each do |player2bullet| 
        @player2_bullets.delete player2bullet unless validate_player2_bullet_onscreen(player2bullet)
    end

#ending for each player
    initialize_end(:player_win)  if @player2_heart == 0
    initialize_end(:player2_win) if @player_heart == 0
    initialize_end(:off_top1_mul) if @player.y < -@player.radius
    initialize_end(:off_top2_mul) if @player2.y < -@player2.radius


#shoot for player
    def handle_multiplayer_game_input(id)
        if id == Gosu::KbEnter  
            @player_bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
            @shooting_sound.play(0.3)
        end
#shoot for player2
        if id == Gosu::KbG
            @player2_bullets.push Player2bullet.new(self, @player2.x, @player2.y, @player2.angle)
            @shooting_sound.play(0.3)
        end
    end
end


#-----------------------------------------------------------------------------------------------------------------------------


#-----------------------single game mode----------------------------------------------------------------------------------------
    def draw_game_single_player
#ingame information
      
        player_health_percentage = @health / MAX_HEART.to_f
        player_shield_percentage = @shield / MAX_SHIELD.to_f

        Gosu.draw_rect(0, 0, 370, 100, Gosu::Color::GRAY, ZOrder::TOP, mode=:default)

        @in_game_font.draw("player",37,2,2,1,1,Gosu::Color::BLACK)
        @in_game_font.draw("SCORE: #{@score}",37,80,2,1,1,Gosu::Color::BLACK)
        @in_game_font.draw("Enemies Left: #{MAX_ENEMIES - @enemies_destroyed}",151,22,2,1,1,Gosu::Color::BLACK)
        @in_game_font.draw("Bosses Left: #{MAX_BOSSES - @bosses_destroyed}",151,55,2,1,1,Gosu::Color::BLACK)

        Gosu.draw_rect(37, 23, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)
        Gosu.draw_rect(37, 53, 104, 24, Gosu::Color::BLACK, ZOrder::TOP, mode=:default)

        Gosu.draw_rect(39, 25, 100 * player_health_percentage, 20, Gosu::Color::RED, ZOrder::TOP, mode=:default)
        Gosu.draw_rect(39, 55, 100 * player_shield_percentage, 20, Gosu::Color::WHITE, ZOrder::TOP, mode=:default)

        @ingame_heart.draw(-8, 22, 2, ZOrder::TOP)
        @ingame_shield.draw(0, 55, 2, ZOrder::TOP)
        # Draw pause button in top-right corner
        @pause_button.draw(WIDTH - 60, 10, ZOrder::TOP, 1, 1) unless @is_paused    
        # Draw pause screen if game is paused
        draw_pause_overlay if @is_paused
#draw background
        @ingame_background.draw(0,0,0)
#draw player
        render_player1(@player)
#draw enemies
        @enemies.each do |enemy|
            render_enemy(enemy)
        end
#draw bullet
        @bullets.each do |bullet|
            render_bullet(bullet)
        end
#draw enemy bullet
        @enemy_bullets.each do |bullet|
            render_enemy_bullet(bullet)
        end
#draw explosion
        @explosions.each do |explosion|
            render_explosion(explosion)
        end
#draw boss
        @bosses.each do |boss|
            render_boss(boss)
        end
#draw star
        @stars.each do |star|
            render_star(star)
        end
#draw timer
        @in_game_font.draw("#{@current_time}", 10, HEIGHT - 30, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)
    end
    

    def initialize_single_mode
        @player = Player.new(self) 
        @enemies = [] 
        @bullets = [] 
        @explosions = []
        @enemy_bullets = []
        @bosses = []
        @stars = []
        @shield = MAX_SHIELD
        @scene = :game_single
        @score = 0 
        @start_time = Time.now
        @pause_duration = 0  # Tổng thời gian đã pause
        @pause_start_time = nil  # Thời điểm bắt đầu pause
        @current_time = "00:00:00"
        @leaderboard = load_leaderboard_data # Ensure leaderboard is loaded here
        @in_game_font = Gosu::Font.new(self, 'font/quinque-five-font/Quinquefive-0Wonv.ttf', 12)
        @bosses_destroyed = 0 
        @bosses_appeared = 0 
        @enemies_appeared = 0 
        @enemies_destroyed = 0 
        @star_fall = Gosu::Image::load_tiles("image/star.png", 25, 25)
        @game_music = Gosu::Song.new('sound/ingamesingle.ogg') 
        @game_music.volume = 0.6
        @game_music.play(true)
        @explosion_sound = Gosu::Sample.new('sound/explosion.wav')
        @shooting_sound = Gosu::Sample.new('sound/gunsound.wav')
        @star_sound = Gosu::Sample.new('sound/ability.wav')
        @ingame_background = Gosu::Image.new('image/background.jpg')
        @ingame_heart = Gosu::Image.new('image/heart.png')
        @ingame_shield = Gosu::Image.new('image/shield.png')
        @health = MAX_HEART
        @pause_duration = 0
        @pause_start_time = nil
    end

    def get_current_game_time
        return @current_time if @is_paused
        
        total_time = Time.now - @start_time - @pause_duration
        hours = (total_time / 3600).to_i
        minutes = ((total_time % 3600) / 60).to_i
        seconds = (total_time % 60).to_i
        format("%02d:%02d:%02d", hours, minutes, seconds)
    end

    def update_single_game
        return if @is_paused

        @current_time = get_current_game_time
        
#update timer
        elapsed_time = Time.now - @start_time - @pause_duration
        hours = (elapsed_time / 3600).to_i
        minutes = ((elapsed_time % 3600) / 60).to_i
        seconds = (elapsed_time % 60).to_i
        @current_time = format("%02d:%02d:%02d", hours, minutes, seconds)
#move player
        rotate_left_player1(@player) if button_down?(Gosu::KbLeft)
        rotate_right_player1(@player) if button_down?(Gosu::KbRight)
        boost_player1(@player) if button_down?(Gosu::KbUp)
        move_player1(@player)
#create enemy
        if rand < ENEMY_FREQUENCY  && @enemies.size < MAX_ENEMIES
            @enemies.push Enemy.new(self)
            @enemies_appeared += 1 
        end
#create boss
        if rand < BOSS_FREQUENCY  
            @bosses.push Boss.new(self)
            @bosses_appeared += 1
        end
#move enemy 
        @enemies.each do |enemy| 
            move_enemy_object(enemy)
        end
# move boss
        @bosses.each do |boss|  
            move_boss_object(boss)
        end
#move bullet
        @bullets.each do |bullet|  
            move_bullet_object(bullet)
        end
#move star
        @stars.push(Star.new(@star_fall)) if rand(200) == 0 # star appear  
        @stars.each do |star| 
            move_star_object(star) 
        end
#enemy shoot
        @enemies.each do |enemy|
            if rand < 0.02  #2 viên/giây
              @enemy_bullets.push Enemybullet.new(self, enemy.x + enemy.radius, enemy.y + enemy.radius)
            end
          end
#move enemy bullet 
        @enemy_bullets.each do |bullet|
            move_enemy_bullet_object(bullet)
        end
        
#create collision between enemy bullet and player

        @enemy_bullets.dup.each do |bullet|
            distance = Gosu.distance(@player.x, @player.y, bullet.x, bullet.y)
            if distance < @player.radius + bullet.radius
             @enemy_bullets.delete bullet
             @explosions.push Explosion.new(self, @player.x, @player.y)
                if @shield > 0
                    @shield -= 2
                else
                    @health -= 2
                end
             initialize_end(:hit_by_enemy) if @health <= 0
            end 
        end
#delete enemy bullet
        @enemy_bullets.dup.each do |bullet|
            @enemy_bullets.delete bullet if bullet.y > HEIGHT + bullet.radius
          end

#create collision between enemy and bullet
        @enemies.dup.each do |enemy|   
            @bullets.dup.each do |bullet|
                distance_enemy_bullet = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y) 
                if distance_enemy_bullet < enemy.radius + bullet.radius                   
                    @enemies.delete enemy 
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                    @enemies_destroyed += 1
                    @score += 1
                    @explosion_sound.play           
                    @bullets.delete bullet
                end
            end
        end
#create collision between player a star 
        @stars.dup.each do |star| 
            distance_player_star = Gosu::distance(star.x, star.y, @player.x, @player.y)
            if distance_player_star < @player.radius + star.radius
                @star_sound.play
                @stars.delete star
                if @health < MAX_HEART
                    @health += 1
                elsif @shield < MAX_SHIELD
                    @shield += 1
                end
            end
        end
#create collision between boss and bullet 
        @bosses.dup.each do |boss|  
            @bullets.dup.each do |bullet|
                distance_boss_bullet = Gosu.distance(boss.x, boss.y, bullet.x, bullet.y) 
                if distance_boss_bullet < boss.radius + bullet.radius
                    boss.hp -= 1 
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, boss.x, boss.y)
                    @explosion_sound.play
                    if boss.hp == 0 
                        @bosses.delete boss
                        @bosses_destroyed += 1 
                        @score += 5
                    end
                end
            end
        end
#delete ecplosion when finished
        @explosions.dup.each do |explosion| 
            @explosions.delete explosion if explosion.finished
        end
#delete enemy
        @enemies.dup.each do |enemy|  
            if enemy.y > HEIGHT + enemy.radius
                @enemies.delete enemy 
            end
        end
 #delete bullet 
        @bullets.dup.each do |bullet| 
            @bullets.delete bullet unless validate_onscreen(bullet)
        end
        
        initialize_end(:count_reached)  if @enemies_destroyed >= MAX_ENEMIES or @bosses_destroyed >= MAX_BOSSES
        
#lose when health = 0 (create collision between enemy and player)

        @enemies.each do |enemy| 
            distance1 = Gosu::distance(enemy.x, enemy.y, @player.x, @player.y)
            if distance1 < @player.radius + enemy.radius 
                @enemies.delete enemy 
                @explosions.push Explosion.new(self, enemy.x, enemy.y)
                @explosion_sound.play
                if @shield > 0
                    @shield -= 1
                else
                    @health -= 1
                end
            end
            initialize_end(:hit_by_enemy) if @health == 0 
        end
#Lose when a boss reaches base or player gets hit by a boss
        @bosses.each do |boss| 
            distance2 = Gosu::distance(boss.x, boss.y, @player.x, @player.y)
            initialize_end(:hit_by_boss) if distance2 < @player.radius + boss.radius
        end
#lose when player reachs the top border
        initialize_end(:off_top) if @player.y < -@player.radius  
    end
#button to shoot
    def handle_single_game_input(id)
        if id == Gosu::KbSpace 
            @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
            @shooting_sound.play(0.3)
        end
    end

#--------------------------------end of singple player mode-----------------------------------------
    
#---------------------------------------ending ----------------------------------------
    def initialize_end(status)
        case status
        when :count_reached
            @message = "You made it! You destroyed #{@enemies_destroyed} ships"
            @message_two = "Your score: #{@score}"
            save_to_leaderboard_data(@current_time, @score)
        when :hit_by_enemy
            @message = "Oh no! You were hit by an enemy ship."
            @message_two = "However with #{@score} scores"
            @message_three = "you took out #{@enemies_destroyed} enemy ships, #{@bosses_destroyed} boss ships"
            save_to_leaderboard_data(@current_time, @score)
        when :hit_by_boss
            @message = "Oh no! You were hit by a boss ship."
            @message_two = "However with #{@score} scores"
            @message_three = "you took out #{@enemies_destroyed} enemy ships, #{@bosses_destroyed} boss ships"
            save_to_leaderboard_data(@current_time, @score)
        when :off_top
            @message = 'Uh huh! Why did you come out of combat zone?'
            @message_two = "You destroyed #{@enemies_destroyed} enemy ships, #{@bosses_destroyed} boss ships" 
            @message_three = "Such a good job, we counted on you!"
            save_to_leaderboard_data(@current_time, @score)
        when :player2_win
            @message = 'Congratulations player 2 win the game'
            @message_two = "player 2 score: #{@player2_score}      player 1 score: #{@player_score}"
            @message_three = "Do you want to play again?"
        when :player_win 
            @message = 'Congratulations player 1 win the game'
            @message_two = "player 1 score: #{@player_score}      player 2 score: #{@player2_score}"
            @message_three = "Do you want to play again?"
        when :off_top1_mul
            @message = 'Player 1 is running out of combat zone' 
            @message_two = "PLayer 2 WIN with #{@player2_score} score"
            @message_three = "Do you want to play again?"
        when :off_top2_mul
            @message = 'Player 2 is running out of combat zone'
            @message_two = "PLayer 1 WIN with #{@player_score} score"
            @message_three = "Do you want to play again?"
        end
        # Ensure @leaderboard is not nil
        @leaderboard ||= load_leaderboard_data

        # Leaderboard display
        @leaderboard_text = "LEADERBOARD (Top 10)\n\n"
        @leaderboard.each_with_index do |(time, score), index|
            @leaderboard_text += "#{index + 1}. Time: #{time} - Score: #{score}\n"
        end
    
        @game_message = 'Press R to return to the main menu or Q to quit.'
        @message_font = Gosu::Font.new(self, 'font/quinque-five-font/Quinquefive-0Wonv.ttf', 13)
        @leaderboard_font = Gosu::Font.new(self, 'font/street-graffiti-font/StreetGraffiti-G3BKG.otf', 20)
        @scene = :end
        @end_music = Gosu::Song.new('sound/startmusic.mp3')
        @end_music.play(false)


      def draw_end
        @message_font.draw(@message, 30, 40, 1, 1, 1, Gosu::Color::GRAY)
        @message_font.draw(@message_two, 30, 75, 1, 1, 1, Gosu::Color::GRAY)
        @message_font.draw(@message_three, 30, 110, 1, 1, 1, Gosu::Color::GRAY)
        @message_font.draw(@game_message, 70, 150, 1, 1, 1, Gosu::Color::AQUA)
        @leaderboard_font.draw(@leaderboard_text, 180, 220, 1.5, 1.5, 1.5, Gosu::Color::YELLOW)
        draw_line(0, 200, Gosu::Color::GRAY, WIDTH, 200, Gosu::Color::GRAY)
      end
    end    
#----------------------------------------------------
#return to the main menu or quit the game
    def handle_end_input(id) 
        if id == Gosu::KbR
            initialize
        elsif id == Gosu::KbQ
            close
        end
    end
end
#------------------------------------------------
window = Spacewar.new
window.show
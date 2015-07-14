#coding: utf-8
class Map::TeleportPoint
  @@Image=HorizonSurfaceTexture.new(Surface.load_with_colorkey('./rc/pic/battle/teleport.png'))
  def initialize(location,dest_id,dest_pos)
    @position=location
    @dest_id=dest_id
    @dest_pos=dest_pos
  end
  def interact
    player_x=Game.player.position.x
    player_z=Game.player.position.z
    return Math.distance(@position.x,@position.z,player_x,player_z)<60
  end
  def teleport
    Game.player.position.x=@dest_pos.x
    Game.player.position.z=@dest_pos.z
    return @dest_id
  end
  def draw
    @@Image.draw(@position.x-60,430-@position.z/2+30)
  end
end
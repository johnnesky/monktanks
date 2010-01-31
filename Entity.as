package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class Entity extends Sprite {

    public static const BIT_TANK2:     int = 64;
    public static const BIT_TANK1:     int = 32;
    public static const BIT_HOLOGRAM2: int = 16;
    public static const BIT_HOLOGRAM1: int = 8;
    public static const BIT_BULLET2:   int = 4;
    public static const BIT_BULLET1:   int = 2;
    public static const BIT_ENVIRO:    int = 1;
        
    public function Entity(x: Number, y: Number){
      this.x = x;
      this.y = y;
    }
    
    public function update(ticks: int): void {
    }
  }
}
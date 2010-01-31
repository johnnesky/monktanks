package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class Entity extends Sprite {

    public static const BIT_TANK:      int = 0x08;
    public static const BIT_HOLOGRAM:  int = 0x04;
    public static const BIT_BULLET:    int = 0x02;
    public static const BIT_ENVIRO:    int = 0x01;
        
    public function Entity(x: Number, y: Number){
      this.x = x;
      this.y = y;
    }
    
    public function update(ticks: int): void {
    }
  }
}
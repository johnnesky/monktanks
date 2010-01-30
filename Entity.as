package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class Entity extends Sprite {
    public function Entity(x: Number, y: Number){
      this.x = x;
      this.y = y;
      graphics.beginFill(0xffff00);
      graphics.drawRect(-15, -15, 30, 30);
      graphics.endFill();
    }
    
    public function update(): void {
      this.y += 1;
    }
  }
}
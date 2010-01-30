package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class Tank extends Entity {

      

    public static const ACTION_FORWARD: int = 1;

    public static const ACTION_BACK:    int = 2;

    public static const ACTION_LEFT:    int = 3;

    public static const ACTION_RIGHT:   int = 4;

    public static const ACTION_FIRE:    int = 5;

    public static const ACTION_CLONE:   int = 6;

        
    public function Tank(x: Number, y: Number){
      super(x,y);

        

      graphics.beginFill(0xffff00);

      graphics.drawRect(-15, -15, 30, 30);

      graphics.endFill();
    }
    

    public function keydown(action: int, pressed: Boolean): void {
      
    }

    
    override public function update(): void {
      this.y += 1;
    }
  }
}
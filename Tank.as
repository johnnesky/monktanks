package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class Tank extends Entity {

    public static const ACTION_NONE:    int = 0;
    public static const ACTION_FORWARD: int = 1;
    public static const ACTION_BACK:    int = 2;
    public static const ACTION_LEFT:    int = 3;
    public static const ACTION_RIGHT:   int = 4;
    public static const ACTION_FIRE:    int = 5;
    public static const ACTION_CLONE:   int = 6;
        
    public var currentAction : int = ACTION_NONE;
    public var speed         : Number = 30.0;
    public var rotationSpeed : Number = 50.0;
    private var mainInstance : MonkTanks
    
    public function Tank(x: Number, y: Number, inst: MonkTanks){
      super(x,y);
      mainInstance = inst;
        
      graphics.beginFill(0xffff00);
      graphics.drawRect(-15, -15, 30, 30);
      graphics.endFill();
    }

    public function keydown(action: int, pressed: Boolean): void {
      if (pressed == false)
      {
        currentAction = ACTION_NONE;
      }
      else if (action == ACTION_FORWARD || action == ACTION_BACK
            || action == ACTION_LEFT    || action == ACTION_RIGHT)
      {
        currentAction = action;
      }
      else if (action == ACTION_FIRE)
      {
        var bullet : Bullet = new Bullet(x, y, rotation);
        mainInstance.addEntity(bullet)
      }
      else if (action == ACTION_CLONE)
      {
      }
    }
    
    override public function update(): void {
      var ticktime : int = 33;
      if (currentAction == ACTION_FORWARD)
      {
        this.x += speed * Math.cos(rotation*Math.PI/180) * ticktime/1000;
        this.y += speed * Math.sin(rotation*Math.PI/180) * ticktime/1000;
      }
      else if (currentAction == ACTION_BACK)
      {
        this.x -= speed * Math.cos(rotation*Math.PI/180) * ticktime/1000;
        this.y -= speed * Math.sin(rotation*Math.PI/180) * ticktime/1000;
      }
      else if (currentAction == ACTION_LEFT)
      {
        rotation -= rotationSpeed * ticktime/1000;
      }
      else if (currentAction == ACTION_RIGHT)
      {
        rotation += rotationSpeed * ticktime/1000;
      }
    }
  }
}
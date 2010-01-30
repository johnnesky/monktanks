package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class Tank extends Entity {
    [Embed(source='CartoonTank.swf',
           symbol='Tank1')]
    private static const _tankSpriteClass: Class;
    
    public static const ACTION_NONE:    int = 0;
    public static const ACTION_FORWARD: int = 1;
    public static const ACTION_BACK:    int = 2;
    public static const ACTION_LEFT:    int = 3;
    public static const ACTION_RIGHT:   int = 4;
    public static const ACTION_FIRE:    int = 5;
    public static const ACTION_CLONE:   int = 6;
        
    private var bKeyForward : Boolean = false;
    private var bKeyBack    : Boolean = false;
    private var bKeyLeft    : Boolean = false;
    private var bKeyRight   : Boolean = false;
    
    public var currentAction : int = ACTION_NONE;
    public var speed         : Number = 80.0;
    public var rotationSpeed : Number = 120.0;
    private var reloadTime   : int = 0     // ms until recharge is complete
    private var reloadMax    : int = 3500  // ms required for total recharge
    private var mainInstance : PlayState
    
    public function Tank(x: Number, y: Number, inst: PlayState){
      super(x,y);
      mainInstance = inst;
      addChild(new _tankSpriteClass());
    }

    public function keydown(action: int, pressed: Boolean): void {
      if (action == ACTION_FORWARD)
        bKeyForward = pressed
      else if (action == ACTION_BACK)
        bKeyBack = pressed
      else if (action == ACTION_LEFT)
        bKeyLeft = pressed
      else if (action == ACTION_RIGHT)
        bKeyRight = pressed
      else if (action == ACTION_FIRE && pressed && reloadTime <= 0)
      {
        var bullet : Bullet = new Bullet(x, y, rotation, mainInstance);
        mainInstance.addEntity(bullet)
        reloadTime = reloadMax
      }
      else if (action == ACTION_CLONE && pressed)
      {
      }
      
      if (bKeyLeft)
        currentAction = ACTION_LEFT
      else if (bKeyRight)
        currentAction = ACTION_RIGHT
      else if (bKeyForward)
        currentAction = ACTION_FORWARD
      else if (bKeyBack)
        currentAction = ACTION_BACK
      else
        currentAction = ACTION_NONE
    }
    
    override public function update(ticks: int): void {
      if (currentAction == ACTION_FORWARD)
      {
        this.x += speed * Math.cos(rotation*Math.PI/180) * ticks/1000;
        this.y += speed * Math.sin(rotation*Math.PI/180) * ticks/1000;
      }
      else if (currentAction == ACTION_BACK)
      {
        this.x -= speed * Math.cos(rotation*Math.PI/180) * ticks/1000;
        this.y -= speed * Math.sin(rotation*Math.PI/180) * ticks/1000;
      }
      else if (currentAction == ACTION_LEFT)
      {
        rotation -= rotationSpeed * ticks/1000;
      }
      else if (currentAction == ACTION_RIGHT)
      {
        rotation += rotationSpeed * ticks/1000;
      }
      
      // Wrap around screen
      if (this.x < -15)
        this.x += 830;
      if (this.x > 815)
        this.x -= 830;
      if (this.y < -15)
        this.y += 630;
      if (this.y > 615)
        this.y -= 630;
      
      // Decrement remaining reload time
      if (reloadTime >= 0)
      {
        reloadTime -= ticks
      }
    }
  }
}
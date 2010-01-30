package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class Bullet extends Entity {
      
    public var speed    : Number = 160.0
    public var distance : Number = 0.0
    public var maxDist  : Number = 550.0
    private var mainInstance : PlayState
          
    public function Bullet(x: Number, y: Number, rot: Number, inst: PlayState){
      super(x,y);
      rotation = rot;
      mainInstance = inst;
        
      graphics.beginFill(0x00ff00);
      graphics.drawRect(-5, -5, 10, 10);
      graphics.endFill();
    }
    
    override public function update(ticks: int): void {
      this.x += speed * Math.cos(rotation*Math.PI/180) * ticks/1000;
      this.y += speed * Math.sin(rotation*Math.PI/180) * ticks/1000;
      distance += speed * ticks/1000;
      if (distance > maxDist)
      {
        mainInstance.removeEntity(this)
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
    }
  }
}
package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class Bullet extends Entity {
    public function Bullet(x: Number, y: Number, rot: Number){
      super(x,y);
      rotation = rot;
        
      graphics.beginFill(0x00ff00);
      graphics.drawRect(-5, -5, 10, 10);
      graphics.endFill();
    }
    
    override public function update(): void {
      var ticktime : int = 33;
        /*
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
        */
    }
  }
}
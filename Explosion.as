package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  public class Explosion extends Entity {
    [Embed(source='Explosion1.swf',
           symbol='Explosion1')]
    private static const _explosionSpriteClass: Class;
    
    public var timeLeft : int    = 500;
    private var mainInstance : PlayState
    
    public function Explosion(x: int, y: int, inst: PlayState){
      super(x,y);
      mainInstance = inst;
      addChild(new _explosionSpriteClass());
      new SoundEffectManager.xplosion().play();
    }
    
    override public function update(ticks: int): void {
      scaleX += 0.1;
      scaleY = scaleX;
      alpha -= 0.05;
      timeLeft -= ticks;
      if (timeLeft <= 0)
      {
        mainInstance.removeEntity(this);
      }
    }
  }
}
package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  public class Impact extends Entity {
    [Embed(source='Impact1.swf',
           symbol='Impact1')]
    private static const _impactSpriteClass: Class;
    
    public var timeLeft : int    = 400;
    private var mainInstance : PlayState
    
    public function Impact(x: int, y: int, inst: PlayState){
      super(x,y);
      mainInstance = inst;
      addChild(new _impactSpriteClass());
      if (Math.random() > 0.66) {
        new SoundEffectManager.impact1().play();
      } else if (Math.random() > 0.5) {
        new SoundEffectManager.impact2().play();
      } else {
        new SoundEffectManager.impact3().play();
      }
    }
    
    override public function update(ticks: int): void {
      scaleX += 0.15;
      scaleY = scaleX;
      alpha -= 0.07;
      timeLeft -= ticks;
      if (timeLeft <= 0)
      {
        mainInstance.removeEntity(this);
      }
    }
  }
}
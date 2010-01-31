package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class HudBar extends Entity {
    
    public var val        : Number  = 1.0;
    private var color     : uint    = 0x0000a0;
    private var alignLeft : Boolean = true;
      
    public function HudBar(x: Number, y: Number, color: uint, alighLeft: Boolean){
      super(x,y);
      this.color = color;
      this.alignLeft = alighLeft;
    }
    
    override public function update(ticks: int): void {
      graphics.clear()
      graphics.beginFill(0xffffff, 0.5)
      graphics.drawRect(x,y,300,15)
      graphics.endFill()
      graphics.beginFill(color, 0.5)
      if (alignLeft)
      {
        graphics.drawRect(x+2,y+2,val*296.0,11)
      }
      else
      {
        graphics.drawRect(x+298-val*296,y+2,val*296.0,11)
      }
      graphics.endFill()
    }
  }
}
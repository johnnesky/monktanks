package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  [SWF(width=800, height=600, frameRate=30, backgroundColor=0x004400)]
  public class MonkTanks extends Sprite{
    public var entities: Array = [];
    public var tank1 : Tank;
    public var tank2 : Tank;
    
    public function MonkTanks(){
      addEventListener(Event.ENTER_FRAME, update);
      
      tank1 = new Tank(100, 400)
      tank2 = new Tank(700, 400) 
        
      entities.push(tank1);
      addChild(tank1);
      entities.push(tank2);
      addChild(tank2);
    }
    
    private function update(event: Event): void {
      for each (var entity: Entity in entities) {
        entity.update();
      }
    }
  }
}
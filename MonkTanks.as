package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  [SWF(width=800, height=600, frameRate=30, backgroundColor=0x004400)]
  public class MonkTanks extends Sprite{
    public var entities: Array = [];
    
    public function MonkTanks(){
      addEventListener(Event.ENTER_FRAME, update);
      
      var entity: Entity = new Entity(100, 100);
      entities.push(entity);
      addChild(entity);
    }
    
    private function update(event: Event): void {
      for each (var entity: Entity in entities) {
        entity.update();
      }
    }
  }
}
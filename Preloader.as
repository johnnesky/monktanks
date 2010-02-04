package {
  import flash.display.*;
  import flash.events.Event;
  import flash.utils.getDefinitionByName;
  
  public class Preloader extends MovieClip {
    public function Preloader() {
      stop();
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function onEnterFrame(event:Event): void {
      graphics.clear();
      
      if(framesLoaded == totalFrames) {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        nextFrame();
        init();
        return;
      }
      var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
      
      graphics.beginFill(0xffffff, 0.5)
      graphics.drawRect(stage.stageWidth / 2 - 150, stage.stageHeight / 2 - 7, 300, 15)
      graphics.endFill()
      graphics.beginFill(0x0000a0, 0.5)
      graphics.drawRect(stage.stageWidth / 2 - 148, stage.stageHeight / 2 - 5, percent * 296.0, 11)
      graphics.endFill()
    }
    
    private function init(): void {
      var mainClass:Class = Class(getDefinitionByName("MonkTanks"));
      if(mainClass) {
        var app:Object = new mainClass();
        addChild(app as DisplayObject);
        app.init();
      }
    }
  }
}

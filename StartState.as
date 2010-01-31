package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class StartState extends GameState {
    [Embed(source='Start_Screen.png')]
    private static const _screenSpriteClass: Class;
    
    [Embed(source='select_map_1.png')]
    private static const _map1SpriteClass: Class;
    
    [Embed(source='select_map_2.png')]
    private static const _map2SpriteClass: Class;
    
    [Embed(source='select_map_3.png')]
    private static const _map3SpriteClass: Class;
    
    private static const thumbnailList: Array = [_map1SpriteClass, _map2SpriteClass, _map3SpriteClass];
    
    public function StartState(stage: Stage) {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      
      addChild(new _screenSpriteClass());
      
      for (var i: int = 0; i < thumbnailList.length; i++) {
        var thumbnail: DisplayObject;
        thumbnail = new thumbnailList[i]();
        thumbnail.x = 400 - thumbnail.width / 2;
        thumbnail.y = 200 + 120 * i;
        var container: Sprite = new Sprite();
        container.addChild(thumbnail);
        addChild(container);
        container.addEventListener(MouseEvent.CLICK, onClick);
      }
    }
    
    public override function destroy(): void {
      stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }
    
    private function onKeyDown(event: KeyboardEvent): void {
      switch (event.keyCode) {
        case 32:
          PlayState.levelNumber = Math.random() * 3;
          MonkTanks.state = MonkTanks.PLAY_STATE;
          break;
      }
    }
    
    private function onKeyUp(event: KeyboardEvent): void {
      switch (event.keyCode) {
        case 32:
          break;
      }
    }
    
    private function onClick(event: MouseEvent): void {
      var index: int = getChildIndex(event.target as DisplayObject);
      PlayState.levelNumber = index - 1;
      MonkTanks.state = MonkTanks.PLAY_STATE;
    }
  }
}
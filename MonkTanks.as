package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  import flash.ui.*;
  import flash.desktop.*;
  
  [SWF(width=800, height=600, frameRate=30, backgroundColor=0x000000)]
  [Frame(factoryClass="Preloader")]
  public class MonkTanks extends Sprite {
    public static const START_STATE: int    = 0;
    public static const PLAY_STATE: int     = 1;
    public static const END_STATE: int      = 2;
    
    private static var _state: int;
    private static var _gameStateInstance: GameState;
    
    private static var _instance: MonkTanks;
    
    public function MonkTanks(){}
    
    public function init(): void {

      // MochiBot.com -- Version 8
      // Tested with Flash 9-10, ActionScript 3
      MochiBot.track(this, "1d097f1a");
      
      _instance = this;
      state = START_STATE;
      addEventListener(Event.ENTER_FRAME, update);
      
      // Some cruft to enable pasting text through right click menu:
      var myContextMenu: ContextMenu = new ContextMenu();
      myContextMenu.hideBuiltInItems();
      myContextMenu.clipboardMenu = true;
      var items: ContextMenuClipboardItems = new ContextMenuClipboardItems();
      items.paste = true;
      myContextMenu.clipboardItems = items;
      contextMenu = myContextMenu;
      addEventListener(Event.PASTE, onPaste);
      
      graphics.beginFill(0x004400);
      graphics.drawRect(0,0,800, 600);
      graphics.endFill();
    }
    
    private function onPaste(event: Event): void {
      try {
        var clipboard: Clipboard = Clipboard.generalClipboard;
        var string: String = clipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
        var xml: XML = XML(string);
        if (xml != null && xml.toXMLString() != "" && xml.children().length() > 0) {
          PlayState.levelXMLs[2] = xml;
          PlayState.levelNumber = 2;
          state = START_STATE;
          state = PLAY_STATE;
        }
      } catch (error: Error) {}
    }
    
    public static function get state(): int {
      return _state;
    }
    
    public static function set state(val: int): void {
      if (_gameStateInstance != null) {
        _gameStateInstance.destroy();
        _instance.removeChild(_gameStateInstance);
      }
      
      _state = val;
      
      switch(_state) {
        case START_STATE:
          _gameStateInstance = new StartState(_instance.stage);
          break;
        case PLAY_STATE:
          _gameStateInstance = new PlayState(_instance.stage);
          break;
        case END_STATE:
          _gameStateInstance = new EndState(_instance.stage);
          break;
      }
      _instance.addChild(_gameStateInstance);
    }
    
    private function update(event: Event): void {
      _gameStateInstance.update(33);
    }
  }
}
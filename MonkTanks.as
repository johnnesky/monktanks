package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  import flash.ui.*;
  import flash.desktop.*;
  
  [SWF(width=800, height=600, frameRate=30, backgroundColor=0x000000)]
  public class MonkTanks extends Sprite {
    public static const PLAY_STATE: int     = 188;
    public static const END_STATE: int      = 190;
    
    private static var _state: int;
    private static var _gameStateInstance: GameState;
    
    private static var _instance: MonkTanks;
    
    public function MonkTanks(){
      _instance = this;
      state = PLAY_STATE;
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
          PlayState.levelXML = xml;
          state = END_STATE;
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
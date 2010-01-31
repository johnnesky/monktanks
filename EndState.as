package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  import flash.net.*;
  
  public class EndState extends GameState {
    [Embed(source="Background.png")]
    private static var background1Class: Class;
    
    [Embed(source="Background3.png")]
    private static var background2Class: Class;
    
    public static var victor: int = 0;
    
    public function EndState(stage: Stage) {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      
      if (victor == 0) {
        addChild(new background1Class());
      } else {
        addChild(new background2Class());
      }
      
      new SoundEffectManager.victory().play();
      
      addEventListener(MouseEvent.CLICK, onClick);
    }
    
    public override function update(ticks: int): void {
    }
    
    public override function destroy(): void {
      stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }
    
    private function onKeyDown(event: KeyboardEvent): void {
      switch (event.keyCode) {
        case 32:
          MonkTanks.state = MonkTanks.START_STATE;
          break;
      }
    }
    
    private function onKeyUp(event: KeyboardEvent): void {
      switch (event.keyCode) {
        case 32:
          break;
      }
    }
    
    private function onClick(event: Event): void {
      if (mouseY > 400) {
        if (mouseX < 800 / 3) {
          MonkTanks.state = MonkTanks.PLAY_STATE;
        } else if (mouseX < 800 * 2 / 3) {
          MonkTanks.state = MonkTanks.START_STATE;
        } else {
		    	var request:URLRequest = new URLRequest("http://globalgamejam.org/2010/monk-multiplicitous-observable-navigational-killerator");
    			try {
		    		navigateToURL(request, '_blank');
    			} catch (e:Error) {
		    		//trace("Error occurred!");
    			}
        }
      }
    }
  }
}
package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class PlayState extends GameState {
    [Embed(source="Tank1.png")]
    private static var canopyClass: Class;
    
    private static var spriteList: Object = {
      canopy: canopyClass
    }
    
    public static var levelXML: XML = 
      <level>
        <layer>
          <sprite x="300" y="200" rotation="0"  type="water"/>
          <sprite x="400" y="200" rotation="90" type="wall"/>
        </layer>
        <actionLayer>
          <tank x="100" y="300" rotation="0"  type="skunk" player="1"/>
          <tank x="700" y="300" rotation="90" type="punk"  player="2"/>
        </actionLayer>
        <layer>
          <sprite x="200" y="500" rotation="0"  type="canopy"/>
          <sprite x="500" y="100" rotation="90" type="cloud"/>
        </layer>
      </level>
    
    public static const P1_FORWARD_KEY: int = 87;
    public static const P1_BACK_KEY: int    = 83;
    public static const P1_LEFT_KEY: int    = 65;
    public static const P1_RIGHT_KEY: int   = 68;
    public static const P1_FIRE_KEY: int    = 88;
    public static const P1_CLONE_KEY: int   = 67;
    public static const P2_FORWARD_KEY: int = 38;
    public static const P2_BACK_KEY: int    = 40;
    public static const P2_LEFT_KEY: int    = 37;
    public static const P2_RIGHT_KEY: int   = 39;
    public static const P2_FIRE_KEY: int    = 191;
    public static const P2_CLONE_KEY: int   = 190;
    
    private var actionLayer: Sprite;
    private var entities: Array = [];
    private var tank1 : Tank;
    private var tank2 : Tank;
    
    public function PlayState(stage: Stage) {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      
			var ns: Namespace = levelXML.namespace("");
			
			trace("parsing", levelXML.toXMLString());
			
      for each (var layerXML: XML in levelXML.children()) {
        switch (String(layerXML.localName())) {
          case "layer": 
            var layerSprite: Sprite = new Sprite();
            addChild(layerSprite);
            
            for each (var spriteXML: XML in layerXML.sprite) {
              var spriteClass: Class = spriteList[String(spriteXML.@type)];
              if (spriteClass == null) {
                var tempSprite: Sprite = new Sprite();
                layerSprite.addChild(tempSprite);
                tempSprite.rotation = spriteXML.@rotation;
                tempSprite.graphics.beginFill(0x0000ff);
                tempSprite.graphics.drawCircle(0, 0, 20);
                tempSprite.graphics.endFill();
                tempSprite.x = spriteXML.@x;
                tempSprite.y = spriteXML.@y;
              } else {
                var sprite: DisplayObject = new spriteClass();
                layerSprite.addChild(sprite);
                sprite.rotation = spriteXML.@rotation;
                sprite.x = spriteXML.@x;
                sprite.y = spriteXML.@y;
                sprite.x -= sprite.width/2;
                sprite.y -= sprite.height/2;
              }
            }
            
            break;
          case "actionLayer": 
            actionLayer = new Sprite();
            addChild(actionLayer);
            
            for each (var tankXML: XML in layerXML.tank) {
              var tank: Tank = new Tank(tankXML.@x, tankXML.@y, this);
              tank.rotation = tankXML.@rotation;
              addEntity(tank);
              if (tankXML.@player == "1") {
                tank1 = tank;
              } else {
                tank2 = tank;
              }
            }
            
            break;
        }
      }
    }
    
    public function addEntity(entity: Entity): void {
      entities.push(entity);
      actionLayer.addChild(entity);
    }
    
    public function removeEntity(entity: Entity): void {
      actionLayer.removeChild(entity);
      var i : int = entities.indexOf(entity, 0);
      entities.splice(i, 1);
    }
    
    public override function update(ticks: int): void {
      for each (var entity: Entity in entities) {
        entity.update(33);
      }
    }
    
    public override function destroy(): void {
      stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }
    
    private function onKeyDown(event: KeyboardEvent): void {
      switch (event.keyCode) {
        case P1_FORWARD_KEY:
          tank1.keydown(Tank.ACTION_FORWARD, true);
          break;
        case P1_BACK_KEY:
          tank1.keydown(Tank.ACTION_BACK, true);
          break;
        case P1_LEFT_KEY:
          tank1.keydown(Tank.ACTION_LEFT, true);
          break;
        case P1_RIGHT_KEY:
          tank1.keydown(Tank.ACTION_RIGHT, true);
          break;
        case P1_FIRE_KEY:
          tank1.keydown(Tank.ACTION_FIRE, true);
          break;
        case P1_CLONE_KEY:
          tank1.keydown(Tank.ACTION_CLONE, true);
          break;
        case P2_FORWARD_KEY:
          tank2.keydown(Tank.ACTION_FORWARD, true);
          break;
        case P2_BACK_KEY:
          tank2.keydown(Tank.ACTION_BACK, true);
          break;
        case P2_LEFT_KEY:
          tank2.keydown(Tank.ACTION_LEFT, true);
          break;
        case P2_RIGHT_KEY:
          tank2.keydown(Tank.ACTION_RIGHT, true);
          break;
        case P2_FIRE_KEY:
          tank2.keydown(Tank.ACTION_FIRE, true);
          break;
        case P2_CLONE_KEY:
          tank2.keydown(Tank.ACTION_CLONE, true);
          break;
        case 32:
          MonkTanks.state = MonkTanks.END_STATE;
          break;
      }
    }
    
    private function onKeyUp(event: KeyboardEvent): void {
      switch (event.keyCode) {
        case P1_FORWARD_KEY:
          tank1.keydown(Tank.ACTION_FORWARD, false);
          break;
        case P1_BACK_KEY:
          tank1.keydown(Tank.ACTION_BACK, false);
          break;
        case P1_LEFT_KEY:
          tank1.keydown(Tank.ACTION_LEFT, false);
          break;
        case P1_RIGHT_KEY:
          tank1.keydown(Tank.ACTION_RIGHT, false);
          break;
        case P1_FIRE_KEY:
          tank1.keydown(Tank.ACTION_FIRE, false);
          break;
        case P1_CLONE_KEY:
          tank1.keydown(Tank.ACTION_CLONE, false);
          break;
        case P2_FORWARD_KEY:
          tank2.keydown(Tank.ACTION_FORWARD, false);
          break;
        case P2_BACK_KEY:
          tank2.keydown(Tank.ACTION_BACK, false);
          break;
        case P2_LEFT_KEY:
          tank2.keydown(Tank.ACTION_LEFT, false);
          break;
        case P2_RIGHT_KEY:
          tank2.keydown(Tank.ACTION_RIGHT, false);
          break;
        case P2_FIRE_KEY:
          tank2.keydown(Tank.ACTION_FIRE, false);
          break;
        case P2_CLONE_KEY:
          tank2.keydown(Tank.ACTION_CLONE, false);
          break;
      }
    }
  }
}

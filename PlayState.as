package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  import Box2D.Dynamics.*;
  import Box2D.Collision.*;
  import Box2D.Collision.Shapes.*;
  import Box2D.Common.Math.*;
    
  public class PlayState extends GameState {
    [Embed(source="canopy.png")]
    private static var canopyClass: Class;
    
    [Embed(source="Clouds.png")]
    private static var cloudsClass: Class;
    
    [Embed(source="Building1.swf", symbol="Building1")]
    private static var building1Class: Class;
    
    [Embed(source="Building2.swf", symbol="Building2")]
    private static var building2Class: Class;
    
    [Embed(source="backgroundGrid.png")]
    private static var gridClass: Class;
    
    private static var spriteList: Object = {
      canopy: canopyClass,
      clouds: cloudsClass,
      building1: building1Class,
      building2: building2Class,
      grid: gridClass
    }
    
    public static var levelXML: XML = 
      <level>
        <layer>
         <sprite x="400" y="300" rotation="0" type="grid"/>
        </layer>
        <actionLayer>
         <tank x="200" y="300" rotation="90" type="skunk" player="1"/>
         <tank x="600" y="300" rotation="-90" type="punk" player="2"/>
        </actionLayer>
        <layer>
        <!-- Central Boxes -->
         <sprite x="400" y="300" rotation="0" type="building1"/>
         <sprite x="400" y="400" rotation="0" type="building2"/>
         <sprite x="400" y="600" rotation="0" type="canopy"/>
        <!-- Left Walls -->
         <sprite x="200" y="200" rotation="0" type="canopy"/>
         <sprite x="200" y="400" rotation="0" type="canopy"/>
         <sprite x="0" y="300" rotation="0" type="canopy"/>
        <!-- Right Walls -->
         <sprite x="600" y="200" rotation="0" type="canopy"/>
         <sprite x="600" y="400" rotation="0" type="canopy"/>
         <sprite x="800" y="300" rotation="0" type="canopy"/>
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
    public var tank1 : Tank;
    public var tank2 : Tank;
    public var physWorld : b2World;
      
    public function PlayState(stage: Stage) {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      
      // Initialize physics container
      // Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0);
			
			// Construct a world object
			physWorld = new b2World( gravity, false);
      
      var ns: Namespace = levelXML.namespace("");
      trace("parsing", levelXML.toXMLString());
			
      for each (var layerXML: XML in levelXML.children()) {
        switch (String(layerXML.localName())) {
          case "layer": 
            var layerSprite: Sprite = new Sprite();
            addChild(layerSprite);
            
            for each (var spriteXML: XML in layerXML.sprite) {
              //trace(spriteXML.@type, spriteXML.toXMLString());
              
              for each (var xml: XML in spriteXML.attributes()) {
                trace(xml.name());
              }
              
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
                if (sprite is Bitmap) {
                  sprite.x -= sprite.width/2;
                  sprite.y -= sprite.height/2;
                }
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
        entity.update(ticks);
      }
      
      physWorld.Step(ticks, 10, 10);
			
			// Go through body list and update sprite positions/rotations
      var i : int = 0;
			for (var bb:b2Body = physWorld.GetBodyList(); bb; bb = bb.GetNext())
      {
				if (bb.GetUserData() is Entity)
        {
          if (bb.GetPosition().x < -15.0/20.0)
            bb.GetPosition().x += 830.0/20.0;
          if (bb.GetPosition().x > 815.0/20.0)
            bb.GetPosition().x -= 830.0/20.0;
          if (bb.GetPosition().y < -15.0/20.0)
            bb.GetPosition().y += 630.0/20.0;
          if (bb.GetPosition().y > 615.0/20.0)
            bb.GetPosition().y -= 630.0/20.0;
          
					entity = bb.GetUserData() as Entity;
					entity.x = bb.GetPosition().x*20.0;
					entity.y = bb.GetPosition().y*20.0;
					entity.rotation = bb.GetAngle();
				}
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

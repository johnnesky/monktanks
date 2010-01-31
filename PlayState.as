package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  import Box2D.Dynamics.*;
  import Box2D.Dynamics.Contacts.*;
  import Box2D.Collision.*;
  import Box2D.Collision.Shapes.*;
  import Box2D.Common.Math.*;
    
  public class PlayState extends GameState {
    [Embed(source="canopy.png")]
    private static var canopyClass: Class;
    
    [Embed(source="Clouds.png")]
    private static var cloudsClass: Class;
    
    [Embed(source="wall1.png")]
    private static var wall1Class: Class;
    
    [Embed(source="wall2.png")]
    private static var wall2Class: Class;
    
    [Embed(source="rocks1.png")]
    private static var rocks1Class: Class;
    
    [Embed(source="Building1.swf", symbol="Building1")]
    private static var building1Class: Class;
    
    [Embed(source="Building2.swf", symbol="Building2")]
    private static var building2Class: Class;
    
    [Embed(source="backgroundGrid.png")]
    private static var gridClass: Class;
    
    [Embed(source="Background.png")]
    private static var background1Class: Class;
    
    private static var spriteList: Object = {
      canopy: canopyClass,
      clouds: cloudsClass,
      wall1: wall1Class,
      wall2: wall2Class,
      rocks1: rocks1Class,
      building1: building1Class,
      building2: building2Class,
      grid: gridClass,
      background1: background1Class
    }
    
    private static var boundingBoxList: Object = {
      wall1: {width: 20, height: 100},
      wall2: {width: 20, height: 100},
      rocks1: {width: 40, height: 40},
      building1: {width: 180, height: 110},
      building2: {width: 120, height: 120}
    }
    
    public static var levelXML: XML = 
      <level>
       <layer>
         <sprite x="400" y="300" rotation="0" type="background1"/>
       </layer>
       <actionLayer>
         <tank x="150" y="300" rotation="90" type="skunk" player="1"/>
         <tank x="650" y="300" rotation="-90" type="punk" player="2"/>
       </actionLayer>
       <layer>
      <!-- Power Ups -->
         <sprite x="250" y="300" rotation="45" type="powerup" scale=".5"/>
      <!-- Central Boxes -->   <sprite x="400" y="300" rotation="45" type="building2"/>
         <sprite x="400" y="000" rotation="0" type="canopy" scale="1.25"/>
         <sprite x="400" y="600" rotation="0" type="canopy" scale="1.25"/>
      <!-- Left Walls -->
         <sprite x="200" y="400" rotation="0" type="canopy" scale="1.0"/>
         <sprite x="0" y="300" rotation="90" type="building1"/>
         <sprite x="200" y="150" rotation="0" type="building1"/>
      <!-- Right Walls -->
         <sprite x="600" y="200" rotation="0" type="canopy"/>
         <sprite x="800" y="300" rotation="90" type="building1"/>
         <sprite x="600" y="450" rotation="180" type="building1"/>
      <!-- Clouds -->
         <sprite x="300" y="500" rotation="0" type="clouds" scale="1.0"/>
         <sprite x="500" y="100" rotation="0" type="clouds" scale="1.0"/>
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
    private var matchEnded: Boolean = false;
    private var ticksUntilEndScreen: int = 1000;
    
    public function PlayState(stage: Stage) {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      
      // Initialize physics container
      // Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0);
			
			// Construct a world object
			physWorld = new b2World( gravity, false);
      
      var ns: Namespace = levelXML.namespace("");
			
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
                if (spriteXML.@scale != undefined) {
                  tempSprite.scaleX = tempSprite.scaleY = spriteXML.@scale;
                }
                sprite = tempSprite;
              } else {
                var sprite: DisplayObject = new spriteClass();
                var container: Sprite = new Sprite();
                container.addChild(sprite);
                layerSprite.addChild(container);
                container.rotation = spriteXML.@rotation;
                container.x = spriteXML.@x;
                container.y = spriteXML.@y;
                if (spriteXML.@scale != undefined) {
                  container.scaleX = container.scaleY = spriteXML.@scale;
                }
                if (sprite is Bitmap) {
                  sprite.x -= sprite.width/2;
                  sprite.y -= sprite.height/2;
                }
              }
              
              var bounds: Object = boundingBoxList[String(spriteXML.@type)];
              if (bounds != null) {
                var bodyDef: b2BodyDef;
                var body: b2Body;
                var boxShape:b2PolygonShape;
                bodyDef = new b2BodyDef();
                bodyDef.position.x = Number(spriteXML.@x)/20.0;
                bodyDef.position.y = Number(spriteXML.@y)/20.0;
                bodyDef.angle = Number(spriteXML.@rotation) * Math.PI / 180;
                boxShape = new b2PolygonShape();
                boxShape.SetAsBox(bounds.width / 40, bounds.height / 40);
                var fixtureDef:b2FixtureDef = new b2FixtureDef();
                fixtureDef.shape = boxShape;
                fixtureDef.density = 0.0;
                fixtureDef.friction = 0.3;
                fixtureDef.restitution = 0.0;
                body = physWorld.CreateBody(bodyDef);
                body.SetType(b2Body.b2_staticBody);
                body.CreateFixture(fixtureDef);
                  
                // Set up what this will collide with
                var fixture:b2Fixture = body.GetFixtureList();
                while (fixture)
                {
                  var filterData : b2FilterData = new b2FilterData;
                  filterData.categoryBits = Entity.BIT_ENVIRO
                  filterData.maskBits     = Entity.BIT_TANK | Entity.BIT_HOLOGRAM | Entity.BIT_BULLET | Entity.BIT_ENVIRO
                  fixture.SetFilterData(filterData);
                  fixture = fixture.GetNext();
                }
              }
            }
            
            break;
          case "actionLayer": 
            actionLayer = new Sprite();
            addChild(actionLayer);
            
            for each (var tankXML: XML in layerXML.tank) {
              var tank: Tank = new Tank(tankXML.@x, tankXML.@y, tankXML.@rotation, this, false);
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
      if (matchEnded) {
        ticksUntilEndScreen -= ticks;
        if (ticksUntilEndScreen <= 0) {
          MonkTanks.state = MonkTanks.END_STATE;
          return;
        }
      }
      
      
      var contact: b2Contact = physWorld.GetContactList();
      while (contact != null) {
        var tank: Tank = null;
        if (contact.GetFixtureA().GetBody().GetUserData() is Tank) {
          tank = contact.GetFixtureA().GetBody().GetUserData();
        } else if (contact.GetFixtureB().GetBody().GetUserData() is Tank) {
          tank = contact.GetFixtureB().GetBody().GetUserData();
        }
        var bullet: Bullet = null;
        if (contact.GetFixtureA().GetBody().GetUserData() is Bullet) {
          bullet = contact.GetFixtureA().GetBody().GetUserData();
        } else if (contact.GetFixtureB().GetBody().GetUserData() is Bullet) {
          bullet = contact.GetFixtureB().GetBody().GetUserData();
        }
        
        if (bullet != null && tank != null) {
          if (bullet.shooter != tank) {
            bullet.kill();
            tank.hit();
            if (tank.markedAsDead) {
              matchEnded = true;
            }
          }
        } else if (bullet != null) {
          bullet.kill();
        }
        
        contact = contact.GetNext();
      }
      
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

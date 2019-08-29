package {
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
    [Embed(source="Blimp.png")]
    private static var blimpClass: Class;
    
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
    
    //[Embed(source="backgroundGrid.png")]
    //private static var gridClass: Class;
    
    [Embed(source="Background.jpg")]
    private static var background1Class: Class;
    
    [Embed(source="Background3.jpg")]
    private static var background2Class: Class;
    
    [Embed(source="BackgroundForest_1.jpg")]
    private static var background3Class: Class;
    
    [Embed(source="Shadow_Building1.png")]
    private static var building1ShadowClass: Class;
    
    [Embed(source="Shadow_Building_Vertical1.png")]
    private static var building1VerticalShadowClass: Class;
    
    [Embed(source="Shadow_Building2.png")]
    private static var building2ShadowClass: Class;
    
    [Embed(source="Shadow_Building2_noAngle.png")]
    private static var building2NoAngleShadowClass: Class;
    
    [Embed(source="Shadow_Cloud.png")]
    private static var cloudShadowClass: Class;
    
    [Embed(source="Shadow_Tree.png")]
    private static var canopyClass: Class;
    
    [Embed(source="Shadow_Wall1.png")]
    private static var wall1ShadowClass: Class;
    
    [Embed(source="Shadow_Wall_Horizontal1.png")]
    private static var wall1HorizontalShadowClass: Class;
    
    [Embed(source='iconSkunk.png')]
    private static var IconSkunkClass:Class;
  
    [Embed(source='iconPunk.png')]
    private static var IconPunkClass:Class;
        
    private static var spriteList: Object = {
      canopy: canopyClass,
      wall1: wall1Class,
      wall2: wall2Class,
      rocks1: rocks1Class,
      building1: building1Class,
      building2: building2Class,
      //grid: gridClass,
      background1: background1Class,
      background2: background2Class,
      background3: background3Class,
      building1Shadow: building1ShadowClass,
      building1VerticalShadow: building1VerticalShadowClass,
      building2Shadow: building2ShadowClass,
      building2NoAngleShadow: building2NoAngleShadowClass,
      wall1Shadow: wall1ShadowClass,
      wall1HorizontalShadow: wall1HorizontalShadowClass
    }
    
    private static var boundingBoxList: Object = {
      wall1: {width: 20, height: 100},
      wall2: {width: 20, height: 100},
      rocks1: {width: 40, height: 40},
      building1: {width: 180, height: 110},
      building2: {width: 120, height: 120}
    }
    
    public static var levelXMLs: Array = [
      <level>
        <layer>
          <sprite x="400" y="300" rotation="0" type="background1"/>
        </layer>
        <actionLayer>
          <tank x="150" y="300" rotation="90" type="skunk" player="1"/>
          <tank x="650" y="300" rotation="-90" type="punk" player="2"/>
        </actionLayer>
        <layer>
      <!-- Center -->
          <sprite x="425" y="325" rotation="0" type="building2Shadow"/>
          <sprite x="400" y="300" rotation="45" type="building2"/>
          <sprite x="400" y="000" rotation="0" type="canopy" scale="1.25"/>
          <sprite x="400" y="600" rotation="0" type="canopy" scale="1.25"/>
      <!-- Left Walls -->
          <sprite x="200" y="400" rotation="0" type="canopy" scale="1.0"/>
          <sprite x="25" y="325" rotation="0" type="building1VerticalShadow"/>
          <sprite x="0" y="300" rotation="90" type="building1"/>
          <sprite x="225" y="175" rotation="0" type="building1Shadow"/>
          <sprite x="200" y="150" rotation="0" type="building1"/>
      <!-- Right Walls -->
          <sprite x="600" y="200" rotation="0" type="canopy"/>
          <sprite x="830" y="325" rotation="0" type="building1VerticalShadow"/>
          <sprite x="800" y="300" rotation="90" type="building1"/>
          <sprite x="625" y="475" rotation="00" type="building1Shadow"/> 
          <sprite x="600" y="450" rotation="180" type="building1"/>
        </layer>
      </level>,
      
      <level>
         <layer>
          <sprite x="400" y="300" rotation="0" type="background2"/>
         </layer>
         <layer>
        <!-- Rocks -->
          <sprite x="225" y="475" rotation="0" type="rocks1" scale="1"/>
          <sprite x="355" y="570" rotation="90" type="rocks1" scale="1"/>
          
          <sprite x="470" y="475" rotation="0" type="rocks1" scale=".9"/>
          <sprite x="485" y="470" rotation="220" type="rocks1" scale=".9"/>
        </layer>
         <actionLayer>
          <tank x="250" y="250" rotation="90" type="skunk" player="1"/>
          <tank x="575" y="250" rotation="-90" type="punk" player="2"/>
         </actionLayer>
         <layer>
        <!-- Forest -->
          <sprite x="100" y="500" rotation="0" type="canopy" scale="1"/>
          <sprite x="225" y="550" rotation="0" type="canopy" scale="1.1"/>
          <sprite x="350" y="395" rotation="0" type="canopy" scale="1"/>
          <sprite x="475" y="380" rotation="0" type="canopy" scale=".7"/>
          <sprite x="475" y="540" rotation="0" type="canopy" scale=".8"/>
          <sprite x="550" y="500" rotation="0" type="canopy" scale=".8"/>
          <sprite x="650" y="-30" rotation="0" type="canopy" scale="1.25"/>
          <sprite x="650" y="570" rotation="0" type="canopy" scale="1.25"/>
          
          <sprite x="770" y="500" rotation="0" type="canopy" scale="1.25"/>
          <sprite x="-30" y="500" rotation="0" type="canopy" scale="1.25"/>
          
        <!-- Left -->
          <sprite x="265" y="205" rotation="0" type="wall1HorizontalShadow"/>
          <sprite x="365" y="205" rotation="0" type="wall1HorizontalShadow"/>
          <sprite x="210" y="215" rotation="0" type="wall1Shadow"/>
          <sprite x="210" y="310" rotation="0" type="wall1Shadow"/>
      
        <sprite x="168" y="172" rotation="0" type="building2NoAngleShadow" scale="1.3"/>
      
        <sprite x="245" y="195" rotation="90" type="wall2"/>
          <sprite x="345" y="195" rotation="90" type="wall2"/>
          <sprite x="200" y="200" rotation="0" type="wall2"/>
          <sprite x="200" y="300" rotation="0" type="wall2"/>
          <sprite x="150" y="150" rotation="0" type="building2"/>
        <!-- Right -->
          <sprite x="400" y="80" rotation="0" type="wall1HorizontalShadow"/>
          <sprite x="500" y="80" rotation="0" type="wall1HorizontalShadow"/>
          <sprite x="600" y="80" rotation="0" type="wall1HorizontalShadow"/>
          <sprite x="530" y="262" rotation="0" type="wall1Shadow"/>
          <sprite x="625" y="375" rotation="0" type="building1Shadow"/>
          <sprite x="380" y="70" rotation="90" type="wall1"/>
          <sprite x="480" y="70" rotation="90" type="wall1"/>
          <sprite x="580" y="70" rotation="90" type="wall1"/>
          <sprite x="520" y="242" rotation="0" type="wall1"/>
          <sprite x="600" y="350" rotation="0" type="building1"/>
        </layer>
      </level>,
      
      <level>
        <layer>
          <sprite x="400" y="300" rotation="0" type="background3"/>
        </layer>
        <layer>
      <!-- Rocks -->
          <sprite x="40" y="175" rotation="0" type="rocks1" scale="1"/>
          <sprite x="80" y="400" rotation="60" type="rocks1" scale="1"/>
          <sprite x="380" y="100" rotation="30" type="rocks1" scale="1"/>
          <sprite x="425" y="480" rotation="-90" type="rocks1" scale="1"/>
          <sprite x="500" y="280" rotation="90" type="rocks1" scale="1"/>
          <sprite x="685" y="450" rotation="270" type="rocks1" scale="1"/>
          <sprite x="705" y="200" rotation="0" type="rocks1" scale="1"/>
        </layer>
        <actionLayer>
          <tank x="225" y="300" rotation="90" type="skunk" player="1"/>
          <tank x="575" y="300" rotation="-90" type="punk" player="2"/>
        </actionLayer>
        <layer>
      <!-- Walls -->
          <sprite x="196" y="318" rotation="0" type="wall1Shadow"/>
          <sprite x="276" y="318" rotation="0" type="wall1Shadow"/>
          <sprite x="245" y="250" rotation="0" type="wall1HorizontalShadow"/>
          <sprite x="185" y="300" rotation="0" type="wall2"/>
          <sprite x="225" y="240" rotation="90" type="wall2"/>
          <sprite x="265" y="300" rotation="0" type="wall2"/>
          
          <sprite x="546" y="318" rotation="0" type="wall1Shadow"/>
          <sprite x="626" y="318" rotation="0" type="wall1Shadow"/>
          <sprite x="595" y="370" rotation="0" type="wall1HorizontalShadow"/>
          <sprite x="535" y="300" rotation="0" type="wall1"/>
          <sprite x="575" y="360" rotation="90" type="wall1"/>
          <sprite x="615" y="300" rotation="0" type="wall1"/>
      <!-- Forest -->
          <sprite x="150" y="-25" rotation="0" type="canopy" scale="1"/>
          <sprite x="150" y="575" rotation="0" type="canopy" scale="1"/>
          
          <sprite x="80" y="300" rotation="0" type="canopy" scale="1.5"/>
          <sprite x="300" y="500" rotation="0" type="canopy" scale="1.5"/>
          
          <sprite x="225" y="100" rotation="0" type="canopy" scale="1"/>
          <sprite x="350" y="200" rotation="0" type="canopy" scale="1"/>
          <sprite x="600" y="150" rotation="0" type="canopy" scale="1"/>
          
          <sprite x="400" y="300" rotation="0" type="canopy" scale="1.2"/>
          
          <sprite x="500" y="420" rotation="0" type="canopy" scale="1"/>
          
          <sprite x="770" y="100" rotation="0" type="canopy" scale="1.25"/>
          <sprite x="-30" y="100" rotation="0" type="canopy" scale="1.25"/>
          
          <sprite x="830" y="500" rotation="0" type="canopy" scale="1.25"/>
          <sprite x="30" y="500" rotation="0" type="canopy" scale="1.25"/>
          
          <sprite x="600" y="560" rotation="0" type="canopy" scale="1.75"/>
          <sprite x="600" y="-40" rotation="0" type="canopy" scale="1.75"/>
        </layer>
      </level>
    ];
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
    
    public static var levelNumber: int = 0;
    
    private var actionLayer: Sprite;
    private var cloudLayer: Sprite;
    private var clouds: Array = [];
    private var blimp: DisplayObject;
    private var hudLayer: Sprite;
    private var entities: Array = [];
    public var tank1 : Tank;
    public var tank2 : Tank;
    public var physWorld : b2World;
    public var health1 : HudBar;
    public var health2 : HudBar;
    public var reload1 : HudBar;
    public var reload2 : HudBar;
    private var matchEnded: Boolean = false;
    private var ticksUntilEndScreen: int = 3000;
    private var ticksUntilPowerup: int;
    private var ticksUntilCloud: int;
    
    public function PlayState(stage: Stage) {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      
      // Initialize physics container
      // Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0);
			
			// Construct a world object
			physWorld = new b2World( gravity, false);
      
      for each (var layerXML: XML in levelXMLs[levelNumber].children()) {
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
                bodyDef.userData = new String(spriteXML.@type);
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
                  filterData.maskBits     = Entity.BIT_TANK1 | Entity.BIT_TANK2 | Entity.BIT_HOLOGRAM1 | Entity.BIT_HOLOGRAM2 | Entity.BIT_BULLET1 | Entity.BIT_BULLET2 | Entity.BIT_ENVIRO
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
              var type: int;
              if (tankXML.@type == "monk") {
                type = Tank.TYPE_MONK;
              } else if (tankXML.@type == "punk") {
                type = Tank.TYPE_PUNK;
              } else if (tankXML.@type == "skunk") {
                type = Tank.TYPE_SKUNK;
              }
              var tank: Tank = new Tank(tankXML.@x, tankXML.@y, tankXML.@rotation, type, this, tankXML.@player, null);
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
      
      cloudLayer = new Sprite();
      addChild(cloudLayer);
      
      for (var i: int = 0; i < 4; i++) {
        var cloud: DisplayObject = new cloudShadowClass();
        cloud.x = Math.random() * 800;
        cloud.y = Math.random() * 600;
        
        var j: int = 0;
        for (; j < clouds.length; j++) {
          if (clouds[j].y > cloud.y) {
            cloudLayer.addChildAt(cloud, cloudLayer.getChildIndex(clouds[j]));
            clouds.splice(j, 0, cloud);
            break;
          }
        }
        if (j == clouds.length) {
          cloudLayer.addChild(cloud);
          clouds.push(cloud);
        }
      }
      ticksUntilCloud = 2000 + Math.random() * 8000;
      
      blimp = new blimpClass();
      blimp.x = Math.random() * 800 - blimp.width / 2;
      blimp.y = 600;
      cloudLayer.addChild(blimp);
      
      // Initialize health and reload meters
      hudLayer = new Sprite();
      addChild(hudLayer);
      health1 = new HudBar(20,  5,  0xa00000, true)
      reload1 = new HudBar(20,  15, 0x0000a0, true)
      health2 = new HudBar(230, 5,  0xa00000, false)
      reload2 = new HudBar(230, 15, 0x0000a0, false)
      entities.push(health1);
      hudLayer.addChild(health1);
      entities.push(health2);
      hudLayer.addChild(health2);
      entities.push(reload1);
      hudLayer.addChild(reload1);
      entities.push(reload2);
      hudLayer.addChild(reload2);
      
      var iconSkunk:Bitmap = new IconSkunkClass();
      iconSkunk.x=5
      iconSkunk.y=6
      iconSkunk.scaleX = iconSkunk.scaleY = 0.85;
      hudLayer.addChild(iconSkunk)
      var iconPunk:Bitmap = new IconPunkClass();
      iconPunk.x=795-iconPunk.width
      hudLayer.addChild(iconPunk)
      
      ticksUntilPowerup = 10000 + 5000 * Math.random();
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
      var i : int = 0;
      
      if (matchEnded) {
        ticksUntilEndScreen -= ticks;
        if (ticksUntilEndScreen <= 0) {
          MonkTanks.state = MonkTanks.END_STATE;
          return;
        }
      }
      
      ticksUntilCloud -= ticks;
      if (ticksUntilCloud <= 0) {
        var cloud: DisplayObject = new cloudShadowClass();
        cloud.x = -400;
        cloud.y = Math.random() * 600;
        
        var j: int = 0;
        for (; j < clouds.length; j++) {
          if (clouds[j].y > cloud.y) {
            cloudLayer.addChildAt(cloud, cloudLayer.getChildIndex(clouds[j]));
            clouds.splice(j, 0, cloud);
            break;
          }
        }
        if (j == clouds.length) {
          cloudLayer.addChild(cloud);
          clouds.push(cloud);
        }
        ticksUntilCloud = 8000 + Math.random() * 20000;
      }
      
      for (i = 0; i < clouds.length; ) {
        clouds[i].x += 0.5;
        if (clouds[i].x > 800) {
          cloudLayer.removeChild(clouds[i]);
          clouds.splice(i, 1);
        } else {
          i++;
        }
      }
      
      blimp.y -= 1;
      if (blimp.y < -blimp.height) {
        blimp.x = Math.random() * 800 - blimp.width / 2;
        blimp.y = 600 + Math.random() * 200;
      }
      
      ticksUntilPowerup -= ticks;
      if (ticksUntilPowerup <= 0) {
        addEntity(new Powerup(Math.random() * 800, Math.random() * 600, Math.random() * 3, this));
        ticksUntilPowerup = 10000 + 5000 * Math.random();
      }
      
      physWorld.Step(ticks, 10, 10);
      
      var contact: b2Contact = physWorld.GetContactList();
      while (contact != null) {
        if (!contact.IsTouching())
        {
          contact = contact.GetNext();
          continue;
        }
        
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
        
        var powerup: Powerup = null;
        if (contact.GetFixtureA().GetBody().GetUserData() is Powerup) {
          powerup = contact.GetFixtureA().GetBody().GetUserData();
        } else if (contact.GetFixtureB().GetBody().GetUserData() is Powerup) {
          powerup = contact.GetFixtureB().GetBody().GetUserData();
        }
        
        if (bullet != null && tank != null) {
          if (bullet.shooter != tank) {
            bullet.kill();
            tank.hit(bullet.powerful ? 3 : 1);
            if (tank.markedAsDead && tank.parentTank == null) {
              matchEnded = true;
              if (tank == tank1) {
                EndState.victor = 1;
              } else {
                EndState.victor = 0;
              }
            }
          }
        } else if (bullet != null) {
          bullet.kill();
        } else if (powerup != null && tank != null) {
          tank.setPowerup(powerup.type);
          powerup.kill();
        }
        
        contact = contact.GetNext();
      }
      
      for each (var entity: Entity in entities) {
        entity.update(ticks);
      }
			
			// Go through body list and update sprite positions/rotations
      i = 0;
			for (var bb:b2Body = physWorld.GetBodyList(); bb; bb = bb.GetNext())
      {
				if (bb.GetUserData() is Entity)
        {
          var pos : b2Vec2 = bb.GetPosition();
          if (pos.x < -15.0/20.0)
            pos.x += 830.0/20.0;
          if (pos.x > 815.0/20.0)
            pos.x -= 830.0/20.0;
          if (pos.y < -15.0/20.0)
            pos.y += 630.0/20.0;
          if (pos.y > 615.0/20.0)
            pos.y -= 630.0/20.0;
          bb.SetPosition(pos);
          
					entity = bb.GetUserData() as Entity;
					entity.x = bb.GetPosition().x*20.0;
					entity.y = bb.GetPosition().y*20.0;
					entity.rotation = bb.GetAngle();
				}
			}
      
      // Update the health and recharge meters
      var meter : Number = 0;
      if (tank1 != null)
      {
        meter = tank1.health/tank1.maxHealth;
        health1.val = meter
        meter = 1;
        if (tank1.reloadTime > 0)
          meter = 1.0 - tank1.reloadTime/tank1.reloadMax;
        reload1.val = meter
      }
      if (tank2 != null)
      {
        meter = tank2.health/tank2.maxHealth;
        health2.val = meter
        meter = 1;
        if (tank2.reloadTime > 0)
          meter = 1.0 - tank2.reloadTime/tank2.reloadMax;
        reload2.val = meter
      }
    }
    
    public override function destroy(): void {
      stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      Tank.totalEngines = 0;
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

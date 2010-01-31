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
  public class Powerup extends Entity {
    /*
    [Embed(source='Bullet3.swf',
           symbol='Bullet3')]
    private static const _bulletSpriteClass: Class;
    */
    
    public static const TYPE_SPEED: int = 0;
    public static const TYPE_CROWD: int = 1;
    public static const TYPE_POWER: int = 2;
    
    public var type: int;
    private var mainInstance : PlayState
    private var bodyDef      : b2BodyDef
    private var body         : b2Body
    private var markedAsDead : Boolean = false;
    
    public function Powerup(x: Number, y: Number, type: int, inst: PlayState){
      super(x,y);
      mainInstance = inst;
      this.type = type;
      
      graphics.beginFill(0x000000);
      graphics.drawRect(-20, -20, 40, 40);
      graphics.endFill();
      switch(type) {
        case TYPE_SPEED:
          graphics.beginFill(0x00ff77);
          break;
        case TYPE_CROWD:
          graphics.beginFill(0xffff00);
          break;
        case TYPE_POWER:
          graphics.beginFill(0xff0000);
          break;
      }
      graphics.drawRect(-18, -18, 36, 36);
      graphics.endFill();
      
      
      //addChild(new _bulletSpriteClass());
      
      var circleShape:b2CircleShape;
      
      // Init the physics body
      bodyDef = new b2BodyDef();
      bodyDef.position.x = x/20.0;
      bodyDef.position.y = y/20.0;
      bodyDef.fixedRotation = true;
      circleShape = new b2CircleShape(20.0/20.0);
      var fixtureDef:b2FixtureDef = new b2FixtureDef();
      fixtureDef.shape = circleShape;
      fixtureDef.density = 1.0;
      fixtureDef.friction = 0.0;
      fixtureDef.restitution = 0.8;
      bodyDef.userData = this;
      body = mainInstance.physWorld.CreateBody(bodyDef);
      body.SetType(b2Body.b2_dynamicBody);
      body.CreateFixture(fixtureDef);
      body.ResetMassData();
      
      // Set up what this will collide with
      var fixture:b2Fixture = body.GetFixtureList();
      while (fixture)
      {
        var filterData : b2FilterData = new b2FilterData;
        filterData.categoryBits = BIT_ENVIRO;
        filterData.maskBits     = BIT_TANK1 | BIT_TANK2 | BIT_HOLOGRAM1 | BIT_HOLOGRAM2 | BIT_ENVIRO;
        fixture.SetFilterData(filterData);
        fixture = fixture.GetNext();
      }
    }
    
    override public function update(ticks: int): void {
      if (markedAsDead)
      {
        mainInstance.removeEntity(this);
        mainInstance.physWorld.DestroyBody(body);
        new SoundEffectManager.powerup().play();
      }
    }
    
    public function kill(): void {
      markedAsDead = true;
    }
  }
}
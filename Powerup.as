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
    [Embed(source="PowerUp_Speed_1.png")]
    private static var speedClass: Class;
    
    [Embed(source="PowerUp_MultiClone_1.png")]
    private static var crowdClass: Class;
    
    [Embed(source="PowerUp_SuperShot_1.png")]
    private static var powerClass: Class;
    
    public static const TYPE_SPEED: int = 0;
    public static const TYPE_CROWD: int = 1;
    public static const TYPE_POWER: int = 2;
    
    public var type: int;
    private var timeLeft     : int = 45000
    private var mainInstance : PlayState
    private var bodyDef      : b2BodyDef
    private var body         : b2Body
    private var markedAsDead : Boolean = false;
    
    public function Powerup(x: Number, y: Number, type: int, inst: PlayState){
      super(x,y);
      mainInstance = inst;
      this.type = type;
      
      var sprite: DisplayObject;
      switch(type) {
        case TYPE_SPEED:
          sprite = new speedClass();
          break;
        case TYPE_CROWD:
          sprite = new crowdClass();
          break;
        case TYPE_POWER:
          sprite = new powerClass();
          break;
      }
      addChild(sprite);
      sprite.x = -sprite.width / 2;
      sprite.y = -sprite.height / 2;
      
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
      // Decrement time remaining
      timeLeft -= ticks;
      if (timeLeft < 0)
        markedAsDead = true;
      
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
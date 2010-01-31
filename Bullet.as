package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  import flash.media.SoundChannel;
  
  import Box2D.Dynamics.*;
  import Box2D.Collision.*;
  import Box2D.Collision.Shapes.*;
  import Box2D.Common.Math.*;
  public class Bullet extends Entity {
    [Embed(source='Bullet3.swf',
           symbol='Bullet3')]
    private static const _bulletSpriteClass: Class;
    
    [Embed(source='Bullet6.swf',
           symbol='Bullet6')]
    private static const _bullet2SpriteClass: Class;
    
    public var speed    : Number = 0.01
    public var distance : Number = 0.0
    public var maxDist  : Number = 550.0
    public var timeLeft : int    = 3500
    private var mainInstance : PlayState
    public var shooter      : Tank
    private var bodyDef      : b2BodyDef
    private var body         : b2Body
    private var markedAsDead : Boolean = false;
    public var powerful: Boolean;
    private var humChannel: SoundChannel;
    
    public function Bullet(inst: PlayState, powerful: Boolean, shotBy: Tank){
      super(x,y);
      //rotation = rot;
      mainInstance = inst;
      shooter = shotBy;
      this.powerful = powerful;
      
      if (powerful) {
        addChild(new _bullet2SpriteClass());
        speed *= 2;
      } else {
        addChild(new _bulletSpriteClass());
      }
      
      var circleShape:b2CircleShape;
      
      // Init the physics body
      var dir : b2Vec2 = new b2Vec2(Math.cos(shotBy.rotation*Math.PI/180), Math.sin(shotBy.rotation*Math.PI/180))
      bodyDef = new b2BodyDef();
      bodyDef.position.x = (shotBy.x + dir.x*15.0)/20.0;
      bodyDef.position.y = (shotBy.y + dir.y*15.0)/20.0;
      bodyDef.fixedRotation = true;
      circleShape = new b2CircleShape(5.0/20.0);
      var fixtureDef:b2FixtureDef = new b2FixtureDef();
      fixtureDef.shape = circleShape;
      fixtureDef.density = 1.0;
      fixtureDef.friction = 0.0;
      fixtureDef.restitution = 0.8;
      
      // Set up what this will collide with
      if (shooter.playerId == 1)
      {
        // Player 1 fires
        fixtureDef.filter.categoryBits = BIT_BULLET1
        fixtureDef.filter..maskBits     = BIT_TANK2 | BIT_HOLOGRAM2 | BIT_BULLET2 | BIT_ENVIRO
      }
      else
      {
        // Player 2 fires
        fixtureDef.filter..categoryBits = BIT_BULLET2
        fixtureDef.filter..maskBits     = BIT_TANK1 | BIT_HOLOGRAM1 | BIT_BULLET1 | BIT_ENVIRO
      }
      
      bodyDef.userData = this;
      body = mainInstance.physWorld.CreateBody(bodyDef);
      body.SetType(b2Body.b2_dynamicBody);
      body.CreateFixture(fixtureDef);
      body.ResetMassData();
      body.SetAngle(shotBy.rotation);
      body.SetLinearVelocity(new b2Vec2(dir.x*speed, dir.y*speed))
      
      if (Math.random() > 0.5) {
        new SoundEffectManager.shot1().play();
      } else {
        new SoundEffectManager.shot2().play();
      }
      
      humChannel = new SoundEffectManager.travelingshot().play(0, 1000);
    }
    
    override public function update(ticks: int): void {
      timeLeft -= ticks;
      if (timeLeft <= 0 || markedAsDead)
      {
        mainInstance.removeEntity(this);
        mainInstance.physWorld.DestroyBody(body);
        mainInstance.addEntity(new Impact(x, y, mainInstance));
        humChannel.stop();
      }
    }
    
    public function kill(): void {
      markedAsDead = true;
    }
  }
}
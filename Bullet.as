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
    
  public class Bullet extends Entity {
    [Embed(source='Bullet3.swf',
           symbol='Bullet3')]
    private static const _bulletSpriteClass: Class;
    
    public var speed    : Number = 0.01
    public var distance : Number = 0.0
    public var maxDist  : Number = 550.0
    private var mainInstance : PlayState
    private var shooter      : Tank
    private var bodyDef      : b2BodyDef
    private var body         : b2Body
    
    public function Bullet(inst: PlayState, shotBy: Tank){
      super(x,y);
      //rotation = rot;
      mainInstance = inst;
      shooter = shotBy;
      addChild(new _bulletSpriteClass());
      
      var circleShape:b2CircleShape;
      
      // Init the physics body
      var dir : b2Vec2 = new b2Vec2(Math.cos(shotBy.rotation*Math.PI/180), Math.sin(shotBy.rotation*Math.PI/180))
      bodyDef = new b2BodyDef();
      bodyDef.position.x = (shotBy.x + dir.x*15.0)/20.0;
      bodyDef.position.y = (shotBy.y + dir.y*15.0)/20.0;
      circleShape = new b2CircleShape(5.0/20.0);
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
      body.SetAngle(shotBy.rotation);
      body.SetLinearVelocity(new b2Vec2(dir.x*speed, dir.y*speed))
    }
    
    override public function update(ticks: int): void {
      /*
      this.x += speed * Math.cos(rotation*Math.PI/180) * ticks/1000;
      this.y += speed * Math.sin(rotation*Math.PI/180) * ticks/1000;
      distance += speed * ticks/1000;
      if (distance > maxDist)
      {
        mainInstance.removeEntity(this)
      }
      
      // Wrap around screen
      if (this.x < -15)
        this.x += 830;
      if (this.x > 815)
        this.x -= 830;
      if (this.y < -15)
        this.y += 630;
      if (this.y > 615)
        this.y -= 630;
      
      // Have we hit a tank?
      if (shooter == mainInstance.tank1 && mainInstance.tank2.hitTestPoint(this.x, this.y))
      {
        mainInstance.tank2.hit();
        mainInstance.removeEntity(this)  
      }
      if (shooter == mainInstance.tank2 && mainInstance.tank1.hitTestPoint(this.x, this.y))
      {
        mainInstance.tank1.hit();
        mainInstance.removeEntity(this)
      }
      */
    }
  }
}
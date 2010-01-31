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
  
  public class Tank extends Entity {
    [Embed(source='CartoonTank.swf',
           symbol='Tank1')]
    private static const _tankSpriteClass: Class;
    
    public static const ACTION_NONE:    int = 0;
    public static const ACTION_FORWARD: int = 1;
    public static const ACTION_BACK:    int = 2;
    public static const ACTION_LEFT:    int = 3;
    public static const ACTION_RIGHT:   int = 4;
    public static const ACTION_FIRE:    int = 5;
    public static const ACTION_CLONE:   int = 6;
        
    private var bKeyForward : Boolean = false;
    private var bKeyBack    : Boolean = false;
    private var bKeyLeft    : Boolean = false;
    private var bKeyRight   : Boolean = false;
    
    public var currentAction : int = ACTION_NONE;
    public var speed         : Number = 0.003;
    public var rotationSpeed : Number = 120.0;
    private var reloadTime   : int = 0     // ms until recharge is complete
    private var reloadMax    : int = 3500  // ms required for total recharge
    private var mainInstance : PlayState
    private var health       : int = 100;
    private var bodyDef      : b2BodyDef
    private var body         : b2Body
    
    public function Tank(x: Number, y: Number, inst: PlayState){
      super(x,y);
      mainInstance = inst;
      addChild(new _tankSpriteClass());

    
      // Vars used to create physics bodies
			var boxShape:b2PolygonShape;
			//var circleShape:b2CircleShape;
      
      // Init the physics body
      bodyDef = new b2BodyDef();
      bodyDef.position.x = x/20.0;
      bodyDef.position.y = y/20.0;
      boxShape = new b2PolygonShape();
      boxShape.SetAsBox(15.0/20.0,15.0/20.0);
      var fixtureDef:b2FixtureDef = new b2FixtureDef();
      fixtureDef.shape = boxShape;
      fixtureDef.density = 1.0;
      fixtureDef.friction = 0.3;
      fixtureDef.restitution = 0.0;
      bodyDef.userData = this;
      body = mainInstance.physWorld.CreateBody(bodyDef);
      body.SetType(b2Body.b2_dynamicBody);
      body.CreateFixture(fixtureDef);
      body.ResetMassData();
    }

    public function keydown(action: int, pressed: Boolean): void {
      if (action == ACTION_FORWARD)
        bKeyForward = pressed
      else if (action == ACTION_BACK)
        bKeyBack = pressed
      else if (action == ACTION_LEFT)
        bKeyLeft = pressed
      else if (action == ACTION_RIGHT)
        bKeyRight = pressed
      else if (action == ACTION_FIRE && pressed && reloadTime <= 0)
      {
        var bullet : Bullet = new Bullet(mainInstance, this);
        mainInstance.addEntity(bullet)
        reloadTime = reloadMax
      }
      else if (action == ACTION_CLONE && pressed)
      {
      }
      
      if (bKeyLeft)
        currentAction = ACTION_LEFT
      else if (bKeyRight)
        currentAction = ACTION_RIGHT
      else if (bKeyForward)
        currentAction = ACTION_FORWARD
      else if (bKeyBack)
        currentAction = ACTION_BACK
      else
        currentAction = ACTION_NONE
    }
    
    public function hit(): void {
      health = 0;
    }
    
    override public function update(ticks: int): void {
      var vec : b2Vec2;
      if (currentAction == ACTION_FORWARD)
      {
        vec = new b2Vec2(speed * Math.cos(rotation*Math.PI/180), speed * Math.sin(rotation*Math.PI/180))
        body.SetLinearVelocity(vec)
        //body.SetAngularVelocity(0);
      }
      else if (currentAction == ACTION_BACK)
      {
        vec = new b2Vec2(-speed * Math.cos(rotation*Math.PI/180), -speed * Math.sin(rotation*Math.PI/180))
        body.SetLinearVelocity(vec)
        //body.SetAngularVelocity(0);
      }
      else if (currentAction == ACTION_LEFT)
      {
        vec = new b2Vec2(0,0);
        body.SetLinearVelocity(vec)
        //body.SetAngularVelocity(-0.50);
        body.SetAngle(body.GetAngle()-60.0*ticks/1000.0);
      }
      else if (currentAction == ACTION_RIGHT)
      {
        vec = new b2Vec2(0,0);
        body.SetLinearVelocity(vec)
        //body.SetAngularVelocity(0.50);
        body.SetAngle(body.GetAngle()+60.0*ticks/1000.0);
      }
      else
      {
        vec = new b2Vec2(0,0);
        body.SetLinearVelocity(vec)
        //body.SetAngularVelocity(0)
      }
      
      // Decrement remaining reload time
      if (reloadTime >= 0)
      {
        reloadTime -= ticks
      }
    }
  }
}
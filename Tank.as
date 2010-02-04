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
  
  public class Tank extends Entity {
    [Embed(source='CartoonTank.swf',
           symbol='Tank1')]
    private static const _monkSpriteClass: Class;
    
    [Embed(source='PunkTank1.swf',
           symbol='PunkTank1')]
    private static const _punkSpriteClass: Class;
    
    [Embed(source='SkunkTank_1.swf',
           symbol='SkunkTank1')]
    private static const _skunkSpriteClass: Class;
    
    public static const TYPE_MONK:     int = 0;
    public static const TYPE_PUNK:     int = 1;
    public static const TYPE_SKUNK:    int = 2;
    
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
    
    public var playerId      : int = 0
    public var currentAction : int = ACTION_NONE;
    public var speed         : Number = 0.004;
    public var reloadTime    : int = 0     // ms until recharge is complete
    public var reloadMax     : int = 3500  // ms required for total recharge
    private var mainInstance : PlayState
    public var health        : int = 3;
    public var maxHealth     : int = 3;
    private var bodyDef      : b2BodyDef
    private var body         : b2Body
    public var parentTank    : Tank;   // Only set for hologram tanks
    public var childTanks    : Array = [];
    public var aiTaskDuration: int = 1000;
    public var markedAsDead : Boolean = false;
    public var type: int;
      
    public var powerupSpeedTime : int = -1;
    public var powerupCrowdTime : int = -1;
    public var powerupPowerTime : int = -1;
    
    
    private var _engineRunning: Boolean = false;
    private static var _totalEngines: int = 0;
    private static var engineChannel: SoundChannel = null;
    [Bindable]
    private function get engineRunning(): Boolean {
      return _engineRunning;
    }
    private function set engineRunning(val: Boolean): void {
      _engineRunning = val;
      if (_engineRunning) {
        totalEngines++;
      } else {
        totalEngines--;
      }
    }
    public static function get totalEngines(): int {
      return _totalEngines;
    }
    public static function set totalEngines(val: int): void {
      _totalEngines = val;
      if (_totalEngines > 0) {
        if (engineChannel == null) {
          engineChannel = new SoundEffectManager.engine().play(0, 1000);
        }
      } else {
        if (engineChannel != null) {
          engineChannel.stop();
          engineChannel = null;
        }
      }
    }
    
    public function Tank(x: Number, y: Number, angle: Number, type: int, inst: PlayState, playerId: Number, parentTank: Tank){
      super(x,y);
      mainInstance = inst;
      this.type = type;
      this.playerId = playerId;
      this.parentTank = parentTank
      
      switch (type) {
        case TYPE_MONK:
          addChild(new _monkSpriteClass());
          break;
        case TYPE_PUNK:
          addChild(new _punkSpriteClass());
          break;
        case TYPE_SKUNK:
          addChild(new _skunkSpriteClass());
          break;
      }

      // Vars used to create physics bodies
			var boxShape:b2PolygonShape;
      
      // Init the physics body
      bodyDef = new b2BodyDef();
      bodyDef.position.x = x/20.0;
      bodyDef.position.y = y/20.0;
      
      bodyDef.angle = angle;
      bodyDef.fixedRotation = true;
      boxShape = new b2PolygonShape();
      boxShape.SetAsBox(15.0/20.0,15.0/20.0);
      var fixtureDef:b2FixtureDef = new b2FixtureDef();
      fixtureDef.shape = boxShape;
      fixtureDef.density = 1.0;
      fixtureDef.friction = 0.3;
      fixtureDef.restitution = 0.0;
      
      // Setup collision filters
      if (parentTank && parentTank.playerId == 1)
      {
        // Hologram created by tank1
        fixtureDef.filter.categoryBits = BIT_HOLOGRAM1
        fixtureDef.filter.maskBits     = BIT_HOLOGRAM2 | BIT_BULLET2 | BIT_ENVIRO
      }
      else if (parentTank && parentTank.playerId == 2)
      {
        // Hologram created by tank2
        fixtureDef.filter.categoryBits = BIT_HOLOGRAM2
        fixtureDef.filter.maskBits     = BIT_HOLOGRAM1 | BIT_BULLET1 | BIT_ENVIRO
      }
      else if (playerId == 1)
      {
        // Player 1
        fixtureDef.filter.categoryBits = BIT_TANK1
        fixtureDef.filter.maskBits     = BIT_TANK2 | BIT_BULLET2 | BIT_ENVIRO
      }
      else
      {
        // Player 2
        fixtureDef.filter.categoryBits = BIT_TANK2
        fixtureDef.filter.maskBits     = BIT_TANK1 | BIT_BULLET1 | BIT_ENVIRO
      }
      
      bodyDef.userData = this;
      body = mainInstance.physWorld.CreateBody(bodyDef);
      body.SetType(b2Body.b2_dynamicBody);
      var fixture:b2Fixture = body.CreateFixture(fixtureDef);
      body.ResetMassData();
    }
    
    public function keydown(action: int, pressed: Boolean): void {
      if (markedAsDead) return;
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
        var bullet : Bullet = new Bullet(mainInstance, (powerupPowerTime > 0), this);
        mainInstance.addEntity(bullet)
        reloadTime = reloadMax
      } 
      else if (action == ACTION_FIRE && pressed) {
        new SoundEffectManager.clickdown().play();
      }
      else if (action == ACTION_CLONE && pressed)
      {
        // If this tank alraedy had a hologram, delete it
        var maxChildren: int = (powerupCrowdTime > 0) ? 4 : 1;
        while (childTanks.length >= maxChildren)
        {
          childTanks[0].disappear();
          childTanks.splice(0,1);
        }
        
        // Spawn a new holoTank
        var holoTank : Tank = new Tank(x, y, body.GetAngle(), type, mainInstance, 0, this)
        holoTank.rotation = rotation
        childTanks.push(holoTank);
        holoTank.nextAiTask()
        mainInstance.addEntity(holoTank)
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
    
    public function hit(damage: int): void {
      // Clones can be killed with one hit
      if (parentTank != null)
        health = 0;    
      else
        health -= damage;
      
      if (health <= 0) markedAsDead = true;
    }
    
    public function removeClone(clone:Tank): void {
      var i : int = childTanks.indexOf(clone, 0);
      if (i >= 0)
        childTanks.splice(i, 1);
    }
    
    public function disappear(): void {
      mainInstance.removeEntity(this);
      mainInstance.physWorld.DestroyBody(body);
    }
    
    public function setPowerup(type: int): void {
      if (type == Powerup.TYPE_CROWD)
        powerupCrowdTime = 30000
      if (type == Powerup.TYPE_SPEED)
        powerupSpeedTime = 30000
      if (type == Powerup.TYPE_POWER)
        powerupPowerTime = 30000
    }
    
    public function nextAiTask() : void {
      // Randomly choose one of 4 AI tasks: left, right, forward or none
      var taskId : int = Math.random()*4.0
      if (taskId == 0)
      {
        currentAction = ACTION_LEFT
        aiTaskDuration = Math.random()*800.0
      }
      else if (taskId == 1)
      {
        currentAction = ACTION_RIGHT
        aiTaskDuration = Math.random()*800.0
      }
      else if (taskId == 2)
      {
        currentAction = ACTION_FORWARD
        aiTaskDuration = Math.random()*2000.0
      }
      else
      {
        currentAction = ACTION_NONE
        aiTaskDuration = Math.random()*500.0
      }
    }
    
    override public function update(ticks: int): void {
      powerupSpeedTime -= ticks;
      powerupCrowdTime -= ticks;
      powerupPowerTime -= ticks;
      
      if (markedAsDead) {
        // If this is a clone, remove it from its parent's childTanks list
        if (parentTank)
          parentTank.removeClone(this);
          
        mainInstance.removeEntity(this);
        mainInstance.physWorld.DestroyBody(body);
        mainInstance.addEntity(new Explosion(x, y, mainInstance));
        engineRunning = false;
        return;
      }
      
      var vec : b2Vec2;
      
      // Tick automated actions for AI
      if (parentTank)
      {
        aiTaskDuration -= ticks;
        if (aiTaskDuration <= 0)
        {
          nextAiTask();
        }
      }
      
      var scaledSpeed : Number = speed;
      var turnSpeed : Number = 100;
      if (powerupSpeedTime > 0)
        scaledSpeed *= 2.0;
      if (powerupSpeedTime > 0)
        turnSpeed *= 2.0 
      
      if (currentAction == ACTION_FORWARD)
      {
        vec = new b2Vec2(scaledSpeed * Math.cos(rotation*Math.PI/180), scaledSpeed * Math.sin(rotation*Math.PI/180))
        body.SetLinearVelocity(vec)
      }
      else if (currentAction == ACTION_BACK)
      {
        vec = new b2Vec2(-scaledSpeed * Math.cos(rotation*Math.PI/180), -scaledSpeed * Math.sin(rotation*Math.PI/180))
        body.SetLinearVelocity(vec)
      }
      else if (currentAction == ACTION_LEFT)
      {
        vec = new b2Vec2(0,0);
        body.SetLinearVelocity(vec)
        body.SetAngle(body.GetAngle()-turnSpeed*ticks/1000.0);
      }
      else if (currentAction == ACTION_RIGHT)
      {
        vec = new b2Vec2(0,0);
        body.SetLinearVelocity(vec)
        body.SetAngle(body.GetAngle()+turnSpeed*ticks/1000.0);
      }
      else
      {
        vec = new b2Vec2(0,0);
        body.SetLinearVelocity(vec)
      }
      
      // Decrement remaining reload time
      if (reloadTime >= 0)
      {
        reloadTime -= ticks
      }
      
      
      engineRunning = (currentAction == ACTION_FORWARD || currentAction == ACTION_BACK || 
                       currentAction == ACTION_LEFT    || currentAction == ACTION_RIGHT);
    }
  }
}
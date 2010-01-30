package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class PlayState extends GameState {
    public static const P1_FORWARD_KEY: int = 87;
    public static const P1_BACK_KEY: int    = 83;
    public static const P1_LEFT_KEY: int    = 65;
    public static const P1_RIGHT_KEY: int   = 68;
    public static const P1_FIRE_KEY: int    = 70;
    public static const P1_CLONE_KEY: int   = 71;
    public static const P2_FORWARD_KEY: int = 38;
    public static const P2_BACK_KEY: int    = 40;
    public static const P2_LEFT_KEY: int    = 37;
    public static const P2_RIGHT_KEY: int   = 39;
    public static const P2_FIRE_KEY: int    = 188;
    public static const P2_CLONE_KEY: int   = 190;
    
    private var entities: Array = [];
    private var tank1 : Tank;
    private var tank2 : Tank;
    
    public function PlayState(stage: Stage) {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      
      tank1 = new Tank(100, 400, this);
      addEntity(tank1);
      tank2 = new Tank(700, 400, this);
      addEntity(tank2);
    }
    
    public function addEntity(entity: Entity): void {
      entities.push(entity);
      addChild(entity);
    }
    
    public function removeEntity(entity: Entity): void {
      removeChild(entity);
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
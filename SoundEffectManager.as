package{
  import flash.display.*;
  import flash.events.*;
  import flash.geom.*;
  import flash.text.*;
  import flash.utils.*;
  
  public class SoundEffectManager {
    [Embed('sfx/xplosion.mp3')]
    public static var xplosion:Class;
    [Embed('sfx/shot1.mp3')]
    public static var shot1:Class;
    [Embed('sfx/shot2.mp3')]
    public static var shot2:Class;
    [Embed('sfx/impact.mp3')]
    public static var impact1:Class;
    [Embed('sfx/impact2.mp3')]
    public static var impact2:Class;
    [Embed('sfx/impact3.mp3')]
    public static var impact3:Class;
    [Embed('sfx/victory.mp3')]
    public static var victory:Class;
  }
}
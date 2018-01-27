package;

import axollib.GraphicsCache;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class Player extends FlxSprite 
{

	private var jumpTimer:Float = 0;
	private var jumpCool:Float = 0 ;
	private var deathTimer:Float = 0;
	public var parent:PlayState;
	
	public function new(?X:Float=0, ?Y:Float=0, Parent:PlayState) 
	{
		super(X, Y);
		
		parent = Parent;
		
		frames = GraphicsCache.loadGraphicFromAtlas("player", AssetPaths.player__png, AssetPaths.player__xml).atlasFrames;
		
		animation.addByNames("idle", ["Player-Move-0.png"], 12, false);
		animation.addByIndices("walk", "Player-Move-", [1,2,0], ".png", 12, false);
		animation.addByNames("jump", ["Player-Jump-0.png"], 12, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.play("idle");
		width = 24;
		offset.x = 12;
		acceleration.y = 2400;
		maxVelocity.x = 400;
		drag.x = 20000;
		
		
	}
	
	
	
	public function movement(elapsed:Float):Void
	{
		if (!alive)
			return;
			
		
		var left:Bool = UIControl.isPressed([UIControl.KEY_LEFT]);
		var right:Bool = UIControl.isPressed([UIControl.KEY_RIGHT]);
		var jump:Bool = UIControl.isPressed([UIControl.KEY_JUMP]);
		var wasJump:Bool = UIControl.wasJustReleased([UIControl.KEY_JUMP]);
	
		if (left && right)
			left = right = false;
			
		if (left)
		{
			if (velocity.x > 0)
				velocity.x = 0;
			acceleration.x = -1000;
			facing = FlxObject.LEFT;
			if (animation.name != "walk" || animation.finished)
				animation.play("walk", true);
		}
		else if (right)
		{
			if (velocity.x < 0)
				velocity.x = 0;
			acceleration.x = 1000;
			facing = FlxObject.RIGHT;
			if (animation.name != "walk" || animation.finished)
				animation.play("walk", true);
		}
		else
		{
			acceleration.x = 0;
			if (animation.name != "walk" || animation.finished)
				animation.play("idle", true);
		}
			
		var justJumped:Bool = false;
		
		if (jumpCool > 0)
			jumpCool -= elapsed;
			
		if (jump && isTouching(FlxObject.FLOOR) && jumpCool <= 0)
		{
			justJumped = true;
			jumpTimer = .44;
			velocity.y = -1000;
			if (animation.name != "jump")
				animation.play("jump", true);
			
		}
		if (!justJumped)
		{
			if (jumpTimer > 0)
			{
				jumpTimer -= elapsed;
			}
			
			
			if (wasJump && !jump || jump && jumpTimer <= 0 || justTouched(FlxObject.FLOOR))
			{
				jumpTimer = 0;
				jumpCool = .025;
				if (velocity.y < -200)
					velocity.y = -200; 
				
			}
		}
		
	}
	
	override public function kill():Void 
	{

		alive = false;
		exists = true;
		velocity.set();
		acceleration.x = 0;
		deathTimer = .25;
		allowCollisions = FlxObject.NONE;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (!alive)
		{
			if (deathTimer > -1000)
			{
				deathTimer -= elapsed;
				velocity.set();
				if (deathTimer <= 0)
				{
					deathTimer =-1000;
					angularAcceleration = 1000;
					velocity.y = -600;
				}
			}
			
			if (y > FlxG.height)
			{
				exists = false;
				parent.death();
			
			}
		}
		
		
	}
	
}
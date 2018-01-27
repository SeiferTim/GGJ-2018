package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class Player extends FlxSprite 
{

	private var jumpTimer:Float = 0;
	private var jumpCool:Float = 0 ;
	
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(48, 48, FlxColor.PURPLE);
		
		acceleration.y = 2400;
		maxVelocity.x = 400;
		drag.x = 20000;
		
		
	}
	
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
	}
	
	public function movement(elapsed:Float):Void
	{
		
		var left:Bool = UIControl.isPressed([UIControl.KEY_LEFT]);
		var right:Bool = UIControl.isPressed([UIControl.KEY_RIGHT]);
		var jump:Bool = UIControl.isPressed([UIControl.KEY_JUMP]);
		var wasJump:Bool = UIControl.wasJustReleased([UIControl.KEY_JUMP]);
	
		if (left && right)
			left = right = false;
			
		if (left)
		{
			acceleration.x = -1000;
			facing = FlxObject.LEFT;
		}
		else if (right)
		{
			acceleration.x = 1000;
			facing = FlxObject.RIGHT;
		}
		else
			acceleration.x = 0;
			
		var justJumped:Bool = false;
		
		if (jumpCool > 0)
			jumpCool -= elapsed;
			
		if (jump && isTouching(FlxObject.FLOOR) && jumpCool <= 0)
		{
			justJumped = true;
			jumpTimer = .44;
			velocity.y = -1000;
			
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
	
}
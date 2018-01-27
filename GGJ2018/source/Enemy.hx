package;

import axollib.GraphicsCache;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Enemy extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		
		super(X, Y);
		
		frames = GraphicsCache.loadGraphicFromAtlas("enemy", AssetPaths.enemy__png, AssetPaths.enemy__xml).atlasFrames;
		
		
		animation.addByIndices("walk", "enemy-", [0,1,2,3], ".png", 12, false);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.play("walk");
		width = 24;
		offset.x = 12;
		acceleration.y = 2400;
		maxVelocity.x = 400;
		//drag.x = 20000;
		velocity.x = -100;
		facing = FlxObject.LEFT;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (justTouched(FlxObject.WALL))
		{
			if (facing == FlxObject.LEFT)
			{
				velocity.x = 100;
				facing = FlxObject.RIGHT;
				x += 10;
			}
			else
			{
				velocity.x = -100;
				facing = FlxObject.LEFT;
				x -= 10;
			}
		}
		super.update(elapsed);
	}
	
}
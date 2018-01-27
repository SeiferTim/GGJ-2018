package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Mirror extends FlxSprite 
{

	public var touched:Bool = false;
	public var wasTouched:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.mirror__png, false, 48, 48);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
	}
	
	public function flip():Void
	{
		facing = (facing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT);
	}
	
	override public function update(elapsed:Float):Void 
	{
		wasTouched = touched;
		touched = false;
		super.update(elapsed);
		
		
	}
	
	public function touch():Void
	{
		touched = true;
		if (!wasTouched)
		{
			flip();
		}
	}
}
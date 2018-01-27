package;

import axollib.GraphicsCache;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class Transmission extends FlxSprite 
{

	public function new() 
	{
		super(-1000,-1000);
		frames = GraphicsCache.loadGraphicFromAtlas("signal", AssetPaths.signal__png, AssetPaths.signal__xml).atlasFrames;
		animation.addByStringIndices("signal", "signal_01_", ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10"], ".png", 12, true);
		width = 24;
		height = 24;
		offset.x = offset.y = 12;
		animation.play("signal");
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (alive && justTouched(FlxObject.ANY))
			kill();
		super.update(elapsed);
	}
	
}
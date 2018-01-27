package;

import axollib.GraphicsCache;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class OpenDoor extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		frames = GraphicsCache.loadGraphicFromAtlas("exit-door", AssetPaths.exit_door__png, AssetPaths.exit_door__xml).atlasFrames;
		animation.addByStringIndices("open", "door_01_red_", ["01", "02", "03", "04", "05", "06", "07"], ".png", 12, false);
		animation.addByStringIndices("blink", "door_01_red_", ["08", "09", "10", "11", "10", "09", "08", "08", "08"], ".png", 12, true);
		kill();
		
	}
	
	override public function revive():Void 
	{
		super.revive();
		animation.play("open");
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (alive &&  animation.name == "open" && animation.finished)
			animation.play("blink");
		super.update(elapsed);
	}
}


package;

import axollib.GraphicsCache;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;


class Receiver extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		frames = GraphicsCache.loadGraphicFromAtlas("receiver", AssetPaths.receiver__png, AssetPaths.receiver__xml).atlasFrames;
		animation.addByNames("normal", ["receiver_01.png"], 12, false);
		animation.addByStringIndices("blink", "receiver_01_", ["01", "02", "03", "02"], ".png", 12, true);
		animation.play("normal");
		angle = -90;
	}
	
}
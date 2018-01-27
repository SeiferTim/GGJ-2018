package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;


class Receiver extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.receiver_01__png);
		
	}
	
}
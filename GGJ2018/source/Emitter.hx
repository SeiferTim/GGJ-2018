package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;


class Emitter extends FlxSprite 
{
	
	public var parent:PlayState;
	public var emitTimer:Float;

	public function new(?X:Float=0, ?Y:Float=0, Parent:PlayState) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.transmitter_01__png);
		parent = Parent;
		emitTimer = 2;
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		emitTimer -= elapsed;
		if (emitTimer <= 0)
		{
			emitTimer = .66;
			parent.emit(x, y);
		}
		super.update(elapsed);
	}
	
}
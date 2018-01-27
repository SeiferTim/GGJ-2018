package;

import axollib.GraphicsCache;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class Hazard extends FlxSprite 
{

	private var toggleTimer:Float = 0;
	private var hType:Int = 0;
	
	public function new(?X:Float=0, ?Y:Float=0, ?HazardType:Int = 0) 
	{
		super(X, Y);
		
		if (HazardType == 0)
		{
			frames = GraphicsCache.loadGraphicFromAtlas("hazard", AssetPaths.hazard__png, AssetPaths.hazard__xml).atlasFrames;
			animation.addByStringIndices("hazard", "hazard_01_", ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15"], ".png", 12, true);
			
		}
		else
		{
			hType = 1;
			frames = GraphicsCache.loadGraphicFromAtlas("timed-hazard", AssetPaths.timed_haz__png, AssetPaths.timed_haz__xml).atlasFrames;
			animation.addByStringIndices("hazard", "Thazard_01_", ["01", "02", "03", "04", "05", "06",  "05", "04", "03", "02"], ".png", 10, true);
			height = 12;
			offset.y = 36;
			y += 36;
			visible = false;
			
		}
		animation.play("hazard");
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (hType == 1 && alive && exists)
		{
			toggleTimer -= elapsed;
			if (toggleTimer <= 0)
			{
				toggleTimer = 3;
				visible = !visible;
				if (visible)
					animation.play("hazard", true);
			}
		}
		super.update(elapsed);
	}
	
}
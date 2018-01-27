package;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxPath;
import flixel.util.FlxSave;

class Globals 
{

	
	public static var Save:FlxSave;
	
	public static var initialized:Bool = false;
	
	public static var levelMaps:Array<FlxGraphicAsset>;
	
	public static var level:Int = 0;
	
	
	public static function init():Void
	{
		if (initialized)
			return;
		initialized = true;
		loadGame();
		levelMaps = [];
		levelMaps.push(AssetPaths.level_test__png);
	}
	
	static public function loadGame():Void
	{
		
		Save = new FlxSave();
		Save.bind("trnsmsson-userData");
		
		
		
	}
	
	static public function flushSave():Void
	{
		
		Save.data.saved = true;
		Save.flush();
		
	}
	
	static public function clearSaves():Void
	{
		Save.erase();
		
		loadGame();
		FlxG.resetGame();
	}
}
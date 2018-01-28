package;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxPath;
import flixel.util.FlxSave;

class Globals 
{

	public static var levelTimer:Float=0;
	
	
	public static var Save:FlxSave;
	
	public static var initialized:Bool = false;
	
	public static var levelMaps:Array<FlxGraphicAsset>;
	
	public static var level:Int = 0;
	
	
	public static var scores:Array<Float>;
	
	public static var soundPlaying:Bool = false;
	
	
	public static function init():Void
	{
		if (initialized)
			return;
		initialized = true;
		scores = [];
		loadGame();
		
		levelMaps = [];
		
		levelMaps.push(AssetPaths.level_1__png);
		levelMaps.push(AssetPaths.level_2__png);
		levelMaps.push(AssetPaths.level_3__png);
		levelMaps.push(AssetPaths.level_4__png);
		//levelMaps.push(AssetPaths.level_5__png);
		levelMaps.push(AssetPaths.level_6__png);
		levelMaps.push(AssetPaths.level_7__png);
		levelMaps.push(AssetPaths.level_8__png);
		//levelMaps.push(AssetPaths.level_9__png);
		levelMaps.push(AssetPaths.level_10__png);
		
		
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
	
	static public function convertTime(Time:Float):String
	{
		var min:Int;
		var sec:Int;
		sec = Std.int(Time % 60);
		min = Std.int(Time / 60);
		
		return StringTools.lpad(Std.string(min),"0", 2) + ":" + StringTools.lpad(Std.string(sec), "0", 2);
	}
}
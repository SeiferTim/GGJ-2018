package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		Globals.init();
		#if debug
		addChild(new FlxGame(0, 0, MenuState));
		#else
		addChild(new FlxGame(0, 0, IntroState));
		#end
		FlxG.autoPause = false;
	}
}

package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameEndState extends FlxState
{
	public var scores:FlxText;

	public var ready:Bool = false;
	
	override public function create():Void
	{
		UIControl.initKeys();
		UIControl.init([]);
		
		var s:String = "";
		for (i in 0...Globals.levelMaps.length)
		{
			s += StringTools.rpad("ROOM " + Std.string(i+1) + " ", ".", 15) + StringTools.lpad(Globals.convertTime(Globals.scores[i]), ".", 10) + "\r\n";

		}

		scores = new FlxText();
		scores.size = 24;
		scores.alignment = FlxTextAlign.CENTER;
		scores.text = "YOUR TIMES\r\n" + s + "THANKS FOR PLAYING!\r\nPRESS ANY KEY";
		scores.screenCenter();
		add(scores);

		
		
		FlxG.camera.flash(FlxColor.WHITE, .2, function() {
			ready = true;
		});
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		UIControl.checkControls(elapsed);
		if (ready)
		{
			if (UIControl.wasJustReleased([UIControl.KEY_JUMP, UIControl.KEY_PAUSE, UIControl.KEY_SHOOT]))
			{
				ready = false;
				FlxG.camera.fade(FlxColor.BLACK, .66, false, function() {
					FlxG.switchState(new MenuState());
				});
			}
		}
		super.update(elapsed);
	}

}
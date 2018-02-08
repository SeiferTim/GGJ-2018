package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class PauseSubState extends FlxSubState 
{

	private var text:FlxText;
	private var ready:Bool = false;
	
	public function new() 
	{
		super(0x66ffffff);
		
		
	}
	
	override public function create():Void 
	{
		UIControl.initKeys();
		UIControl.init([]);
		
		text = new FlxText();
		text.size = 24;
		text.alignment = FlxTextAlign.CENTER;
		text.text = "- Paused -\r\n\r\n\r\nPress P to Resume\r\nPress X to Restart\r\nPress C to Quit";
		text.screenCenter();
		
		var back:FlxSprite = new FlxSprite();
		back.makeGraphic(Std.int(text.width + 128), Std.int(text.height + 64), FlxColor.WHITE);
		back.drawRect(2, 2, back.width - 4, back.height - 4, FlxColor.BLACK);
		back.screenCenter();
		add(back);
		
		
		add(text);
		UIControl.clear();
		ready = true;
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		UIControl.checkControls(elapsed);
		if (ready)
		{
			if (UIControl.wasJustReleased([UIControl.KEY_SHOOT]))
			{
				ready = false;
				FlxG.sound.music.fadeOut(.66);
				FlxG.camera.fade(FlxColor.BLACK, .66, false, function() {
					Globals.scores = [];
					Globals.level = 0;
					FlxG.switchState(new MenuState());
				});
			}
			else if (UIControl.wasJustReleased([UIControl.KEY_JUMP]))
			{
				ready = false;
				FlxG.resetState();
			}
			else if (UIControl.wasJustReleased([UIControl.KEY_PAUSE]))
			{
				ready = false;
				close();
			}
		}
		super.update(elapsed);
	}
	
}
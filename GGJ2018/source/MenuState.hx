package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class MenuState extends FlxState 
{

	var back:FlxSprite;
	var title:FlxSprite;
	var text:FlxText;
	var ready:Bool = false;
	
	override public function create():Void 
	{
		UIControl.initKeys();
		UIControl.init([]);
		
		
		back = new FlxSprite(0, 0, AssetPaths.title_screen__png);		
		add(back);
		
		title = new FlxSprite(783, 130, AssetPaths.title__png);
		title.alpha = 0;
		add(title);
		
		text = new FlxText();
		text.text = "Press Any Key";
		text.size = 32;
		text.borderStyle = FlxTextBorderStyle.SHADOW;
		text.borderColor = FlxColor.BLACK;
		text.screenCenter();
		text.y = FlxG.height - text.height - 12;
		text.alpha = 0;
		add(text);

		#if flash
		FlxG.sound.playMusic(AssetPaths.menu__mp3);
		#else
		FlxG.sound.playMusic(AssetPaths.menu__ogg);		
		#end
		
		FlxG.camera.fade(FlxColor.BLACK, .5, true, function() {
			FlxTween.tween(title, {alpha:1}, .66, {ease:FlxEase.circIn, type:FlxTween.ONESHOT, startDelay:.5, onComplete:function(_){
				FlxTween.tween(text, {alpha:1}, .66, {ease:FlxEase.circIn, type:FlxTween.ONESHOT, startDelay:.5, onComplete:function(_) {
					ready = true;
				}});
			}});
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
				FlxG.sound.music.fadeOut(.66);
				FlxG.camera.fade(FlxColor.BLACK, .66, false, function() {
					FlxG.switchState(new PlayState());
				});
			}
		}
		
		super.update(elapsed);
	}
	
}
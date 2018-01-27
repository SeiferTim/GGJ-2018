package;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	
	private var level:FlxTilemap;
	private var doorExit:OpenDoor;
	public var canExit:Bool = false;
	public var player:Player;
	public var emitter:Emitter;
	public var receiver:Receiver;
	public var grpTrans:FlxTypedGroup<Transmission>;
	
	override public function create():Void
	{
		
		UIControl.initKeys();
		UIControl.init([]);
		
		loadLevel(Globals.level);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		
		
		
		UIControl.checkControls(elapsed);
		player.movement(elapsed);
		super.update(elapsed);
		FlxG.collide(level, player);
		FlxG.overlap(grpTrans, receiver,  transTouchReceiver);
		FlxG.collide(grpTrans, level , transHitWall);
		
		
	}
	
	private function transTouchReceiver(T:Transmission, R:Receiver):Void
	{
		if (T.alive)
		{
			T.kill();
			if (!doorExit.alive)
				doorExit.revive();
		}
	}
	
	private function transHitWall(T:Transmission, T:FlxTile):Void
	{
		if (T.alive)
			T.kill();
	}
	
	
	public function emit(X:Float, Y:Float):Void
	{
		var t:Transmission = grpTrans.recycle(Transmission);
		if (t == null)
		{
			t  = new Transmission(X, Y);
		}
		t.reset(X, Y);
		t.facing = FlxObject.RIGHT;
		t.velocity.x = 200;
		t.velocity.y = 0;
		grpTrans.add(t);
	}
	
	private function loadLevel(LevelNo:Int):Void
	{
		var m:FlxSprite = new FlxSprite();
		m.loadGraphic(Globals.levelMaps[LevelNo]);
		
		var data:Array<Int> = [];
		var x:Int = 0;
		var y :Int = 0;
		var newT:Int = 0;
		for (y in 0...Std.int(m.height))
		{
			for (x in 0...Std.int(m.width))
			{
				trace(m.pixels.getPixel32(x, y), FlxColor.BLACK, 0x000000, 0xff000000);
				switch (m.pixels.getPixel32(x, y)) 
				{
					case FlxColor.BLACK:
						newT = 4;
					case FlxColor.BLUE:
						newT = 1;
						player = new Player(x * 48, y * 48);
						
					case FlxColor.RED:
						newT = 2;
						doorExit = new OpenDoor(x * 48, y * 48);
					case FlxColor.YELLOW:
						newT = 0;
						emitter = new Emitter(x * 48, y * 48, this);
					case FlxColor.CYAN:
						newT = 0;
						receiver = new Receiver(x * 48, y * 48);
					default:
						newT = 0;
				}
				data.push(newT);
			}
		}
		
		//level.setTileProperties(3, FlxObject.NONE, checkExit, Player, 1);
		level = new FlxTilemap();
		level.loadMapFromArray(data, 33, 16, AssetPaths.tiles__png , 48, 48, FlxTilemapAutoTiling.OFF,0, 1, 3);
		
		var xOff:Float = ((FlxG.width / 2) - (level.width / 2)) - level.x;
		var yOff:Float = (FlxG.height -level.height) - level.y;
		
		level.x += xOff;
		level.y += yOff;
		player.x += xOff;
		player.y += yOff;
		doorExit.x += xOff;
		doorExit.y += yOff;
		emitter.x += xOff;
		emitter.y += yOff;
		receiver.x += xOff;
		receiver.y += yOff;
		
		add(level);
		add(emitter);
		add(receiver);
		grpTrans = new FlxTypedGroup<Transmission>();
		add(grpTrans);
		add(doorExit);
		add(player);
		
		
	}
	
	
}

package;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	
	public var level:FlxTilemap;
	public var doorExit:OpenDoor;
	public var player:Player;
	public var emitter:Emitter;
	public var receiver:Receiver;
	public var grpTrans:FlxTypedGroup<Transmission>;
	public var grpMirrors:FlxTypedGroup<Mirror>;
	public var grpHazards:FlxTypedGroup<Hazard>;
	public var grpEnemies:FlxTypedGroup<Enemy>;
	public var ready:Bool = false;
	
	public var timer:FlxText;
	public var room:FlxText;
	
	override public function create():Void
	{
		
		UIControl.initKeys();
		UIControl.init([]);
		
		add(new FlxSprite(0, 0, AssetPaths.Background__png));
		
		loadLevel(Globals.level);
		
		FlxG.worldBounds.set(level.x, level.y, level.width, level.height);
	
		
		var hudBack:FlxSprite = new FlxSprite();
		hudBack.makeGraphic(FlxG.width, Std.int(level.y), 0x99000000);
		add(hudBack);
			
		room = new FlxText(24, 24, 400, "Room " + Std.string(Globals.level+1), 64);
		add(room);
		
		timer = new FlxText(FlxG.width - 424, 24, 400, "00:00", 64);
		timer.alignment = FlxTextAlign.RIGHT;
		add(timer);
		
		FlxG.camera.flash(FlxColor.WHITE, .33, function() {
			ready = true;
			if (!Globals.soundPlaying)
			{
				#if flash
				FlxG.sound.playMusic(AssetPaths.music__mp3);
				#else
				FlxG.sound.playMusic(AssetPaths.music__ogg);
				#end
				Globals.soundPlaying = true;
			}
		});
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		UIControl.checkControls(elapsed);
		if(ready && player.alive)
		{
			Globals.levelTimer += elapsed;
			player.movement(elapsed);
		}
		super.update(elapsed);
		FlxG.overlap(doorExit, player, playerTouchExit, checkPlayerTouchExit);
		FlxG.overlap(grpMirrors, player, playerTouchMirror, checkPlayerTouchMirror);
		FlxG.collide(level, player);
		FlxG.overlap(grpTrans, grpMirrors, transTouchMirror, checkTransTouchMirror);
		FlxG.overlap(grpTrans, receiver,  transTouchReceiver);
		FlxG.overlap(grpHazards, player, playerTouchHazard, checkPlayerTouchHazard);
		FlxG.collide(grpTrans, level);
		FlxG.collide(grpEnemies, level);
		FlxG.overlap(grpEnemies, player, enemyTouchedPlayer, checkEnemyTouchedPlayer);
		
		timer.text = Globals.convertTime(Globals.levelTimer);
		
		
	}
	
	private function checkEnemyTouchedPlayer(E:Enemy, P:Player):Bool
	{
		return E.alive && E.exists && P.alive && P.exists;
	}
	
	private function enemyTouchedPlayer(E:Enemy, P:Player):Void
	{
		P.kill();
	}
	
	
	private function checkPlayerTouchHazard(H:Hazard, P:Player):Bool
	{
		return (P.alive && P.exists && H.alive && H.exists && H.visible);
	}
	
	private function playerTouchHazard(H:Hazard, P:Player)
	{
		P.kill();
	}
	
	private function playerTouchMirror(M:Mirror, P:Player):Void
	{
		M.touch();
	}
	private function checkPlayerTouchMirror(M:Mirror, P:Player):Bool
	{
		return (M.alive && M.exists && P.alive && P.exists);
	}
	
	private function playerTouchExit(D:OpenDoor, P:Player):Void
	{
		if (!ready)
			return;
		ready = false;
		
		FlxG.camera.flash(FlxColor.YELLOW, .1, function() {
			FlxG.camera.fade(FlxColor.BLACK, .33, false, function() {
				Globals.scores.push(Globals.levelTimer);
				
				// if we were on the last level...
				if (Globals.level >= Globals.levelMaps.length-1  )
				{
					// GO TO GAME END
					FlxG.switchState(new GameEndState());
				}
				else
				{
					Globals.levelTimer = 0;
					Globals.level++;
					FlxG.resetState();
				}
			});
		});
		
	}
	
	private function checkPlayerTouchExit(D:OpenDoor, P:Player):Bool
	{
		return (D.alive && D.exists && P.alive && P.exists);
	}
	
	private function checkTransTouchMirror(T:Transmission, M:Mirror):Bool
	{
		return (T.alive && T.exists && M.alive && M.exists);
		
	}
	
	private function transTouchMirror(T:Transmission, M:Mirror):Void
	{
		switch (T.angle) 
		{
			case 0:
				if (M.facing == FlxObject.LEFT)
				{
					emit(M.x, M.y - 48, -90);
				}
				else
				{
					emit(M.x, M.y + 48, 90);
				}
			case 90:
				if (M.facing == FlxObject.LEFT)
				{
					emit(M.x-48, M.y, 180);
				}
				else
				{
					emit(M.x+48, M.y, 0);
				}
			case -90:
				if (M.facing == FlxObject.LEFT)
				{
					emit(M.x+48, M.y , 0);
				}
				else
				{
					emit(M.x-48, M.y, 180);
				}
			case 180:
				if (M.facing == FlxObject.LEFT)
				{
					emit(M.x, M.y + 48, 90);
				}
				else
				{
					emit(M.x, M.y - 48, -90);
				}
				
		}
		T.kill();
	}
	
	private function transTouchReceiver(T:Transmission, R:Receiver):Void
	{
		if (T.alive)
		{
			T.kill();
			if (!doorExit.alive)
			{
				R.animation.play("blink");
				doorExit.revive();
			}
		}
	}
	
	
	
	public function emit(X:Float, Y:Float, Angle:Int = 0):Void
	{
	
		
		var t:Transmission = grpTrans.recycle(Transmission);
		
		if (t == null)
		{
			t  = new Transmission();
		}
		
		if (t.overlapsAt(X + 12, Y + 12, level))
		{
			t.kill();
			return;
		}
		
		t.reset(X+12, Y+12);
		
		t.angle = Angle;
		var p:FlxPoint = FlxPoint.get(600, 0).rotate(FlxPoint.weak(), Angle);
		t.velocity.x = p.x;
		t.velocity.y = p.y;
		
		grpTrans.add(t);
	}
	
	private function loadLevel(LevelNo:Int):Void
	{
		
		grpMirrors = new FlxTypedGroup<Mirror>();
		grpHazards = new FlxTypedGroup<Hazard>();
		grpEnemies = new FlxTypedGroup<Enemy>();
		
		var m:FlxSprite = new FlxSprite();
		m.loadGraphic(Globals.levelMaps[LevelNo]);
		
		var data:Array<Int> = []; 
		var x:Int = 0;
		var y :Int = 0;
		var newT:Int = 0;
		var mr:Mirror;
		var h:Hazard;
		var e:Enemy;
		for (y in 0...Std.int(m.height))
		{
			for (x in 0...Std.int(m.width))
			{
				//trace(m.pixels.getPixel32(x, y), FlxColor.GREEN, 0x000000, 0xff000000);
				switch (m.pixels.getPixel32(x, y)) 
				{
					case FlxColor.BLACK:
						newT = 4;
					case FlxColor.BLUE:
						newT = 1;
						player = new Player(x * 48, y * 48, this);
						
					case FlxColor.RED:
						newT = 2;
						doorExit = new OpenDoor(x * 48, y * 48);
					case FlxColor.YELLOW:
						newT = 0;
						emitter = new Emitter(x * 48, y * 48, this);
					case FlxColor.CYAN:
						newT = 0;
						receiver = new Receiver(x * 48, y * 48);
					case 0xFFFF6000:
						newT = 0;
						mr = new Mirror(x * 48, y * 48);
						mr.facing = FlxObject.RIGHT;
						grpMirrors.add(mr);
					case 0xFFFFCCCC:
						newT = 0;
						mr = new Mirror(x * 48, y * 48);
						mr.facing = FlxObject.LEFT;
						grpMirrors.add(mr);
					case FlxColor.MAGENTA:
						newT = 0;
						h = new Hazard(x * 48, y * 48);
						grpHazards.add(h);
					case 0xff00ff00:
						newT = 0;
						e = new Enemy(x * 48, y * 48);
						grpEnemies.add(e);
					case 0xff600060:
						newT = 0;
						h = new Hazard(x * 48, y * 48, 1);
						grpHazards.add(h);
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
		for (mr in grpMirrors)
		{
			mr.x += xOff;
			mr.y += yOff;
		}
		for (h in grpHazards)
		{
			h.x += xOff;
			h.y += yOff;
		}
		for (e in grpEnemies)
		{
			e.x += xOff;
			e.y += yOff;
		}
		
		add(level);
		add(grpHazards);
		add(emitter);
		add(receiver);
		add(grpMirrors);
		grpTrans = new FlxTypedGroup<Transmission>();
		add(grpTrans);
		add(doorExit);
		add(grpEnemies);
		add(player);
		
		
	}
	
	public function death()
	{
		FlxG.camera.fade(FlxColor.BLACK, .66, false, function() {
			FlxG.resetState();
		});
		
	}
}

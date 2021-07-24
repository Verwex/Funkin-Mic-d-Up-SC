package;

import flixel.tweens.FlxTween;
import openfl.media.Sound;
import sys.FileSystem;
import sys.io.File;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.io.Path;
import openfl.Lib;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import MainVariables._variables;

using StringTools;

class VideoState extends MusicBeatState
{
	static private var nativeFramecount:String->Int = cpp.Lib.load("webmHelper", "GetFramecount", 1);

	public var filePath:String;
	public var _load:FileReference;
	public var transClass:FlxState;
	public var txt:FlxText;
	public var txt2:FlxText;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var defaultText:String = "";
	public var doShit:Bool = false;
	public var pauseText:String = "Press P to pause/unpause.";
	public var skipText:String = "Press to skip.";
	public var autoPause:Bool = false;
	public var musicPaused:Bool = false;
	public var file:String = "";

	public var looping:Bool = false;
	public var loadWEBM:Bool = false;
	public var skip:Bool = true;

	public function new(fileName:String, toTrans:FlxState, frameSkipLimit:Int = -1, autopause:Bool = false, ?looped:Bool = false, ?loadWebm:Bool = false, ?skippable:Bool = true)
	{
		super();

		looping = looped;
		autoPause = autopause;
		file = fileName;
		loadWEBM = loadWebm;
		skip = skippable;

		filePath = "assets/videos/" + fileName + ".webm";
		transClass = toTrans;
		if (frameSkipLimit != -1 && GlobalVideo.isWebm)
		{
			GlobalVideo.getWebm().webm.SKIP_STEP_LIMIT = frameSkipLimit;
		}

		if (skip)
		{
			skipText = "Press "
				+ Controls.keyboardMap.get("ACCEPT").toString()
				+ " or "
				+ Controls.keyboardMap.get("ACCEPT (ALTERNATE)").toString()
				+ " to end the video. ";
				
			if (loadWEBM)
				skipText + "Press E to load a webm file. (ONLY ACCEPTS WEBMS IN MODS/WEBMS/ FOLDER)";
		}
	}

	public function frameCount():Int
	{
		return nativeFramecount(filePath);
	}

	var funnySprite:FlxSprite;

	override function create()
	{
		super.create();
		FlxG.autoPause = false;
		doShit = false;

		if (GlobalVideo.isWebm)
		{
			#if cpp
			videoFrames = frameCount();

			trace("swag dll told us vid has " + videoFrames);

			if (videoFrames == 0)
			{
			#end
				videoFrames = Std.parseInt(Assets.getText(filePath.replace(".webm", ".txt")));

			#if cpp
			}
			#end
		}

		fuckingVolume = _variables.mvolume;
		FlxG.sound.music.volume = 0;
		var isHTML:Bool = false;
		#if web
		isHTML = true;
		#end
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var html5Text:String = "You Are Not Using HTML5...\nThe Video Didnt Load!";
		if (isHTML)
		{
			html5Text = "You Are Using HTML5!";
		}
		defaultText = "If Your On HTML5\nTap Anything...\nThe Bottom Text Indicates If You\nAre Using HTML5...\n\n" + html5Text;
		txt = new FlxText(0, 0, FlxG.width, defaultText, 32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();

		txt2 = new FlxText(3, FlxG.height - 18, 0, skipText, 32);
		txt2.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, CENTER);
		txt2.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		// txt2.screenCenter();

		if (GlobalVideo.isWebm)
		{
			if (Assets.exists(filePath.replace(".webm", ".ogg"), MUSIC) || Assets.exists(filePath.replace(".webm", ".ogg"), SOUND))
			{
				useSound = true;
				vidSound = FlxG.sound.play(Sound.fromFile(filePath.replace(".webm", ".ogg")));
			}
		}

		GlobalVideo.get().source(filePath);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().hide();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().restart();
		}
		else
		{
			GlobalVideo.get().play();
		}

		funnySprite = new FlxSprite().loadGraphic((cast(openfl.Lib.current.getChildAt(0), Main)).webmHandle.webm.bitmapData);
		funnySprite.setGraphicSize(FlxG.width, FlxG.height);
		funnySprite.screenCenter();
		add(txt);
		add(funnySprite);
		add(txt2);

		// var overlay = new FlxSprite().loadGraphic(Paths.image('titlescreen/overlay'));
		// overlay.setGraphicSize(FlxG.width, FlxG.height);
		// overlay.screenCenter();
		// add(overlay);
		// overlay.y -= 200;

		// FlxTween.tween(overlay, {y: 0}, 1, {startDelay: 1});
		// FlxTween.tween(overlay, {y: overlay.y - 100}, 1, {startDelay: 5});

		/*if (useSound)
			{ */
		// vidSound = FlxG.sound.play(filePath.replace(".webm", ".ogg"));

		/*new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{ */
		vidSound.time = vidSound.length * soundMultiplier;
		/*new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				if (useSound)
				{
					vidSound.time = vidSound.length * soundMultiplier;
				}
		}, 0);*/
		doShit = true;
		// }, 1);
		// }

		if (autoPause && FlxG.sound.music != null && FlxG.sound.music.playing)
		{
			musicPaused = true;
			FlxG.sound.music.pause();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (useSound)
		{
			var wasFuckingHit = GlobalVideo.get().webm.wasHitOnce;
			soundMultiplier = GlobalVideo.get().webm.renderedCount / videoFrames;

			if (soundMultiplier > 1)
			{
				soundMultiplier = 1;
			}
			if (soundMultiplier < 0)
			{
				soundMultiplier = 0;
			}
			if (doShit)
			{
				var compareShit:Float = 50;
				if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit
					|| vidSound.time <= (vidSound.length * soundMultiplier) - compareShit)
					vidSound.time = vidSound.length * soundMultiplier;
			}
			if (wasFuckingHit)
			{
				if (soundMultiplier == 0)
				{
					if (prevSoundMultiplier != 0)
					{
						vidSound.pause();
						vidSound.time = 0;
					}
				}
				else
				{
					if (prevSoundMultiplier == 0)
					{
						vidSound.resume();
						vidSound.time = vidSound.length * soundMultiplier;
					}
				}
				prevSoundMultiplier = soundMultiplier;
			}
		}

		if (notDone)
		{
			FlxG.sound.music.volume = 0;
		}
		GlobalVideo.get().update(elapsed);

		if (controls.RESET)
		{
			GlobalVideo.get().stop();
			File.copy('assets/videos/_backup/paint.webm', 'assets/videos/paint.webm');
			File.copy('assets/videos/_backup/paint.ogg', 'assets/videos/paint.ogg');
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(new VideoState(file, transClass, -1, true, looping, loadWEBM));
		}

		if (GlobalVideo.get().ended)
		{
			GlobalVideo.get().stop();
			// File.copy('assets/videos/_backup/paint.webm', 'assets/videos/paint.webm');
			// File.copy('assets/videos/_backup/paint.ogg', 'assets/videos/paint.ogg');
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;

			if (looping)
				FlxG.switchState(new VideoState(file, transClass, -1, true, looping, loadWEBM));
			else
				FlxG.switchState(transClass);
		}

		if (FlxG.keys.justPressed.E && loadWEBM)
		{
			load();
			txt.text = pauseText;
			trace("PRESSED PAUSE");
			GlobalVideo.get().togglePause();
			GlobalVideo.get().alpha();
			funnySprite.alpha = 0.2;
		}

		if (FlxG.keys.justPressed.P)
		{
			txt.text = pauseText;
			trace("PRESSED PAUSE");
			GlobalVideo.get().togglePause();
			if (GlobalVideo.get().paused)
			{
				GlobalVideo.get().alpha();
				funnySprite.alpha = 0.2;
			}
			else
			{
				GlobalVideo.get().unalpha();
				funnySprite.alpha = 1;
				txt.text = defaultText;
			}
		}

		if (controls.ACCEPT || GlobalVideo.get().stopped)
		{
			txt.visible = false;
			txt2.visible = false;
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
		}

		if (controls.ACCEPT && skip)
		{
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			txt.text = pauseText;
			if (musicPaused)
			{
				musicPaused = false;
				FlxG.sound.music.resume();
			}
			FlxG.autoPause = true;
			FlxTransitionableState.skipNextTransIn = false;
			FlxTransitionableState.skipNextTransOut = true;
			vidSound.stop();
			FlxG.switchState(transClass);
		}

		if (GlobalVideo.get().played || GlobalVideo.get().restarted)
		{
			GlobalVideo.get().hide();
		}

		GlobalVideo.get().restarted = false;
		GlobalVideo.get().played = false;
		GlobalVideo.get().stopped = false;
		GlobalVideo.get().ended = false;
	}

	private function load()
	{
		_load = new FileReference();
		_load.addEventListener(Event.SELECT, selectFile);

		var Filter = new openfl.net.FileFilter("WEBM Files", "*.webm");
		_load.browse([Filter]);
	}

	function selectFile(_):Void
	{
		_load.addEventListener(Event.COMPLETE, onLoadComplete);
		_load.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_load.load();
	}

	function onLoadError(_):Void
	{
		_load.removeEventListener(Event.COMPLETE, onLoadComplete);
		_load.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_load = null;
		FlxG.log.error("Problem loading webm data");
	}

	function onLoadComplete(_):Void
	{
		_load.removeEventListener(Event.COMPLETE, onLoadComplete);
		_load.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);

		if ((_load.data != null) && (_load.data.length > 0))
		{
			var webmName:String = _load.name.replace('.webm', '');

			FlxG.log.add("loading coolio data");
			FlxG.log.add(webmName);

			GlobalVideo.get().stop();
			if (webmName.toLowerCase() == 'paint')
			{
				File.copy('assets/videos/_backup/paint.webm', 'assets/videos/paint.webm');
				File.copy('assets/videos/_backup/paint.ogg', 'assets/videos/paint.ogg');
			}
			else
			{
				File.copy('mods/webms/' + webmName + '.webm', 'assets/videos/' + webmName.replace(webmName, 'paint.webm'));
				File.copy('mods/webms/' + webmName + '.ogg', 'assets/videos/' + webmName.replace(webmName, 'paint.ogg'));
			}

			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(new VideoState(file, transClass, -1, true, looping, loadWEBM));
		}
	}
}
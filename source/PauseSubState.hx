package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import MainVariables._variables;
import flixel.util.FlxTimer;

using StringTools;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var loopNum:Int = 0;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
	var curSelected:Int = 0;

	var pageTitle:String = "Normal";

	var pauseMusic:FlxSound;
	var loopCallback:Bool->Void;
	var loopState:LoopState;

	var startedCountdown:Bool = false;

	public function new(x:Float, y:Float,loopCallback:Bool->Void,loopState:LoopState)
	{
		super();

		this.loopCallback = loopCallback;
		this.loopState = loopState;

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast', 'shared'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();

		switch (PlayState.gameplayArea)
		{
			case "Endless":
				levelDifficulty.text = 'Loop '+loopNum;
			case "Charting":
				levelDifficulty.text = 'Charting State';
			case "Survival":
				levelDifficulty.text = 'Survival State';
		}

		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var deathCounter:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		deathCounter.text += "blue balled: "+Highscore.getDeaths(PlayState.SONG.song, PlayState.storyDifficulty);
		deathCounter.scrollFactor.set();
		deathCounter.setFormat(Paths.font("vcr.ttf"), 32);
		deathCounter.updateHitbox();
		add(deathCounter);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		deathCounter.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		deathCounter.x = FlxG.width - (deathCounter.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(deathCounter, {alpha: 1, y: deathCounter.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		changeItems();

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5 * _variables.mvolume/100)
			pauseMusic.volume += 0.01 * _variables.mvolume/100 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP  && !startedCountdown)
		{
			changeSelection(-1);
		}
		if (downP  && !startedCountdown)
		{
			changeSelection(1);
		}

		if (controls.BACK && pageTitle != "Normal" && !startedCountdown)
		{
			pageTitle = "Normal";
			changeItems();
		}

		if (accepted && !startedCountdown)
		{
			var daSelected:String = menuItems[curSelected];

			switch (pageTitle)
			{
				case "Normal":
					switch (daSelected)
					{
						case "Resume":
							if (_variables.pauseCountdown)
							{
								startedCountdown = true;
								startCountdown();
							}
							else
								close();
						case "Restart Song":
							FlxG.resetState();
							PlayState.ended = false;
						case "Chart":
							PlayState.ended = false;
							FlxG.switchState(new ChartingState());
						case "Change Difficulty":
							pageTitle = "Difficulty";
							changeItems();
						case "Exit to menu":
							PlayState.curDeaths = 0;
							PlayState.ended = false;
							PlayState.loops = 0;
							PlayState.speed = 0;
							var image = lime.graphics.Image.fromFile('assets/images/iconOG.png');
							lime.app.Application.current.window.setIcon(image);
							switch (PlayState.gameplayArea)
							{
								case "Story":
									FlxG.switchState(new MenuWeek());
								case "Freeplay":
									FlxG.switchState(new MenuFreeplay());
								case "Marathon":
									FlxG.switchState(new MenuMarathon());
								case "Endless":
									FlxG.switchState(new MenuEndless());
								case "Charting":
									FlxG.switchState(new PlaySelection());
								case "Survival":
									FlxG.switchState(new MenuSurvival());
							}
					}

					if (PlayState.gameplayArea == "Freeplay" || PlayState.gameplayArea == "Charting")
					{
						switch (curSelected)
						{
							case 3:
								loopCallback(false);
								
								if (_variables.pauseCountdown)
								{
									startedCountdown = true;
									startCountdown();
								}
								else
									close();
							case 4:
								loopCallback(true);

								if (_variables.pauseCountdown)
								{
									startedCountdown = true;
									startCountdown();
								}
								else
									close();
						}
					}

				case "Difficulty":
					var poop:String = Highscore.formatSong(PlayState.SONG.song, curSelected);
					trace(poop);

					PlayState.SONG = Song.loadFromJson(poop, PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = curSelected;
					FlxG.resetState();
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function changeItems():Void
	{
		switch (pageTitle)
		{
			case "Normal":
				switch (PlayState.gameplayArea)
				{
					case "Marathon" | "Endless" | "Survival":
						menuItems = ['Resume', 'Exit to menu'];
						loopNum = PlayState.loops+1;
					case 'Freeplay':
						menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'Loop Song', 'AB Repeat', 'Chart', 'Exit to menu'];
					case "Charting":
						menuItems = ['Resume', 'Chart', 'Restart Song', 'Loop Song', 'AB Repeat', 'Exit to menu'];
					default:
						menuItems = ['Resume', 'Restart Song', 'Exit to menu'];
				}
			case "Difficulty":
				menuItems = CoolUtil.difficultyArray;
		}

		grpMenuShit.clear();

		curSelected = 0;
		changeSelection();
		
		updateLoopState();

		for (i in 0...menuItems.length)
			{
				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
				songText.itemType = "Classic";
				songText.targetY = i;
				grpMenuShit.add(songText);
			}
	}

	function updateLoopState()
	{
		if ((PlayState.gameplayArea == "Freeplay" || PlayState.gameplayArea == "Charting") && pageTitle == "Normal")
		{
			FlxG.log.add(loopState);

			switch (loopState)
			{
				case NONE:
					menuItems[3] = 'Loop Song';
					menuItems[4] = 'AB Repeat';
				case REPEAT:
					menuItems[3] = 'Stop Repeating';
					menuItems[4] = 'AB Repeat';
				case ANODE:
					menuItems[3] = 'Cancel AB repeat';
					menuItems[4] = 'Confirm B Node';
				case ABREPEAT:
					menuItems[3] = 'Loop Song';
					menuItems[4] = 'Stop Repeating';
			}
		}
	}


	var swagCounter:Int = 0;

	function startCountdown():Void
	{
		var startTimer:FlxTimer;

		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

		var introAlts:Array<String> = introAssets.get('default');
		var altSuffix:String = "";

		for (value in introAssets.keys())
		{
			if (value == PlayState.curStage)
			{
				introAlts = introAssets.get(value);
				altSuffix = '-pixel';
			}
		}

		FlxG.sound.play(Paths.sound('intro3' + altSuffix, 'shared'), 0.6 * _variables.svolume / 100);

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{

			switch (swagCounter)
			{
				case 0:
					var ready:FlxSprite = new FlxSprite();

					if (introAlts[0] == 'ready')
						ready.loadGraphic(Paths.image(introAlts[0], 'shared'));
					else
						ready.loadGraphic(Paths.image(introAlts[0], 'week6'));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (PlayState.curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * PlayState.daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix, 'shared'), 0.6 * _variables.svolume / 100);
				case 1:
					var set:FlxSprite = new FlxSprite();

					if (introAlts[1] == 'set')
						set.loadGraphic(Paths.image(introAlts[1], 'shared'));
					else
						set.loadGraphic(Paths.image(introAlts[1], 'week6'));

					set.scrollFactor.set();

					if (PlayState.curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * PlayState.daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix, 'shared'), 0.6 * _variables.svolume / 100);
				case 2:
					var go:FlxSprite = new FlxSprite();

					if (introAlts[2] == 'go')
						go.loadGraphic(Paths.image(introAlts[2], 'shared'));
					else
						go.loadGraphic(Paths.image(introAlts[2], 'week6'));

					if (PlayState.curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * PlayState.daPixelZoom));

					go.scrollFactor.set();

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix, 'shared'), 0.6 * _variables.svolume / 100);
				case 3:
					close();
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 4);
	}
}

package;

import sys.io.File;
import sys.FileSystem;
import Discord.DiscordClient;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import MainVariables._variables;
import flixel.tweens.FlxEase;

using StringTools;

class PAGE2settings extends MusicBeatSubstate
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionShit:Array<String> = ['page', 'mvolume', 'svolume', 'vvolume', 'hitsound', 'hvolume', 'music', 'muteMiss'];

	private var grpSongs:FlxTypedGroup<Alphabet>;
	var selectedSomethin:Bool = false;
	var curSelected:Int = 0;
	var camFollow:FlxObject;

	var ResultText:FlxText = new FlxText(20, 69, FlxG.width, "", 48);
	var ExplainText:FlxText = new FlxText(20, 69, FlxG.width / 2, "", 48);

	var pause:Int = 0;

	var camLerp:Float = 0.32;
	var mus:Int;
	var hit:Int;

	var navi:FlxSprite;

	public function new()
	{
		super();

		persistentDraw = persistentUpdate = true;
		destroySubStates = false;

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('Options_Buttons');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(950, 30 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24, true);
			menuItem.animation.addByPrefix('select', optionShit[i] + " select", 24, true);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.scrollFactor.x = 0;
			menuItem.scrollFactor.y = 1;

			menuItem.x = 2000;
			FlxTween.tween(menuItem, {x: 800}, 0.15, {ease: FlxEase.expoInOut});
		}

		var nTex = Paths.getSparrowAtlas('Options_Navigation');
		navi = new FlxSprite();
		navi.frames = nTex;
		navi.animation.addByPrefix('arrow', "navigation_arrows", 24, true);
		navi.animation.addByPrefix('enter', "navigation_enter", 24, true);
		navi.animation.addByPrefix('shiftArrow', "navigation_shiftArrow", 24, true);
		navi.animation.play('arrow');
		navi.scrollFactor.set();
		add(navi);
		navi.y = 700 - navi.height;
		navi.x = 1260 - navi.width;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		changeItem();

		createResults();

		updateResults();

		FlxG.camera.follow(camFollow, null, camLerp);

		DiscordClient.changePresence("Settings page: SFX", null);
	}

	function createResults():Void
	{
		add(ResultText);
		ResultText.scrollFactor.x = 0;
		ResultText.scrollFactor.y = 0;
		ResultText.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER);
		ResultText.x = -400;
		ResultText.y = 350;
		ResultText.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		ResultText.alpha = 0;
		FlxTween.tween(ResultText, {alpha: 1}, 0.15, {ease: FlxEase.expoInOut});

		add(ExplainText);
		ExplainText.scrollFactor.x = 0;
		ExplainText.scrollFactor.y = 0;
		ExplainText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER);
		ExplainText.alignment = LEFT;
		ExplainText.x = 20;
		ExplainText.y = 624;
		ExplainText.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		ExplainText.alpha = 0;
		FlxTween.tween(ExplainText, {alpha: 1}, 0.15, {ease: FlxEase.expoInOut});
	}

	function updateResults():Void
	{
		mus = MainVariables.musicList.indexOf(_variables.music.toLowerCase());
		hit = MainVariables.hitList.indexOf(_variables.hitsound.toLowerCase());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
				changeItem(1);
			}

			if (controls.LEFT_P)
			{
				changePress(-1);
			}

			if (controls.RIGHT_P)
			{
				changePress(1);
			}

			if (controls.LEFT)
			{
				changeHold(-1);
			}

			if (controls.RIGHT)
			{
				changeHold(1);
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume / 100);
				selectedSomethin = true;

				DiscordClient.changePresence("Back to the main menu I go!", null);

				menuItems.forEach(function(spr:FlxSprite)
				{
					spr.animation.play('idle');
					FlxTween.tween(spr, {x: -1000}, 0.15, {ease: FlxEase.expoIn});
				});

				FlxTween.tween(FlxG.camera, {zoom: 7}, 0.5, {ease: FlxEase.expoIn, startDelay: 0.2});
				FlxTween.tween(ResultText, {alpha: 0}, 0.15, {ease: FlxEase.expoIn});
				FlxTween.tween(ExplainText, {alpha: 0}, 0.15, {ease: FlxEase.expoIn});

				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				});
			}
		}

		switch (optionShit[curSelected])
		{
			case "mvolume":
				ResultText.text = _variables.mvolume + "%";
				ExplainText.text = "MUSIC VOLUME:\nChange the volume of your music.";
			case "svolume":
				ResultText.text = _variables.svolume + "%";
				ExplainText.text = "SOUND VOLUME:\nChange the volume of some ambience and other sounds.";
			case "vvolume":
				ResultText.text = _variables.vvolume + "%";
				ExplainText.text = "VOCAL VOLUME:\nChange the volume of vocals heard in songs.";
			case "hvolume":
				ResultText.text = _variables.hvolume + "%";
				ExplainText.text = "HITSOUND VOLUME:\nChange the volume of note hitsounds.";
			case "page":
				ResultText.text = "";
				ExplainText.text = "Previous Page: GENERAL \nNext Page: GFX";
			case "muteMiss":
				ResultText.text = Std.string(_variables.muteMiss).toUpperCase();
				ExplainText.text = "MUTE ON MISS:\nMute vocals when you miss a note.";
			case "music":
				ResultText.text = Std.string(_variables.music).toUpperCase();
				ExplainText.text = "MENU MUSIC:\nChange your very own menu music.";
			case "hitsound":
				ResultText.text = Std.string(_variables.hitsound).toUpperCase();
				ExplainText.text = "HITSOUND:\nChange what sound you want to play when you hit a note to get you into rhythm.";
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.scale.set(FlxMath.lerp(spr.scale.x, 0.5, camLerp / (_variables.fps / 60)), FlxMath.lerp(spr.scale.y, 0.5, 0.4 / (_variables.fps / 60)));

			if (spr.ID == curSelected)
			{
				camFollow.y = FlxMath.lerp(camFollow.y, spr.getGraphicMidpoint().y, camLerp / (_variables.fps / 60));
				camFollow.x = spr.getGraphicMidpoint().x;
				spr.scale.set(FlxMath.lerp(spr.scale.x, 0.9, camLerp / (_variables.fps / 60)), FlxMath.lerp(spr.scale.y, 0.9, 0.4 / (_variables.fps / 60)));
			}

			spr.updateHitbox();
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('select');
			}

			spr.updateHitbox();
		});

		switch (optionShit[curSelected])
		{
			case 'mvolume'|'svolume'|'vvolume':
				navi.animation.play('shiftArrow');
			default:
				navi.animation.play('arrow');
		}
	}

	function changePress(Change:Int = 0)
	{
		switch (optionShit[curSelected])
		{
			case "muteMiss":
				_variables.muteMiss = !_variables.muteMiss;

				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
			case 'page':
				SettingsState.page += Change;
				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
				selectedSomethin = true;

				menuItems.forEach(function(spr:FlxSprite)
				{
					spr.animation.play('idle');
					FlxTween.tween(spr, {x: -1000}, 0.15, {ease: FlxEase.expoIn});
				});

				FlxTween.tween(ResultText, {alpha: 0}, 0.15, {ease: FlxEase.expoIn});
				FlxTween.tween(ExplainText, {alpha: 0}, 0.15, {ease: FlxEase.expoIn});

				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					navi.kill();
					menuItems.kill();
					if (Change == 1)
						openSubState(new PAGE3settings());
					else
						openSubState(new PAGE1settings());
				});
			case "music":
				mus += Change;
				if (mus > MainVariables.musicList.length - 1)
					mus = 0;
				if (mus < 0)
					mus = MainVariables.musicList.length - 1;

				_variables.music = MainVariables.musicList[mus];

				if (FileSystem.exists(Paths.music('menu/' + _variables.music)))
				{
					FlxG.sound.playMusic(Paths.music('menu/' + _variables.music), _variables.mvolume / 100);
					Conductor.changeBPM(Std.parseFloat(File.getContent('assets/music/menu/' + _variables.music + '_BPM.txt')));
				}
				else
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'), _variables.mvolume / 100);
					Conductor.changeBPM(102);
				}
			case "hitsound":
				hit += Change;
				if (hit > MainVariables.hitList.length - 1)
					hit = 0;
				if (hit < 0)
					hit = MainVariables.hitList.length - 1;
	
				_variables.hitsound = MainVariables.hitList[hit];

				if (_variables.hitsound.toLowerCase() != 'none')
					FlxG.sound.play(Paths.sound('hitsounds/' + _variables.hitsound, 'shared'), _variables.hvolume/100);
		}

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			MainVariables.Save();
		});
	}

	function changeHold(Change:Int = 0)
	{
		if (controls.CENTER)
			Change *= 2;

		switch (optionShit[curSelected])
		{
			case "mvolume":
				_variables.mvolume += Change;
				if (_variables.mvolume < 0)
					_variables.mvolume = 0;
				if (_variables.mvolume > 100)
					_variables.mvolume = 100;

				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
				FlxG.sound.music.volume = _variables.mvolume / 100;
			case "svolume":
				_variables.svolume += Change;
				if (_variables.svolume < 0)
					_variables.svolume = 0;
				if (_variables.svolume > 100)
					_variables.svolume = 100;

				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
			case "vvolume":
				_variables.vvolume += Change;
				if (_variables.vvolume < 0)
					_variables.vvolume = 0;
				if (_variables.vvolume > 100)
					_variables.vvolume = 100;

				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
			case "hvolume":
				_variables.hvolume += Change;
				if (_variables.hvolume < 0)
					_variables.hvolume = 0;
				if (_variables.hvolume > 100)
					_variables.hvolume = 100;

				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
		}

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			MainVariables.Save();
		});
	}

	override function openSubState(SubState:FlxSubState)
	{
		super.openSubState(SubState);
	}
}

package;

import sys.io.File;
import sys.FileSystem;
import flixel.util.FlxGradient;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import MainVariables._variables;

using StringTools;

class SettingsState extends MusicBeatState
{
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Options_Checker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);

	public static var page:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var pageArray:Array<String> = ['general', 'sfx', 'gfx', 'gameplay', 'miscellaneous', 'clear'];
	var pageText:FlxText = new FlxText(20, 69, FlxG.width, "", 48);

	override public function create():Void
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
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
		}

		super.create();

		persistentUpdate = persistentDraw = true;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('oBG'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		menuBG.scrollFactor.x = 0;
		menuBG.scrollFactor.y = 0.011;
		add(menuBG);

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x558DE7E5, 0xAAE6F0A9], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		add(checker);
		checker.scrollFactor.set(0, 0.07);

		var side:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('Options_Side'));
		side.scrollFactor.x = 0;
		side.scrollFactor.y = 0;
		side.antialiasing = true;
		add(side);
		side.x = 0;

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('Options_Page');

		for (i in 0...pageArray.length)
		{
			var menuItem:FlxSprite = new FlxSprite(10 + (i * 70), 50);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', "PI_idle", 24, true);
			menuItem.animation.addByPrefix('select', "PI_select", 24, true);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		add(pageText);
		pageText.scrollFactor.x = 0;
		pageText.scrollFactor.y = 0;
		pageText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT);
		pageText.x = 10;
		pageText.y = 65;
		pageText.setBorderStyle(OUTLINE, 0xFF000000, 2, 1);

		FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.5, {ease: FlxEase.expoInOut});

		new FlxTimer().start(0.75, function(tmr:FlxTimer)
		{
			startIntro(page);
		}); // gotta wait for a trnsition to be over because that apparently breaks it.
	}

	function startIntro(page:Int)
	{
		switch (page)
		{
			case 0:
				FlxG.state.openSubState(new PAGE1settings());
			case 1:
				FlxG.state.openSubState(new PAGE2settings());
			case 2:
				FlxG.state.openSubState(new PAGE3settings());
			case 3:
				FlxG.state.openSubState(new PAGE4settings());
			case 4:
				FlxG.state.openSubState(new PAGE5settings());
			case 5:
				FlxG.state.openSubState(new PAGE6settings());
		}
	}

	override function update(elapsed:Float)
	{
		checker.x -= 0.21 / (_variables.fps / 60);
		checker.y -= 0.51 / (_variables.fps / 60);

		if (page < 0)
			page = 5;
		if (page > 5)
			page = 0;

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == page)
			{
				spr.animation.play('select');
				pageText.text = pageArray[page].toUpperCase();
			}
		});
	}
}

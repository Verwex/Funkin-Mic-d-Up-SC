package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import MainVariables._variables;
import flixel.math.FlxMath;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['play', 'support', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end
	
	var camFollow:FlxObject;

	var bg:FlxSprite = new FlxSprite(-89).loadGraphic(Paths.image('mBG_Main'));
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Main_Checker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);

	var camLerp:Float = 0.1;

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		
		if (!FlxG.sound.music.playing)
		{
			switch (_variables.music)
            {
                case 'classic':
                    FlxG.sound.playMusic(Paths.music('freakyMenu'), _variables.mvolume/100);
					Conductor.changeBPM(102);
                case 'funky':
                    FlxG.sound.playMusic(Paths.music('funkyMenu'), _variables.mvolume/100);
					Conductor.changeBPM(140);
            }
		}

		persistentUpdate = persistentDraw = true;

		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.16;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.angle = 179;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55AE59E4, 0xAA19ECFF], 1, 90, true); 
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		add(checker);
		checker.scrollFactor.set(0, 0.07);


		var side:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('Main_Side'));
		side.scrollFactor.x = 0;
		side.scrollFactor.y = 0;
		side.antialiasing = true;
		add(side);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-800, 40 + (i * 200));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " select", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			FlxTween.tween(menuItem, { x: menuItem.width/4 + (i * 210) - 30}, 1.3, { ease: FlxEase.expoInOut });
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.scale.set(0.8, 0.8);
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollow, null, camLerp);

		FlxG.camera.zoom = 3;
		side.alpha = 0;
		FlxTween.tween(FlxG.camera, { zoom: 1}, 1.1, { ease: FlxEase.expoInOut });
		FlxTween.tween(bg, { angle:0}, 1, { ease: FlxEase.quartInOut});
		FlxTween.tween(side, { alpha:1}, 0.9, { ease: FlxEase.quartInOut});

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();

		new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				selectable = true;
			});
	}

	var selectedSomethin:Bool = false;
	var selectable:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8* _variables.mvolume/100)
		{
			FlxG.sound.music.volume += 0.5 * _variables.mvolume/100 * FlxG.elapsed;
		}
		

		menuItems.forEach(function(spr:FlxSprite)
			{
				spr.scale.set(FlxMath.lerp(spr.scale.x, 0.8, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 0.8, 0.4/(_variables.fps/60)));
				spr.y = FlxMath.lerp(spr.y, 40 + (spr.ID * 200), 0.4/(_variables.fps/60));
	
				if (spr.ID == curSelected)
				{
					spr.scale.set(FlxMath.lerp(spr.scale.x, 1.1, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 1.1, 0.4/(_variables.fps/60)));
					spr.y = FlxMath.lerp(spr.y, -10 + (spr.ID * 200), 0.4/(_variables.fps/60));
				}
	
				spr.updateHitbox();
			});

		checker.x -= 0.45/(_variables.fps/60);
		checker.y -= 0.16/(_variables.fps/60);

		if (!selectedSomethin && selectable)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				#if desktop
				DiscordClient.changePresence("Back to the Title Screen.", null);
				#end

				FlxG.switchState(new TitleStateReturn());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'support')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
					#if desktop
						DiscordClient.changePresence("Pogger people donate, like me.", null);
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);
					#if desktop
					DiscordClient.changePresence("Chosen: "+ optionShit[curSelected].toUpperCase(), null);
					#end

					menuItems.forEach(function(spr:FlxSprite)
					{
						FlxTween.tween(FlxG.camera, { zoom: 5}, 0.8, { ease: FlxEase.expoIn });
						FlxTween.tween(bg, { angle: 45}, 0.8, { ease: FlxEase.expoIn });
						FlxTween.tween(spr, {x: -600}, 0.6, {
							ease: FlxEase.backIn,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
							new FlxTimer().start(0.5, function(tmr:FlxTimer)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'play':
										FlxG.switchState(new PlaySelection());
										#if desktop
											DiscordClient.changePresence("Going to the play selection.", null);
										#end
									case 'options':
										FlxG.switchState(new SettingsState());
										#if desktop
											DiscordClient.changePresence("Gonna set some options brb.", null);
										#end
								}
							});
					});
				}
			}
		}

		menuItems.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == curSelected)
				{
					camFollow.y = FlxMath.lerp(camFollow.y, spr.getGraphicMidpoint().y, camLerp/(_variables.fps/60));
					camFollow.x = spr.getGraphicMidpoint().x;
				}
			});

		super.update(elapsed);
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
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});

		#if desktop
		DiscordClient.changePresence("Main Menu: "+ optionShit[curSelected].toUpperCase(), null);
		#end
	}
}

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

class PlaySelection extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['week', 'freeplay', 'marathon', 'endless', 'modifier'];
	var camFollow:FlxObject;

	var bg:FlxSprite = new FlxSprite(-89).loadGraphic(Paths.image('pBG_Main'));
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Play_Checker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);
	var side:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('Play_Bottom'));

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
		bg.scrollFactor.y = 0.03;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.y -= bg.height;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55FFC461, 0xAAFBFF89], 1, 90, true); 
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		add(checker);
		checker.scrollFactor.set(0, 0.07);

		side.scrollFactor.x = 0;
		side.scrollFactor.y = 0.1;
		side.antialiasing = true;
		side.screenCenter();
		add(side);
		side.y = FlxG.height - side.height/3*2;

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('PlaySelect_Buttons');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(i * 420, 1280);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " select", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.alpha = 0;
			FlxTween.tween(menuItem, { alpha: 1}, 1.3, { ease: FlxEase.expoInOut });
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(1, 0);
			menuItem.antialiasing = true;
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollow, null, camLerp);

		FlxG.camera.zoom = 3;
		side.alpha = checker.alpha = 0;
		FlxTween.tween(FlxG.camera, { zoom: 1}, 1.2, { ease: FlxEase.expoInOut });
		FlxTween.tween(bg, { y:-30}, 1, { ease: FlxEase.quartInOut,});
		FlxTween.tween(side, { alpha:1}, 1, { ease: FlxEase.quartInOut});
		FlxTween.tween(checker, { alpha:1}, 1.15, { ease: FlxEase.quartInOut});

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();

		new FlxTimer().start(1.1, function(tmr:FlxTimer)
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
				spr.scale.set(FlxMath.lerp(spr.scale.x, 0.5, 0.4/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 0.5, 0.07/(_variables.fps/60)));
				spr.y = FlxG.height - spr.height;
				spr.x = FlxMath.lerp(spr.x, spr.ID * 420 + 240, 0.4/(_variables.fps/60));
	
				if (spr.ID == curSelected)
				{
					spr.scale.set(FlxMath.lerp(spr.scale.x, 2, 0.4/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 2, 0.07/(_variables.fps/60)));
					spr.x = FlxMath.lerp(spr.x, spr.ID * 420, 0.4/(_variables.fps/60));
				}
	
				spr.updateHitbox();
			});

		checker.x -= 0.03/(_variables.fps/60);
		checker.y -= 0.20/(_variables.fps/60);

		if (!selectedSomethin && selectable)
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
				changeItem(-1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());

				#if desktop
				DiscordClient.changePresence("Back to the Main Menu.",  null);
				#end

				FlxTween.tween(FlxG.camera, { zoom: 2}, 0.4, { ease: FlxEase.expoIn});
				FlxTween.tween(bg, { y: 0-bg.height}, 0.4, { ease: FlxEase.expoIn });
				FlxTween.tween(side, { alpha:0}, 0.4, { ease: FlxEase.quartInOut});
				FlxTween.tween(checker, { alpha:0}, 0.4, { ease: FlxEase.quartInOut});

				selectedSomethin = true;
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);

				#if desktop
				DiscordClient.changePresence("Selected: "+optionShit[curSelected].toUpperCase(),  null);
				#end

				menuItems.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(FlxG.camera, { zoom: 12}, 0.8, { ease: FlxEase.expoIn, startDelay: 0.4});
					FlxTween.tween(bg, { y: 0-bg.height}, 1.6, { ease: FlxEase.expoIn });
					FlxTween.tween(side, { alpha:0}, 0.6, { ease: FlxEase.quartInOut, startDelay: 0.3});
					FlxTween.tween(checker, { alpha:0}, 0.6, { ease: FlxEase.quartInOut, startDelay: 0.3});

					FlxTween.tween(spr, {y: -48000}, 2.5, {
						ease: FlxEase.expoIn,
						onComplete: function(twn:FlxTween)
						{
							spr.scale.y = 20;
						}
					});
					FlxTween.tween(spr, {'scale.y': 2000}, 1.4, {ease: FlxEase.cubeIn});

					new FlxTimer().start(0.7, function(tmr:FlxTimer)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice)
							{
								case 'week':
									FlxG.switchState(new MenuWeek());
									#if desktop
										DiscordClient.changePresence("Going to select a week.",  null);
									#end
								case 'freeplay':
									FlxG.switchState(new MenuFreeplay());
									#if desktop
										DiscordClient.changePresence("Am bored, so I freeplay.",  null);
									#end
								case 'modifier':
									FlxG.switchState(new MenuModifiers());
									#if desktop
										DiscordClient.changePresence("Time to spice the game.",  null);
									#end
								case 'marathon':
									FlxG.switchState(new MenuMarathon());
									#if desktop
										DiscordClient.changePresence("I wanna make a marathon.",  null);
									#end
								case 'endless':
									FlxG.switchState(new MenuEndless());
									#if desktop
										DiscordClient.changePresence("Endless easy SMM2 moment.",  null);
									#end
							}
						});
				});
			}
		}

		menuItems.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == curSelected)
				{
					camFollow.y = spr.getGraphicMidpoint().y;
					camFollow.x = FlxMath.lerp(camFollow.x, spr.getGraphicMidpoint().x + 43, camLerp/(_variables.fps/60));
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
			DiscordClient.changePresence("Play Selection: "+optionShit[curSelected].toUpperCase(),  null);
		#end
	}
}

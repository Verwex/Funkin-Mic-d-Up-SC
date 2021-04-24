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

typedef ModifierData = {
	var name:String;
	var value:Bool;
	var conflicts: Array<Int>;
	var multi: Float;
	var realmulti: Float;
	var equation:String;
	var abs:Bool;
	var revAtLow:Bool;
	var type:String;
	var minValue: Float;
	var maxValue: Float;
	var curValue: Float;
	var offAt: Float;
	var addChange: Float;
	var string:String;
	var explanation:String;
}

class MenuModifiers extends MusicBeatState
{
    var bg:FlxSprite = new FlxSprite(-89).loadGraphic(Paths.image('modiBG_Main'));
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Modi_Checker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);
	var side:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('Modi_Bottom'));
	var arrs:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('Modi_Arrows'));
	var name:FlxText = new FlxText(20, 69, FlxG.width, "", 48);
	var multi:FlxText = new FlxText(20, 69, FlxG.width, "", 48);
	var explain:FlxText = new FlxText(20, 69, 1200, "", 48);
	var niceText:FlxText = new FlxText(20, 69, FlxG.width, "", 48);

	public static var modifierList:Array<ModifierData>;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var menuChecks:FlxTypedGroup<FlxSprite>;

	var items:Array<FlxSprite> = [];
	var checkmarks:Array<FlxSprite> = [];

	var camFollow:FlxObject;
	public static var curSelected:Int = 0;

	public static var substated:Bool = false;

	var camLerp:Float = 0.1;

	public static var realMP:Float = 1;
	public static var fakeMP:Float = 1;

    override function create()
    {
		substated = false;

        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		menuItems = new FlxTypedGroup<FlxSprite>();
		menuChecks = new FlxTypedGroup<FlxSprite>();

		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.03;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x5585BDFF, 0xAAECE2FF], 1, 90, true); 
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		add(checker);
		checker.scrollFactor.set(0.07, 0.07);

		add(menuItems);
		add(menuChecks);

		refreshModifiers();

		arrs.scrollFactor.x = 0;
		arrs.scrollFactor.y = 0;
		arrs.antialiasing = true;
		arrs.screenCenter();
		add(arrs);

		side.scrollFactor.x = 0;
		side.scrollFactor.y = 0;
		side.antialiasing = true;
		side.screenCenter();
		add(side);
		side.y = FlxG.height - side.height;

		camFollow = new FlxObject(-1420, 360, 1, 1);
		add(camFollow);

		calculateStart();

		add(name);
        name.scrollFactor.x = 0;
        name.scrollFactor.y = 0;
        name.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, LEFT);
        name.x = 20;
        name.y = 600;
        name.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);

		add(multi);
        multi.scrollFactor.x = 0;
        multi.scrollFactor.y = 0;
        multi.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, RIGHT);
        multi.x = 20;
        multi.y = 618;
        multi.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);

		add(explain);
        explain.scrollFactor.x = 0;
        explain.scrollFactor.y = 0;
        explain.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT);
        explain.x = 20;
        explain.y = 654;
        explain.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);

        super.create();
		changeItem();

		niceText.setFormat("VCR OSD Mono", 52, FlxColor.WHITE, CENTER);
        niceText.x = 350;
        niceText.y = 140;
		niceText.scrollFactor.set();
        niceText.setBorderStyle(OUTLINE, 0xFF000000, 3, 1);
		add(niceText);

		explain.alpha = niceText.alpha = multi.alpha = name.alpha = 0;
		FlxTween.tween(name, {alpha:1}, 0.7, {ease: FlxEase.quartInOut, startDelay: 0.4});
		FlxTween.tween(multi, {alpha:1}, 0.7, {ease: FlxEase.quartInOut, startDelay: 0.4});
		FlxTween.tween(niceText, {alpha:1}, 0.7, {ease: FlxEase.quartInOut, startDelay: 0.4});
		FlxTween.tween(explain, {alpha:1}, 0.7, {ease: FlxEase.quartInOut, startDelay: 0.4});
		side.y = FlxG.height;
		FlxTween.tween(side, {y:FlxG.height-side.height}, 0.6, {ease: FlxEase.quartInOut});

		FlxTween.tween(bg, { alpha:1}, 0.8, { ease: FlxEase.quartInOut});
		FlxG.camera.zoom = 0.6;
		FlxG.camera.alpha = 0;
		FlxTween.tween(FlxG.camera, { zoom:1, alpha:1}, 0.7, { ease: FlxEase.quartInOut});

		new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				selectable = true;
			});

		FlxG.camera.follow(camFollow, null, camLerp);

        #if desktop
			DiscordClient.changePresence("Settings up modifiers", null);
		#end
    }

	var selectable:Bool = false;
	var goingBack:Bool = false;

	//{name: '', value: false, conflicts: [0], multi: 0, realmulti: 0, equation: '', abs: false, revAtLow: false, type: '', minValue: 0, maxValue: 10, curValue: 1, offAt: 0, addChange: 0.5, string: '', explanation: ""}

	function refreshModifiers():Void
	{
			var tex = Paths.getSparrowAtlas('Modifiers');
	
			for (i in 0...modifierList.length)
			{
				var menuItem:FlxSprite = new FlxSprite(300 + (i * 250), 100);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', modifierList[i].name + " Idle", 24, true);
				menuItem.animation.addByPrefix('select', modifierList[i].name + " Select", 24, true);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.antialiasing = true;
				menuItem.scrollFactor.x = 1;
				menuItem.scrollFactor.y = 1;
				menuItem.y = 500;
	
				var coolCheckmark:FlxSprite = new FlxSprite(300, 500).loadGraphic(Paths.image('checkmark'));
				coolCheckmark.visible = modifierList[i].value;
				
				menuItems.add(menuItem);

				items.push(menuItem);
				checkmarks.push(coolCheckmark);
			}
	
			for (i in 0...checkmarks.length)
				{
					var awesomeCheckmark:FlxSprite = new FlxSprite(350+ (i * 250), 500).loadGraphic(Paths.image('checkmark'));
					awesomeCheckmark.ID = i;
					awesomeCheckmark.antialiasing = true;
					awesomeCheckmark.scrollFactor.x = 1;
					awesomeCheckmark.scrollFactor.y = 1;
					awesomeCheckmark.y = 500;
					
					menuChecks.add(awesomeCheckmark);
				}
	}

    override function update(elapsed:Float)
        {
            checker.x -= 0.03/(_variables.fps/60);
		    checker.y -= 0.20/(_variables.fps/60);

			multi.x = FlxG.width - (multi.width + 60);
			multi.text = "MULTIPLIER: "+fakeMP;

			niceText.screenCenter(X);

			if (modifierList[curSelected].type == 'number')
				niceText.visible = true;
			else
				niceText.visible = false;

			niceText.text = modifierList[curSelected].curValue + modifierList[curSelected].string;

			fakeMP = truncateFloat(realMP, 2);

			if (fakeMP < 0.1 && !MenuModifiers.modifierList[0].value) //practice shit be like
				fakeMP = 0.1;


            super.update(elapsed);

			if (selectable && !goingBack && !substated)
			{
				if (controls.LEFT_P)
				{
					changeItem(-1);
					FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
				}
	
				if (controls.RIGHT_P)
				{
					changeItem(1);
					FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
				}

				if (controls.UP_P)
				{
					if (modifierList[curSelected].type == 'number')
						{
							scrollValue(modifierList[curSelected].addChange * -1);
							FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
						}
					else
						toggleSelection();
				}
		
				if (controls.DOWN_P)
				{
					if (modifierList[curSelected].type == 'number')
					{
						scrollValue(modifierList[curSelected].addChange);
						FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
					}
					else
						toggleSelection();
				}

				if (controls.BACK)
				{
					FlxG.switchState(new PlaySelection());	

					FlxTween.tween(FlxG.camera, { zoom:0.6, alpha:-0.6}, 0.8, { ease: FlxEase.quartInOut});
					FlxTween.tween(bg, { alpha:0}, 0.8, { ease: FlxEase.quartInOut});
					FlxTween.tween(checker, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
					FlxTween.tween(gradientBar, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
					FlxTween.tween(side, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});

					#if desktop
					DiscordClient.changePresence("Going Back!", null);
					#end

					FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);

					goingBack = true;
				}

				if (controls.ACCEPT)
				{
					substated = true;

					FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);

					FlxG.state.openSubState(new Substate_Preset());
				}
			}

			menuItems.forEach(function(spr:FlxSprite)
				{

					if (spr.ID == curSelected)
					{
						camFollow.x = FlxMath.lerp(camFollow.x, spr.getGraphicMidpoint().x, camLerp/(_variables.fps/60));
						camFollow.y = FlxMath.lerp(camFollow.y, spr.getGraphicMidpoint().y, camLerp/(_variables.fps/60));
						name.text = modifierList[spr.ID].name.toUpperCase();
						explain.text = modifierList[spr.ID].explanation;
					}

					spr.updateHitbox();

					spr.y = 360 - Math.exp(Math.abs(camFollow.x - 30 - spr.x + spr.width/2)/80);
					if (spr.y > -500)
						spr.y = 360 - Math.exp(Math.abs(camFollow.x - 30 - spr.x + spr.width/2)/80);
					else
						spr.y = -500;

					menuChecks.forEach(function(check:FlxSprite)
						{
							check.visible = checkmarks[check.ID].visible;

							check.y = items[check.ID].y + spr.height - spr.height/8*2;
							check.x = items[check.ID].getGraphicMidpoint().x - check.width/2;
						});
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
		}

		public static function calculateMultiplier() {
			realMP = 1;
			var timesThings:Array<Float> = [];
			var divideThings:Array<Float> = [];

			for (i in modifierList) {
				if (i.value) {
					if (i.equation == 'times')
						timesThings.push(i.realmulti);
					else if (i.equation == 'division')
						divideThings.push(i.realmulti);
					else {
						realMP += i.realmulti;
					}
				}
			}

			for (timesThing in timesThings) {
				realMP *= timesThing;
			}
			for (divideThing in divideThings) {
				realMP /= divideThing;
			}

			ModifierVariables.updateModifiers();
			ModifierVariables.saveCurrent();
		}

	public static function calculateStart() //...well that for event makes it waaaay easier to look at, still a mess tho but eh. Works.
	{
		for (i in modifierList) {
			if (i.type == 'switch')
			{
				if (!i.abs)
					i.realmulti = i.multi;
				else
					i.realmulti = Math.abs(i.multi);
			}
			else if (i.type == 'number')
			{	
				/*
				if (i.curValue >= i.maxValue)
					i.curValue = i.maxValue;
				if (i.curValue < i.minValue)
					i.curValue = i.minValue;
				*/ //Imma let them intentonally be able to make hacked persets, for funsies

				if (i.curValue != i.offAt)
				{
					i.value = true;
				}
				else
				{
					i.value = false;
				}

				if (!i.abs)
				{
					if (!i.revAtLow)
					{
						i.realmulti = i.multi * i.curValue;
					}
					else
					{
						if (i.curValue < i.offAt)
							if (i.curValue != i.offAt && i.curValue == 0)
							{
								i.realmulti = i.multi * -1;
							}
							else
							{
							i.realmulti = i.multi * i.curValue * -1;
							}
						else if (i.curValue > i.offAt)
							if (i.curValue != i.offAt && i.curValue == 0)
							{
								i.realmulti = i.multi - i.multi * i.offAt;
							}
							else
							{
								i.realmulti = i.multi * i.curValue - i.multi * i.offAt;
							}
					}
				}
				else
					i.realmulti = Math.abs(i.multi * i.curValue);
			}
		}

		calculateMultiplier();
	}

	function toggleSelection() {
		FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);

		checkmarks[curSelected].visible = !checkmarks[curSelected].visible;
		modifierList[curSelected].value = checkmarks[curSelected].visible;
		for (conflicting in modifierList[curSelected].conflicts) {
			checkmarks[conflicting].visible = false;
			modifierList[conflicting].value = false;
			modifierList[conflicting].curValue = modifierList[conflicting].offAt;
		}

		if (!modifierList[curSelected].abs)
			modifierList[curSelected].realmulti = modifierList[curSelected].multi;
		else
			modifierList[curSelected].realmulti = Math.abs(modifierList[curSelected].multi);

		calculateMultiplier();
	}

	function scrollValue(change:Float = 0)
		{
			modifierList[curSelected].curValue += change;
			
			if (modifierList[curSelected].curValue >= modifierList[curSelected].maxValue)
				modifierList[curSelected].curValue = modifierList[curSelected].maxValue;
			if (modifierList[curSelected].curValue < modifierList[curSelected].minValue)
				modifierList[curSelected].curValue = modifierList[curSelected].minValue;

			if (modifierList[curSelected].curValue != modifierList[curSelected].offAt)
			{
				modifierList[curSelected].value = true;
				checkmarks[curSelected].visible = true;
			}
			else
			{
				modifierList[curSelected].value = false;
				checkmarks[curSelected].visible = false;
			}

			for (conflicting in modifierList[curSelected].conflicts) {
				checkmarks[conflicting].visible = false;
				modifierList[conflicting].value = false;
				modifierList[conflicting].curValue = modifierList[conflicting].offAt;
			}

			if (!modifierList[curSelected].abs)
				if (!modifierList[curSelected].revAtLow)
				{
					modifierList[curSelected].realmulti = modifierList[curSelected].multi * modifierList[curSelected].curValue;

					trace(modifierList[curSelected].multi +"*"+ modifierList[curSelected].curValue+'='+modifierList[curSelected].realmulti);
				}
				else
				{
					if (modifierList[curSelected].curValue < modifierList[curSelected].offAt)
						if (modifierList[curSelected].curValue != modifierList[curSelected].offAt && modifierList[curSelected].curValue == 0)
						{
							modifierList[curSelected].realmulti = modifierList[curSelected].multi * -1;

							trace(modifierList[curSelected].multi +'*-1='+modifierList[curSelected].realmulti);
						}
						else
						{
							modifierList[curSelected].realmulti = modifierList[curSelected].multi * modifierList[curSelected].curValue * -1;

							trace(modifierList[curSelected].multi +"*"+ modifierList[curSelected].curValue+'*-1='+modifierList[curSelected].realmulti);
						}
					else if (modifierList[curSelected].curValue > modifierList[curSelected].offAt)
						if (modifierList[curSelected].curValue != modifierList[curSelected].offAt && modifierList[curSelected].curValue == 0)
						{
							modifierList[curSelected].realmulti = modifierList[curSelected].multi - modifierList[curSelected].multi * modifierList[curSelected].offAt;

							trace(modifierList[curSelected].multi +"-"+ modifierList[curSelected].multi+'*'+modifierList[curSelected].offAt+'='+modifierList[curSelected].realmulti);
						}
						else
						{
							modifierList[curSelected].realmulti = modifierList[curSelected].multi * modifierList[curSelected].curValue - modifierList[curSelected].multi * modifierList[curSelected].offAt;

							trace(modifierList[curSelected].multi +"*"+ modifierList[curSelected].curValue+'-'+modifierList[curSelected].multi+"*"+ modifierList[curSelected].offAt+'='+modifierList[curSelected].realmulti);
						}

				}
			else
				modifierList[curSelected].realmulti = Math.abs(modifierList[curSelected].multi * modifierList[curSelected].curValue);

			calculateMultiplier();
		}

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}
}
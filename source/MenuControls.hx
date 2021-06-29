package;

import Discord.DiscordClient;
import flixel.util.FlxGradient;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.macros.FlxMacroUtil;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import MainVariables._variables;

class MenuControls extends MusicBeatState
{
	var selector:FlxText;

	public static var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];
	var shitass:Array<String> = [
		"UP", "DOWN", "LEFT", "RIGHT", "CENTER", "UP (ALTERNATE)", "DOWN (ALTERNATE)", "LEFT (ALTERNATE)", "RIGHT (ALTERNATE)", "CENTER (ALTERNATE)", "ACCEPT", "RESET", "BACK", "CHEAT",
		"ACCEPT (ALTERNATE)", "RESET (ALTERNATE)", "BACK (ALTERNATE)", "CHEAT (ALTERNATE)"
	];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var changingInput:Bool = false;

	var bg:FlxSprite = new FlxSprite(-89).loadGraphic(Paths.image('cBG_Main'));
	var side:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('Cont_side'));
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Cont_Checker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);

	var selectable:Bool = false;

	override function create()
	{
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		bg.alpha = 0;

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55FFBDF8, 0xAAFFFDF3], 1, 90, true);
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		add(checker);
		checker.scrollFactor.set(0, 0.07);

		add(side);
		side.alpha = 0;

		FlxTween.tween(bg, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(side, {alpha: 1}, 0.5, {ease: FlxEase.quartInOut});

		FlxG.camera.zoom = 0.6;
		FlxG.camera.alpha = 0;
		FlxTween.tween(FlxG.camera, {zoom: 1, alpha: 1}, 0.5, {ease: FlxEase.quartInOut});

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				selectable = true;
			});
		
		//off to the main sauce

		controlsStrings = CoolUtil.coolTextFile(Paths.txt('defaultControls'));

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);
		var i = 0;

		var elements:Array<String> = controlsStrings[i].split(',');

		for (i in 0...shitass.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, '+' + shitass[i] + ': ' + Controls.keyboardMap.get(shitass[i]), true, false);
			controlLabel.itemType = "Classic";
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
		}

		// /* dont delete this; this handles the sorting for the menu
		// 	** deleting this will give the menu a random selection every time
		// 	** so dont
		//  */
		// // ok ok ok -Verwex
		// grpControls.sort(FlxSort.byY, FlxSort.DESCENDING);
		changeSelection();

		// for (i in 0...controlsStrings.length)
		// {
		//
		//	var elements:Array<String> = controlsStrings[i].split(',');
		//	var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30,'set ' + elements[0] + ': ' + elements[1], true, false);
		//	controlLabel.isMenuItem = true;
		//	controlLabel.targetY = i;
		//	grpControls.add(controlLabel);
		//
		//	// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		// }

		super.create();

		// openSubState(new OptionsSubState());
	}

	override function update(elapsed:Float)
	{
		checker.x += 0.12;
		checker.y -= Math.sin(elapsed/100)*400;

		super.update(elapsed);

		if (!changingInput && selectable)
		{
			if (controls.BACK)
			{
				FlxG.switchState(new SettingsState());
				Controls.saveControls();
				controls.setKeyboardScheme(Solo, true);
				selectable = false;

				FlxTween.tween(FlxG.camera, {zoom: 0.6, alpha: -0.6}, 0.7, {ease: FlxEase.quartInOut});
				FlxTween.tween(bg, {alpha: 0}, 0.7, {ease: FlxEase.quartInOut});
				FlxTween.tween(checker, {alpha: 0}, 0.3, {ease: FlxEase.quartInOut});
				FlxTween.tween(gradientBar, {alpha: 0}, 0.3, {ease: FlxEase.quartInOut});
				FlxTween.tween(side, {alpha: 0}, 0.3, {ease: FlxEase.quartInOut});

				DiscordClient.changePresence("Going back!", null);

				for (item in grpControls.members)
					{
						FlxTween.tween(item, { x: 1500}, 0.5, { ease: FlxEase.expoIn});
					}

				FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume / 100);
			}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			if (controls.ACCEPT)
			{
				if (!changingInput)
					FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume / 100);
				
				ChangeInput();
			}
		}
		else
		{
			ChangingInput();
		}
	}

	function changeSelection(change:Int = 0)
	{
		// #if !switch
		// NGio.logEvent('Fresh');
		// #end

		FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
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

	function ChangeInput()
	{
		changingInput = true;
		FlxFlicker.flicker(grpControls.members[curSelected], 0);
	}

	function ChangingInput()
	{
		if (FlxG.keys.pressed.ANY)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume / 100);

			// Checks all known keys
			var keyMaps:Map<String, FlxKey> = FlxMacroUtil.buildMap("flixel.input.keyboard.FlxKey");
			for (key in keyMaps.keys())
			{
				if (FlxG.keys.checkStatus(key, 2) && key != "ANY")
				{
					FlxFlicker.stopFlickering(grpControls.members[curSelected]);

					var elements:Array<String> = grpControls.members[curSelected].text.split(':');
					var name:String = StringTools.replace(elements[0], '+', '');
					var controlLabel:Alphabet = new Alphabet(0, 0, '+' + name + ': ' + key, true, false);
					controlLabel.itemType = "Classic";
					controlLabel.targetY = 0;

					grpControls.replace(grpControls.members[curSelected], controlLabel);
					changingInput = false;

					Controls.keyboardMap.set(name, keyMaps[key]);
					FlxG.log.add(name + " is bound to " + keyMaps[key]);

					break;
				}
			}
		}
	}
}

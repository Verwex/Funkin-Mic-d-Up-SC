package;

import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
	*DEBUG MODE
 */
class AnimationDebug extends MusicBeatState
{
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;

	var controlsD:FlxSprite = new FlxSprite(0,-5).loadGraphic(Paths.image('Debug_Controls'));

	private var camBG:FlxCamera;
	private var camHUD:FlxCamera;

	var UI_box:FlxUITabMenu;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		camBG = new FlxCamera();
		camHUD = new FlxCamera();

		FlxG.cameras.reset(camBG);

		camHUD.bgColor.alpha = 0;
        FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camBG];

		FlxG.sound.music.stop();

		controlsD.x = FlxG.width - controlsD.width;
		add(controlsD);

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		generateCharacter();

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(600, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		textAnim.setBorderStyle(OUTLINE, 0xFF000000, 3, 1);
		add(textAnim);
	
		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);
		FlxG.mouse.visible = true;

		var tabs = [
			{name: "Character", label: 'Character'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(340, 60);
		UI_box.x = FlxG.width / 2 - 38;
		UI_box.y = 70;
		add(UI_box);

		var tab_group_character = new FlxUI(null, UI_box);
		var check_isPlayer = new FlxUICheckBox(200, 10, null, null, "Is Player", 100);
		tab_group_character.name = "Character";

		var characters:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));

		var player1DropDown = new FlxUIDropDownMenu(10, 10, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
			{
				daAnim = characters[Std.parseInt(character)];
				remove(dad);
				remove(bf);

				animList = [];
				generateCharacter();
				if (isDad)
					dad.flipX = check_isPlayer.checked;
				else
					bf.flipX = !check_isPlayer.checked;

				dumbTexts.clear();
				updateTexts();
				genBoyOffsets();

				char.playAnim(animList[0]);

				updateTexts();
				genBoyOffsets(false);
			});
			player1DropDown.selectedLabel = daAnim;
	
		check_isPlayer.checked = false;
		check_isPlayer.callback = function()
			{
				if (isDad)
					dad.flipX = check_isPlayer.checked;
				else
					bf.flipX = !check_isPlayer.checked;
			};

		tab_group_character.add(player1DropDown);
		tab_group_character.add(check_isPlayer);

		UI_box.addGroup(tab_group_character);

		UI_box.cameras = controlsD.cameras = dumbTexts.cameras = textAnim.cameras = [camHUD];

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(300, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = 0xFF30DFFF;
			text.setBorderStyle(OUTLINE, 0xFF000000, 2, 1);
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	var multiplier = 1;

	override function update(elapsed:Float)
	{
		textAnim.text = "CURRENT: "+char.animation.curAnim.name;

		if (FlxG.keys.pressed.E)
			FlxG.camera.zoom += 0.02*multiplier;
		if (FlxG.keys.pressed.Q)
			FlxG.camera.zoom -= 0.02*multiplier;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.y += -5*multiplier;
			else if (FlxG.keys.pressed.K)
				camFollow.y += 5*multiplier;

			if (FlxG.keys.pressed.J)
				camFollow.x += -5*multiplier;
			else if (FlxG.keys.pressed.L)
				camFollow.x += 5*multiplier;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		if (holdShift)
			multiplier = 10;
		else
			multiplier = 1;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.switchState(new SettingsState());
				FlxG.mouse.visible = false;
			}

		super.update(elapsed);
	}

	function generateCharacter()
	{
		if (daAnim == 'bf')
			isDad = false;
		else
			isDad = true;

		if (isDad)
		{
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;
			add(dad);

			char = dad;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;
			bf.flipX = true;
		}
	}
}

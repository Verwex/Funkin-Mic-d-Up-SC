package;

import lime.system.System;
import openfl.Lib;
import lime.app.Application;
import flixel.addons.ui.FlxUIInputText;
import flixel.input.keyboard.FlxKey;
import sys.FileSystem;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.util.FlxGradient;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.addons.display.FlxBackdrop;
import MainVariables._variables;
import ModifierVariables._modifiers;

using StringTools;

class Substate_PresetSave extends MusicBeatSubstate
{
    public static var curSelected:Int = 0;

    var goingBack:Bool = false;

    var camLerp:Float = 0.16;

    var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);

    var chooseName:FlxText;

    var name:FlxUIInputText;
    public static var nameResult:String = "";
    public static var coming:String = "";

    public function new()
    {
        super();

		add(blackBarThingie);
        blackBarThingie.scrollFactor.set();
        blackBarThingie.scale.y = 750;

        chooseName = new FlxText(FlxG.width * 0.7, 5, 0, "Type in your preset name. Once you're done, press enter\nto proceed, or escape to leave.", 32);
		chooseName.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		chooseName.alignment = CENTER;
		chooseName.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		chooseName.screenCenter(X);
		chooseName.y = 38;
        chooseName.scrollFactor.set();
		add(chooseName);

        name = new FlxUIInputText(10, 10, FlxG.width, '', 8);
		name.setFormat(Paths.font("vcr.ttf"), 96, FlxColor.WHITE, RIGHT);
		name.alignment = CENTER;
		name.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		name.screenCenter();
        name.scrollFactor.set();
		add(name);
        name.backgroundColor = 0xFF000000;
        name.maxLength = 15;
        name.lines = 1;
        name.caretColor = 0xFFFFFFFF;

        new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				selectable = true;
			});
    }

    var selectable:Bool = false;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        name.hasFocus = true;

        switch (name.text.toLowerCase())
        {
            case 'gaster':
                System.exit(0);
            case 'error':
                FlxG.game.stage.window.alert('Got you!', 'Boo!');
        }
        
        blackBarThingie.y = 360 - blackBarThingie.height/2;
        blackBarThingie.x = 640 - blackBarThingie.width/2;

        if (selectable && !goingBack)
        {
            if (FlxG.keys.justPressed.ESCAPE)
                {
                    goingBack = true;
                    FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);
                    FlxTween.tween(blackBarThingie, { 'scale.x': 0}, 0.5, { ease: FlxEase.expoIn});
                    FlxTween.tween(name, { 'scale.x': 0}, 0.5, { ease: FlxEase.expoIn});
                    FlxTween.tween(chooseName, { 'scale.x': 0}, 0.5, { ease: FlxEase.expoIn});
                    new FlxTimer().start(0.5, function(tmr:FlxTimer)
                        {
                            FlxG.state.closeSubState();
                            if (coming == "Modifiers")
                                FlxG.state.openSubState(new Substate_Preset());
                            else if (coming == "Marathon")
                                FlxG.state.openSubState(new Marathon_Substate());
                        });
                }
        
            if (FlxG.keys.justPressed.ENTER && name.text != '')
            {
                nameResult = name.text;
                FlxG.state.closeSubState();
                FlxG.state.openSubState(new Substate_PresetSaveOK());
            }
        }
    }
}
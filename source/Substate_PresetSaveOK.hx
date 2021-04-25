package;

import sys.io.File;
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

class Substate_PresetSaveOK extends MusicBeatSubstate
{
    public static var curSelected:Int = 0;

    var goingBack:Bool = false;

    var camLerp:Float = 0.16;

    var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);

    var resultText:FlxText;

    var resultName:FlxText;
    var eggText:String = "";

    var eggImage:FlxSprite;

    public function new()
    {
        super();

		add(blackBarThingie);
        blackBarThingie.scrollFactor.set();
        blackBarThingie.scale.y = 750;

        resultText = new FlxText(FlxG.width * 0.7, 5, 1000, "Is this okay?", 32);
		resultText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		resultText.alignment = CENTER;
		resultText.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		resultText.screenCenter(X);
		resultText.y = 38;
        resultText.scrollFactor.set();
		add(resultText);

        resultName = new FlxText(FlxG.width * 0.7, 5, 1280, Substate_PresetSave.nameResult, 96);
		resultName.setFormat(Paths.font("vcr.ttf"), 96, FlxColor.WHITE, RIGHT);
		resultName.alignment = CENTER;
		resultName.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		resultName.screenCenter();
        resultName.y += 35;
        resultName.scrollFactor.set();
		add(resultName);

        eggText = resultName.text.toLowerCase();

        if (eggText.contains('<') || eggText.contains('>') || eggText.contains('*') || eggText.contains('?')
            || eggText.contains('/') || eggText.contains(':') || eggText.contains('"'))
        {
            #if desktop
            canOK = false;
            resultText.text = "Please refrain from using *, ?, |, slashes, arrow parenthesis, : and double quotes as you can't name filenames like that.";
            #end  
        }

        switch (eggText)
        {
            case 'con'|'prn'|'aux'|'nul'|'com1'|'com2'|'com3'|'com4'|'com5'|'com6'|'com7'|'com8'|'com9'|'lpt1'|'lpt2'|'lpt3'|'lpt4'|'lpt5'|'lpt6'|'lpt7'|'lpt8'|'lpt9': //what a backdoor
                #if desktop
                canOK = false;
                resultText.text = "It is illegal to make a filename like that based on a device's name. Try thinking of something else.";
                #end
            case 'current':
                canOK = false;
                resultText.text = "Don't replace what saves on your way. It'll autosave itself.";
            default:
        }

        if (FileSystem.exists(Paths.txt('easterEgg_Data/$eggText')))
        {
            resultText.text = File.getContent(Paths.txt('easterEgg_Data/$eggText'));
        }
        if (FileSystem.exists(Paths.music('easterEgg_Music/$eggText')))
        {
            FlxG.sound.playMusic(Paths.music('easterEgg_Music/$eggText'),_variables.mvolume/100);
        }
        if (FileSystem.exists(Paths.sound('easterEgg_Sounds/$eggText')))
        {
            FlxG.sound.play(Paths.sound('easterEgg_Sounds/$eggText'),_variables.svolume/100);
        }
        if (FileSystem.exists(Paths.image('easterEgg_Images/$eggText')))
        {
            eggImage = new FlxSprite(0,0).loadGraphic(Paths.image('easterEgg_Images/$eggText'));
            eggImage.antialiasing = true;

            if (eggImage.width <= 256)
                eggImage.antialiasing = false;

            eggImage.setGraphicSize(400);
            eggImage.updateHitbox();

            if (eggImage.height > 400)
            {
                eggImage.setGraphicSize(0,400);
                eggImage.updateHitbox();
            }
            
            eggImage.screenCenter();
            eggImage.x = -40 - eggImage.width;
            add(eggImage);

            easterImage = true;
        }

        new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				selectable = true;
			});
    }

    var selectable:Bool = false;
    var canOK:Bool = true;
    var easterImage:Bool = false;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (easterImage)
        {
            resultName.size = Std.int(FlxMath.lerp(resultName.size, 40, camLerp/(_variables.fps/60)));
            resultName.y = FlxMath.lerp(resultName.y, 350, camLerp/(_variables.fps/60));
            resultName.x = FlxMath.lerp(resultName.x, 300, camLerp/(_variables.fps/60));

            eggImage.x = FlxMath.lerp(eggImage.x, 270-eggImage.width, camLerp/(_variables.fps/60));
            eggImage.y = 260;
        }
        else
        {
            resultName.size = Std.int(FlxMath.lerp(resultName.size, 150, camLerp/(_variables.fps/60)));
            resultName.y = FlxMath.lerp(resultName.y, 280, camLerp/(_variables.fps/60));
        }

        blackBarThingie.y = 360 - blackBarThingie.height/2;
        blackBarThingie.x = 640 - blackBarThingie.width/2;

        if (selectable && !goingBack)
        {
            if (controls.BACK)
            {
                FlxG.state.closeSubState();
                FlxG.state.openSubState(new Substate_PresetSave());
            }
        
            if (controls.ACCEPT && canOK)
            {
                ModifierVariables.savePreset(eggText);

                goingBack = true;
                        
                FlxTween.tween(blackBarThingie, { 'scale.x': 0}, 0.5, { ease: FlxEase.expoIn});
                FlxTween.tween(resultText, { 'scale.x': 0}, 0.5, { ease: FlxEase.expoIn});
                FlxTween.tween(resultName, { 'scale.x': 0}, 0.5, { ease: FlxEase.expoIn});
                if (easterImage)
                    FlxTween.tween(eggImage, { 'scale.x': 0}, 0.5, { ease: FlxEase.expoIn});

                FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);
                new FlxTimer().start(0.5, function(tmr:FlxTimer)
                {
                    FlxG.state.closeSubState();
                    FlxG.state.openSubState(new Substate_Preset());
                });
            }
        }
    }
}
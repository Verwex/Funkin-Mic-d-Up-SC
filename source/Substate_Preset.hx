package;

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

class Substate_Preset extends MusicBeatSubstate
{
    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String>;
    public static var curSelected:Int = 0;

    var goingBack:Bool = false;

    var camLerp:Float = 0.16;

    public static var presets:Array<String>;

    var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);

    public function new()
    {
        super();

		add(blackBarThingie);
        blackBarThingie.scrollFactor.set();
        blackBarThingie.scale.y = 0;
        FlxTween.tween(blackBarThingie, { 'scale.y': 230}, 0.5, { ease: FlxEase.expoOut});

        presets = FileSystem.readDirectory('presets/modifiers');
        presets.remove('current');

        trace(presets);

        if (presets.length > 0)
            optionShit = ['clear', 'save', 'load'];
        else
            optionShit = ['clear', 'save', 'no']; //get some presets first and then we can talk

        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);
        
		var tex = Paths.getSparrowAtlas('Modi_Buttons');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 0);
			menuItem.frames = tex;
            menuItem.animation.addByPrefix('standard', optionShit[i], 24, true);
			menuItem.animation.play('standard');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
            menuItem.antialiasing = true;
            menuItem.scrollFactor.x = 0;
            menuItem.scrollFactor.y = 0;

            menuItem.y = FlxG.height/2 - menuItem.height/2;
            menuItem.x = 80 +  i * 300;
            menuItem.scale.set(0,0);
        }

        new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				selectable = true;
			});
    }

    var selectable:Bool = false;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        blackBarThingie.y = 360 - blackBarThingie.height/2;

        if (selectable && !goingBack)
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
                    goingBack = true;
                    FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);
                    FlxTween.tween(blackBarThingie, { 'scale.y': 0}, 0.5, { ease: FlxEase.expoIn});
                    new FlxTimer().start(0.6, function(tmr:FlxTimer)
                        {
                            FlxG.state.closeSubState();
                            MenuModifiers.substated = false;
                        });
                }
        
            if (controls.ACCEPT)
            {
                switch (optionShit[curSelected])
                {
                    case 'clear':
                        ModifierVariables.nullify();
                        MenuModifiers.calculateStart();

                        goingBack = true;

                        FlxTween.tween(blackBarThingie, { 'scale.y': 1500}, 0.5, { ease: FlxEase.expoIn});
                        FlxTween.tween(FlxG.camera, { y: 750}, 0.5, { ease: FlxEase.expoIn});

                        FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);
                        new FlxTimer().start(0.6, function(tmr:FlxTimer)
                        {
                            FlxG.resetState();
                            MenuModifiers.substated = false;
                        });
                    case 'save':
                        goingBack = true;
                        Substate_PresetSave.coming = "Modifiers";
                            
                        FlxTween.tween(blackBarThingie, { 'scale.y': 1500}, 0.5, { ease: FlxEase.expoIn});
    
                        FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);
                        new FlxTimer().start(0.6, function(tmr:FlxTimer)
                        {
                            FlxG.state.openSubState(new Substate_PresetSave());
                            FlxG.state.closeSubState();
                        });
                    case 'load':
                        goingBack = true;
                        Substate_PresetLoad.coming = "Modifiers";
                                
                        FlxTween.tween(blackBarThingie, { 'scale.y': 1500, 'scale.x': 0}, 0.5, { ease: FlxEase.expoIn});
        
                        FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);
                        new FlxTimer().start(0.6, function(tmr:FlxTimer)
                        {
                            FlxG.state.openSubState(new Substate_PresetLoad());
                            FlxG.state.closeSubState();
                        });
                }
            }
        }

        menuItems.forEach(function(spr:FlxSprite)
            {
                if (!goingBack)
                {
                    spr.x = 250 + spr.ID * 400 - spr.width/2;
                    spr.scale.set(FlxMath.lerp(spr.scale.x, 1, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 1, 0.4/(_variables.fps/60)));
    
                    if (spr.ID == curSelected)
                        spr.scale.set(FlxMath.lerp(spr.scale.x, 1.5, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 1.5, 0.4/(_variables.fps/60)));
                }
                else
                    spr.scale.set(FlxMath.lerp(spr.scale.x, 0, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 0, 0.4/(_variables.fps/60)));
            });
    }

    function changeItem(huh:Int = 0)
        {
            curSelected += huh;
        
            if (curSelected >= menuItems.length)
                curSelected = 0;
            if (curSelected < 0)
                curSelected = menuItems.length - 1;
        }
}
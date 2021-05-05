package;

import haxe.Json;
import sys.io.File;
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

typedef EndlessVars = {
    var speed:Float;
    var ramp:Bool;
}

class Endless_Substate extends MusicBeatSubstate
{
    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String> = ['difficulty', 'speed', 'ramp', 'play'];

    var sprDifficulty:FlxSprite;
    var textSpeed:FlxText;
    var textRamp:FlxText;

    public static var curSelected:Int = 0;
    public static var curDifficulty:Int = 2;

    public static var _endless:EndlessVars;

    var goingBack:Bool = false;

    var camLerp:Float = 0.16;
    var initSpeed:Float = 0.16;

    var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);

    public static var song:String = "";

    public function new()
    {
        super();

        _endless = {
            speed: 0,
            ramp: true
        }

		add(blackBarThingie);
        blackBarThingie.scrollFactor.set();
        blackBarThingie.scale.y = 0;
        FlxTween.tween(blackBarThingie, { 'scale.y': 500}, 0.5, { ease: FlxEase.expoOut});

        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);
        
		var tex = Paths.getSparrowAtlas('Endless_Buttons');

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
    
                menuItem.y = 40 +  i * 90;
                menuItem.x = 40;
                menuItem.scale.set(0,0);
            }

        var diffTex = Paths.getSparrowAtlas('difficulties');
        sprDifficulty = new FlxSprite(130, 0);
        sprDifficulty.frames = diffTex;
        sprDifficulty.animation.addByPrefix('noob', 'NOOB');
        sprDifficulty.animation.addByPrefix('easy', 'EASY');
        sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
        sprDifficulty.animation.addByPrefix('hard', 'HARD');
        sprDifficulty.animation.addByPrefix('expert', 'EXPERT');
        sprDifficulty.animation.addByPrefix('insane', 'INSANE');
        sprDifficulty.animation.play('easy');
        sprDifficulty.x = 900;
        sprDifficulty.y = 151;
        add(sprDifficulty);

        textSpeed = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		textSpeed.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		textSpeed.alignment = CENTER;
		textSpeed.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		textSpeed.x = 910;
		textSpeed.y = sprDifficulty.y+120+12;
        textSpeed.alpha = 0;
		add(textSpeed);

        textRamp = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		textRamp.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		textRamp.alignment = CENTER;
		textRamp.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		textRamp.x = 910;
		textRamp.y = textSpeed.y+120;
        textRamp.alpha = 0;
		add(textRamp);

        FlxTween.tween(textSpeed, { alpha:1}, 0.5, { ease: FlxEase.quartInOut});
        FlxTween.tween(textRamp, { alpha:1}, 0.5, { ease: FlxEase.quartInOut});

        changeItem();
        changeDiff();

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
        textSpeed.text = Std.string(_endless.speed)+" ("+PlayState.SONG.speed+")";
        textRamp.text = Std.string(_endless.ramp).toUpperCase();

        if (selectable && !goingBack)
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
        
            if (controls.LEFT_P)
                switch (optionShit[curSelected])
                {
                    case 'difficulty':
                        changeDiff(-1);
                    case 'speed':
                        if (_endless.speed > 0.1)
                            _endless.speed -= 0.1;
                        _endless.speed = FlxMath.roundDecimal(_endless.speed, 1);
                        saveCurrent(song, curDifficulty);
                    case 'ramp':
                        _endless.ramp = !_endless.ramp;
                        saveCurrent(song, curDifficulty);
                }
            if (controls.RIGHT_P)
                switch (optionShit[curSelected])
                {
                    case 'difficulty':
                        changeDiff(1);
                    case 'speed':
                        if (_endless.speed < 8)
                            _endless.speed += 0.1;
                        _endless.speed = FlxMath.roundDecimal(_endless.speed, 1);
                        saveCurrent(song, curDifficulty);
                    case 'ramp':
                        _endless.ramp = !_endless.ramp;
                        saveCurrent(song, curDifficulty);
                }

            if (controls.BACK)
                {
                    goingBack = true;
                    FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);
                    FlxTween.tween(blackBarThingie, { 'scale.y': 0}, 0.5, { ease: FlxEase.expoIn});
                    FlxTween.tween(sprDifficulty, { 'scale.y': 0}, 0.5, { ease: FlxEase.expoIn});
                    FlxTween.tween(textSpeed, { alpha: 0}, 0.5, { ease: FlxEase.expoIn});
                    FlxTween.tween(textRamp, { alpha: 0}, 0.5, { ease: FlxEase.expoIn});
                    new FlxTimer().start(0.6, function(tmr:FlxTimer)
                        {
                            FlxG.state.closeSubState();
                            MenuEndless.substated = false;
                        });
                }
        
            if (controls.ACCEPT)
            {
                #if desktop
					DiscordClient.changePresence("Selecting chart types.", null);
				#end

                PlayState.gameplayArea = "Endless";
                PlayState.storyDifficulty = curDifficulty;

                goingBack = true;
                FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);
                FlxTween.tween(blackBarThingie, { 'scale.y': 780}, 0.5, { ease: FlxEase.expoIn});
                FlxTween.tween(sprDifficulty, { 'scale.y': 0}, 0.5, { ease: FlxEase.expoIn});
                FlxTween.tween(textSpeed, { alpha: 0}, 0.5, { ease: FlxEase.expoIn});
                FlxTween.tween(textRamp, { alpha: 0}, 0.5, { ease: FlxEase.expoIn});
                new FlxTimer().start(0.6, function(tmr:FlxTimer)
                    {
                        MenuEndless.no = true;
                        FlxG.state.closeSubState();
                        FlxG.state.openSubState(new Substate_ChartType());
                    });
            }
        }

        menuItems.forEach(function(spr:FlxSprite)
            {
                if (!goingBack)
                {
                    spr.x = FlxMath.lerp(spr.x, 20, camLerp/(_variables.fps/60));
                    spr.y = 110 +  spr.ID * 120;
                    spr.scale.set(FlxMath.lerp(spr.scale.x, 0.5, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 0.5, 0.4/(_variables.fps/60)));
    
                    if (spr.ID == curSelected)
                    {
                        spr.scale.set(FlxMath.lerp(spr.scale.x, 1.3, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 1.3, 0.4/(_variables.fps/60)));
                        spr.x = FlxMath.lerp(spr.x, 250, camLerp/(_variables.fps/60));
                    }
                }
                else
                {
                    spr.scale.set(FlxMath.lerp(spr.scale.x, 0, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 0, 0.4/(_variables.fps/60)));
                    spr.x = FlxMath.lerp(spr.x, 1500, camLerp/(_variables.fps/60));
                }
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

    function changeDiff(change:Int = 0)
        {
            curDifficulty += change;
        
            if (curDifficulty < 0)
                curDifficulty = 5;
            if (curDifficulty > 5)
                curDifficulty = 0;
        
            switch (curDifficulty)
                {
                    case 0:
                        sprDifficulty.animation.play('noob');
                    case 1:
                        sprDifficulty.animation.play('easy');
                    case 2:
                        sprDifficulty.animation.play('normal');
                    case 3:
                        sprDifficulty.animation.play('hard');
                    case 4:
                        sprDifficulty.animation.play('expert');
                    case 5:
                        sprDifficulty.animation.play('insane');
                }
        
            sprDifficulty.alpha = 0;
        
            sprDifficulty.y = 101;
            FlxTween.tween(sprDifficulty, {y: 151, alpha: 1}, 0.04);

            updateSong();
            loadCurrent(song, curDifficulty);
        }
    
    function updateSong()
    {
        var diffic:String = "";

        switch (curDifficulty)
		{
			case 0:
				diffic = '-noob';
			case 1:
				diffic = '-easy';
			case 3:
				diffic = '-hard';
		    case 4:
				diffic = '-expert';
		    case 5:
			    diffic = '-insane';
		}
        
        PlayState.SONG = Song.loadFromJson(song+diffic, song);
        _endless.speed = PlayState.SONG.speed;

        trace(_endless.speed);
    }

    public static function loadCurrent(songTitle:String, difficulty:Int)
    {
        if (!FileSystem.isDirectory('presets/endless'))
            FileSystem.createDirectory('presets/endless');

        if (!FileSystem.exists('presets/endless/'+songTitle+'_'+difficulty))
            {
                File.saveContent(('presets/endless/'+songTitle+'_'+difficulty), Json.stringify(_endless));
            }
        else
            {
                var data:String = File.getContent('presets/endless/'+songTitle+'_'+difficulty);
                _endless = Json.parse(data);
            }
    }

    public static function saveCurrent(songTitle:String, difficulty:Int)
        {
            File.saveContent(('presets/endless/'+songTitle+'_'+difficulty), Json.stringify(_endless));
        }
}
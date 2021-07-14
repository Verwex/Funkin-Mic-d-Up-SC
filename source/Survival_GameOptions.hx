package;

import cpp.abi.Abi;
import haxe.Json;
import sys.io.File;
import sys.FileSystem;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Discord.DiscordClient;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import MainVariables._variables;

using StringTools;

typedef SurvivalGameOptions = {
    var timePercentage:Int;
    var carryTime:Bool;
    var addTimeMultiplier:Float;
    var subtractTimeMultiplier:Float;
    var addSongTimeToCurrentTime:Bool;
}

class Survival_GameOptions extends MusicBeatSubstate
{
    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String> = ['time', 'carry', 'add', 'subtract', 'addTime'];

    public static var curSelected:Int = 0;

    public static var _survivalVars:SurvivalGameOptions;

    var goingBack:Bool = false;

    var camLerp:Float = 0.16;
    var initSpeed:Float = 0.16;

    var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 1, FlxColor.BLACK);

    var ExplainText:FlxText = new FlxText(20, 69, FlxG.width / 3 * 2, "", 48);
    var ResultText:FlxText = new FlxText(20, 69, FlxG.width, "", 48);
    var navi:FlxSprite;

    public function new()
    {
        super();

        load();

		add(blackBarThingie);
        blackBarThingie.scrollFactor.set();
        blackBarThingie.scale.y = 0;
        FlxTween.tween(blackBarThingie, { 'scale.y': 500}, 0.5, { ease: FlxEase.expoOut});

        var nTex = Paths.getSparrowAtlas('Options_Navigation');
		navi = new FlxSprite();
		navi.frames = nTex;
		navi.animation.addByPrefix('arrow', "navigation_arrows", 24, true);
		navi.animation.addByPrefix('shiftArrow', "navigation_shiftArrow", 24, true);
		navi.animation.play('arrow');
		navi.scrollFactor.set();
        navi.alpha = 0;
		add(navi);
        FlxTween.tween(navi, {alpha: 1}, 0.15, {ease: FlxEase.expoInOut});

        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);
        
		var tex = Paths.getSparrowAtlas('Survival_OptionButtons');

        for (i in 0...optionShit.length)
            {
                var menuItem:FlxSprite = new FlxSprite(0, 0);
                menuItem.frames = tex;
                menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24, true);
                menuItem.animation.addByPrefix('select', optionShit[i] + " select", 24, true);
                menuItem.animation.play('idle');
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

        changeItem();

        createResults();

        new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				selectable = true;
			});
    }

    function createResults():Void
        {
            add(ResultText);
            ResultText.scrollFactor.x = 0;
            ResultText.scrollFactor.y = 0;
            ResultText.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER);
            ResultText.x = 100;
            ResultText.screenCenter(Y);
            ResultText.alpha = 0;
            FlxTween.tween(ResultText, {alpha: 1}, 0.15, {ease: FlxEase.expoInOut});
    
            add(ExplainText);
            ExplainText.scrollFactor.x = 0;
            ExplainText.scrollFactor.y = 0;
            ExplainText.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER);
            ExplainText.alignment = LEFT;
            ExplainText.x = 20;
            ExplainText.setBorderStyle(OUTLINE, 0xFF000000, 3, 1);
            ExplainText.alpha = 0;
            FlxTween.tween(ExplainText, {alpha: 1}, 0.15, {ease: FlxEase.expoInOut});
        }

    var selectable:Bool = false;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        blackBarThingie.y = 360 - blackBarThingie.height/2;
        blackBarThingie.updateHitbox();

        navi.y = blackBarThingie.y + 15;
		navi.x = 1260 - navi.width;

        ExplainText.y = blackBarThingie.y + blackBarThingie.height;

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
                changeOption(-1);

            if (controls.RIGHT_P)
                changeOption(1);

            if (controls.LEFT)
                changeHold(-1);

            if (controls.RIGHT)
                changeHold(1);

            if (controls.BACK)
                {
                    goingBack = true;
                    FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);
                    FlxTween.tween(blackBarThingie, { 'scale.y': 0}, 0.5, { ease: FlxEase.expoIn});
                    FlxTween.tween(navi, { alpha: 0}, 0.5, { ease: FlxEase.expoIn});
                    FlxTween.tween(ExplainText, { alpha: 0}, 0.5, { ease: FlxEase.expoIn});
                    FlxTween.tween(ResultText, { 'scale.y': 0}, 0.5, { ease: FlxEase.expoIn});
                    new FlxTimer().start(0.6, function(tmr:FlxTimer)
                        {
                            FlxG.state.closeSubState();
                            FlxG.state.openSubState(new Survival_Substate());
                        });
                }
        }

        switch (optionShit[curSelected])
		{
			case "time":
				ResultText.text = Std.string(_survivalVars.timePercentage) + "%";
				ExplainText.text = "Start a song by giving a portion of its length to the timer.";
			case "carry":
				ResultText.text = Std.string(_survivalVars.carryTime).toUpperCase();
				ExplainText.text = "Carry over time left on one song to another song.";
			case "add":
				ResultText.text = Std.string(_survivalVars.addTimeMultiplier) + "x";
				ExplainText.text = "Mupltiplier of added time from some conditions.";
			case "subtract":
				ResultText.text = Std.string(_survivalVars.subtractTimeMultiplier) + "x";
				ExplainText.text = "Mupltiplier of subtracted time from some conditions.";
			case "addTime":
				ResultText.text = Std.string(_survivalVars.addSongTimeToCurrentTime).toUpperCase();
				ExplainText.text = "Add time from a song to the time limit once it plays. Applies on the second song and onwards.";
		}

        menuItems.forEach(function(spr:FlxSprite)
            {
                if (!goingBack)
                {
                    spr.x = FlxMath.lerp(spr.x, 20, camLerp/(_variables.fps/60));
                    spr.y = 121 +  spr.ID * 90;
                    spr.scale.set(FlxMath.lerp(spr.scale.x, 0.5, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 0.5, 0.4/(_variables.fps/60)));
    
                    if (spr.ID == curSelected)
                    {
                        spr.scale.set(FlxMath.lerp(spr.scale.x, 1, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 1, 0.4/(_variables.fps/60)));
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

    function changeOption(Change:Int)
    {
        switch (optionShit[curSelected])
		{
			case "carry":
				_survivalVars.carryTime = !_survivalVars.carryTime;

				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
            case "addTime":
				_survivalVars.addSongTimeToCurrentTime = !_survivalVars.addSongTimeToCurrentTime;

				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
            case "subtract":
                if (controls.CENTER)
                    Change *= 2;

                _survivalVars.subtractTimeMultiplier += FlxMath.roundDecimal(Change / 10, 2);
                if (_survivalVars.subtractTimeMultiplier < 0.1)
                    _survivalVars.subtractTimeMultiplier = 0.1;
                if (_survivalVars.subtractTimeMultiplier > 5)
                    _survivalVars.subtractTimeMultiplier = 5;

                _survivalVars.subtractTimeMultiplier = FlxMath.roundDecimal(_survivalVars.subtractTimeMultiplier, 2);

                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
			case "add":
				if (controls.CENTER)
					Change *= 2;

				_survivalVars.addTimeMultiplier += FlxMath.roundDecimal(Change / 10, 2);
				if (_survivalVars.addTimeMultiplier < 0.1)
					_survivalVars.addTimeMultiplier = 0.1;
				if (_survivalVars.addTimeMultiplier > 5)
					_survivalVars.addTimeMultiplier = 5;

				_survivalVars.addTimeMultiplier = FlxMath.roundDecimal(_survivalVars.addTimeMultiplier, 2);

				FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
		}

        if (!_survivalVars.carryTime && !_survivalVars.addSongTimeToCurrentTime)
            _survivalVars.carryTime = true;

		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			save();
		});
    }

    function changeHold(Change:Int)
    {
        if (controls.CENTER)
            Change *= 2;

        switch (optionShit[curSelected])
        {
            case "time":
                _survivalVars.timePercentage += Change;
                if (_survivalVars.timePercentage < 15)
                    _survivalVars.timePercentage = 15;
                if (_survivalVars.timePercentage > 150)
                    _survivalVars.timePercentage = 150;

                FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
        }

        new FlxTimer().start(0.2, function(tmr:FlxTimer)
        {
            save();
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
                    if (spr.ID == curSelected)
                        spr.animation.play("select");
                    else
                        spr.animation.play("idle");
                });
            
            switch (optionShit[curSelected])
            {
                case 'time'|'add'|'subtract':
                    navi.animation.play('shiftArrow');
                default:
                    navi.animation.play('arrow');
            }
        }

    public static function load()
    {
        if (!FileSystem.isDirectory('presets'))
            FileSystem.createDirectory('presets');

        if (!FileSystem.exists('presets/survival_options'))
            {
                _survivalVars = {
                    timePercentage: 60,
                    carryTime: true,
                    addTimeMultiplier: 1,
                    subtractTimeMultiplier: 1,
                    addSongTimeToCurrentTime: true
                };

                File.saveContent(('presets/survival_options'), Json.stringify(_survivalVars, null, '    '));
            }
        else
            {
                var data:String = File.getContent('presets/survival_options');
                _survivalVars = Json.parse(data);
            }
    }

    public static function save()
        {
            File.saveContent(('presets/survival_options'), Json.stringify(_survivalVars, null, '    '));
        }
}
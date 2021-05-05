package;

#if desktop
import Discord.DiscordClient;
#end

import flixel.FlxSubState;
import flixel.util.FlxGradient;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import MainVariables._variables;
import flixel.tweens.FlxEase;

using StringTools;

class PAGE4settings extends MusicBeatSubstate
{

    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String> = ['page', 'offset', 'spam', 'lateD', 'accuType', 'combo+', 'cutscene'];

    private var grpSongs:FlxTypedGroup<Alphabet>;
    var selectedSomethin:Bool = false;
    var curSelected:Int = 0;
    var camFollow:FlxObject;

    var ResultText:FlxText = new FlxText(20, 69, FlxG.width, "", 48);
    var ExplainText:FlxText = new FlxText(20, 69, FlxG.width/2, "", 48);

    var pause:Int = 0;

    var camLerp:Float = 0.32;

    var acc:Float;

    public function new()
    {
        super();

        persistentDraw = persistentUpdate = true;
        destroySubStates = false;

        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);
        
		var tex = Paths.getSparrowAtlas('Options_Buttons');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(800, 30 + (i * 160));
			menuItem.frames = tex;
            menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24, true);
            menuItem.animation.addByPrefix('select', optionShit[i] + " select", 24, true);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
            menuItem.antialiasing = true;
            menuItem.scrollFactor.x = 0;
            menuItem.scrollFactor.y = 1;

            menuItem.x = 2000;
            FlxTween.tween(menuItem, { x: 800}, 0.15, { ease: FlxEase.expoInOut });
        }

        camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
        
        changeItem();

        createResults();

        updateResults();

        FlxG.camera.follow(camFollow, null, camLerp);

        #if desktop
			DiscordClient.changePresence("Settings page: Gameplay", null);
		#end
    }

    function updateResults():Void
        {
            switch (_variables.accuracyType)
            {
                case 'simple':
                        acc = 0;
                case 'rating-based':
                        acc = 1;
                case 'complex':
                        acc = 2;
            }

        }

        function createResults():Void
            {
                add(ResultText);
                ResultText.scrollFactor.x = 0;
                ResultText.scrollFactor.y = 0;
                ResultText.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER);
                ResultText.x = -400;
                ResultText.y = 350;
                ResultText.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
                ResultText.alpha = 0;
                FlxTween.tween(ResultText, { alpha: 1}, 0.15, { ease: FlxEase.expoInOut });
        
                add(ExplainText);
                ExplainText.scrollFactor.x = 0;
                ExplainText.scrollFactor.y = 0;
                ExplainText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER);
                ExplainText.alignment = LEFT;
                ExplainText.x = 20;
                ExplainText.y = 624;
                ExplainText.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
                ExplainText.alpha = 0;
                FlxTween.tween(ExplainText, { alpha: 1}, 0.15, { ease: FlxEase.expoInOut });
            }

    override function update(elapsed:Float)
        {
            super.update(elapsed);

            if (!selectedSomethin)
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
                    {
                        changePress(-1);
                    }
        
                if (controls.RIGHT_P)
                    {
                        changePress(1);
                    }

                if (controls.LEFT)
                    {
                        changeHold(-1);
                    }
            
                if (controls.RIGHT)
                    {
                        changeHold(1);
                    }
                
                    if (controls.BACK)
                        {
                            FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);
                            selectedSomethin = true;

                            #if desktop
			                    DiscordClient.changePresence("Back to the main menu I go!", null);
		                    #end
    
                            menuItems.forEach(function(spr:FlxSprite)
                                {
                                    spr.animation.play('idle');
                                    FlxTween.tween(spr, { x: -1000}, 0.15, { ease: FlxEase.expoIn });
                                });
                            
                            FlxTween.tween(FlxG.camera, { zoom: 7}, 0.5, { ease: FlxEase.expoIn, startDelay: 0.2 });
                            FlxTween.tween(ResultText, { alpha: 0}, 0.15, { ease: FlxEase.expoIn });
                            FlxTween.tween(ExplainText, { alpha: 0}, 0.15, { ease: FlxEase.expoIn });
    
                            new FlxTimer().start(0.3, function(tmr:FlxTimer)
                                {
                                    FlxG.switchState(new MainMenuState());
                                });
                        }
                    }
            
            switch (optionShit[curSelected])
            {
                case "offset":
                    ResultText.text = _variables.noteOffset+" ms";
                    ExplainText.text = "NOTE OFFSET:\nChange the offset of your notes. The higher the time, the later they go.";
                case "page":
                    ResultText.text = "GAMEPLAY";
                    ExplainText.text = "Previous Page: GFX \nNext Page: MISCELLANEOUS";
                case "spam":
                    ResultText.text = Std.string(_variables.spamPrevention).toUpperCase();
                    ExplainText.text = "SPAM PREVENTION:\nSet your ability to spam key presses without any worries. False means you can.";
                case "accuType":
                    ResultText.text = _variables.accuracyType;
                    ExplainText.text = "ACCURACY TYPE:\nSet how should accuracy be taken. 'Complex' will take offsets into account. 'Simple' doesn't.";
                case "combo+":
                    ResultText.text = Std.string(_variables.comboP).toUpperCase();
                    ExplainText.text = "COMBO+:\nSet if your score should be affected by your combo.";
                case "cutscene":
                    ResultText.text = Std.string(_variables.cutscene).toUpperCase();
                    ExplainText.text = "CUTSCENES:\nToggle Story Mode cutscenes on or off.";
                case "lateD":
                    ResultText.text = Std.string(_variables.lateD).toUpperCase();
                    ExplainText.text = "LATE DAMAGE:\nChange if you want to damage your health when hitting too late.";
            }

            menuItems.forEach(function(spr:FlxSprite)
                {
                    spr.scale.set(FlxMath.lerp(spr.scale.x, 0.8, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 0.8, 0.4/(_variables.fps/60)));
                    
                    if (spr.ID == curSelected)
                    {
                        camFollow.y = FlxMath.lerp(camFollow.y, spr.getGraphicMidpoint().y, camLerp/(_variables.fps/60));
                        camFollow.x = spr.getGraphicMidpoint().x;
                        spr.scale.set(FlxMath.lerp(spr.scale.x, 1.1, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 1.1, 0.4/(_variables.fps/60)));
                    }

                    spr.updateHitbox();
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

	function changePress(Change:Int = 0)
		{
			switch (optionShit[curSelected])
			{
                case 'page':
                    SettingsState.page += Change;
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                    selectedSomethin = true;
        
                    menuItems.forEach(function(spr:FlxSprite)
                        {
                            spr.animation.play('idle');
                            FlxTween.tween(spr, { x: -1000}, 0.15, { ease: FlxEase.expoIn });
                        });

                    FlxTween.tween(ResultText, { alpha: 0}, 0.15, { ease: FlxEase.expoIn });
                    FlxTween.tween(ExplainText, { alpha: 0}, 0.15, { ease: FlxEase.expoIn });
    
                    new FlxTimer().start(0.2, function(tmr:FlxTimer)
                        {
                            if (Change == 1)
                                openSubState(new PAGE5settings());
                            else
                                openSubState(new PAGE3settings());
                        });
                case "spam":
                    _variables.spamPrevention = !_variables.spamPrevention;
        
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "combo+":
                    _variables.comboP = !_variables.comboP;
        
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                 case "cutscene":
                    _variables.cutscene = !_variables.cutscene;
            
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "lateD":
                    _variables.lateD = !_variables.lateD;
                
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "accuType":
                    acc += Change;
                    if (acc > 2)
                        acc = 0;
                    if (acc < 0)
                        acc = 2;

                    switch (acc)
                    {
                        case 0:
                            _variables.accuracyType = 'simple';
                        case 1:
                            _variables.accuracyType = 'rating-based';
                        case 2:
                            _variables.accuracyType = 'complex';
                    }
            
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
			}

            new FlxTimer().start(0.2, function(tmr:FlxTimer)
                {
                    MainVariables.Save();
                });
		}
    
        function changeHold(Change:Int = 0)
            {
                switch (optionShit[curSelected])
                {
                    case "offset":
                        _variables.noteOffset += Change;
                        if (_variables.noteOffset < -150)
                            _variables.noteOffset = -150;
                        if (_variables.noteOffset > 150)
                            _variables.noteOffset = 150;
        
                        FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                }
    
                new FlxTimer().start(0.2, function(tmr:FlxTimer)
                    {
                        MainVariables.Save();
                    });
            }

    override function openSubState(SubState:FlxSubState)
        {
            super.openSubState(SubState);
        }
}
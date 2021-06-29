package;

import openfl.Lib;
import flixel.util.FlxSave;
import sys.FileSystem;
import sys.io.File;
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

class ChromaSettings extends MusicBeatSubstate
{
    var fil:Int = 0;
    var chromasquare:FlxSprite;
    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String> = ['chromakey', 'characters', 'healthbarvis'];

    private var grpSongs:FlxTypedGroup<Alphabet>;
    var selectedSomethin:Bool = false;
    var curSelected:Int = 0;
    var camFollow:FlxObject;

    var ResultText:FlxText = new FlxText(20, 69, FlxG.width, "", 48);
    var ExplainText:FlxText = new FlxText(20, 69, FlxG.width/2, "", 48);

    var navi:FlxSprite;

    var camLerp:Float = 0.32;

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

        var nTex = Paths.getSparrowAtlas('Options_Navigation');
        navi = new FlxSprite();
        navi.frames = nTex;
        navi.animation.addByPrefix('arrow', "navigation_arrows", 24, true);
		navi.animation.play('arrow');
        navi.scrollFactor.set();
        add(navi);
        navi.y = 700 - navi.height;
        navi.x = 1260 - navi.width;

        camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
        
        changeItem();

        createResults();

        // updateResults();

        FlxG.camera.follow(camFollow, null, camLerp);

        #if desktop
			DiscordClient.changePresence("Settings page: Chromakey", null);
		#end
    }

        function createResults():Void
            {
                chromasquare = new FlxSprite(0, 0).makeGraphic(500, 500, FlxColor.GREEN);
                chromasquare.scrollFactor.set(0, 0);
                // chromasquare.scale.set(3,5);
                chromasquare.updateHitbox();
                // add(chromasquare);

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
                
                if (controls.BACK)
                        {
                            FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);
                            selectedSomethin = true;

                            menuItems.forEach(function(spr:FlxSprite)
                                {
                                    spr.animation.play('idle');
                                    FlxTween.tween(spr, { x: -1000}, 0.15, { ease: FlxEase.expoIn });
                                });
        

                            FlxTween.tween(ResultText, { alpha: 0}, 0.15, { ease: FlxEase.expoIn });
                            FlxTween.tween(ExplainText, { alpha: 0}, 0.15, { ease: FlxEase.expoIn });
    
                            new FlxTimer().start(0.3, function(tmr:FlxTimer)
                                {
                                    navi.kill();
                                    openSubState(new PAGE3settings());
                                });
                        }
                    }
            
            switch (optionShit[curSelected].toLowerCase())
            {
                // case "page":
                //     ResultText.text = "CHROMAKEY";
                //     ExplainText.text = "Previous Page: DEVELOPER \nNext Page: GENERAL";
                case "chromakey":
                    ResultText.text = Std.string(_variables.chromakey).toUpperCase();
                    ExplainText.text = "ChromaKey:\nAdds a colored screen to the background for convienence";
                // case "color":
                //     ResultText.text = Std.string(_variables.color).toUpperCase();
                //     ExplainText.text = "Color:\nChange the color of the screen";
                case "characters":
                    ResultText.text = Std.string(_variables.charactervis).toUpperCase();
                    ExplainText.text = "Characters:\nHide the characters?";
                case "healthbarvis":
                    ResultText.text = Std.string(_variables.healthbarvis).toUpperCase();
                    ExplainText.text = "HealthIcon:\nHide the health bar?";
            }

            menuItems.forEach(function(spr:FlxSprite)
                {
                    spr.scale.set(FlxMath.lerp(spr.scale.x, 0.5, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 0.5, 0.4/(_variables.fps/60)));
                    
                    if (spr.ID == curSelected)
                    {
                        camFollow.y = FlxMath.lerp(camFollow.y, spr.getGraphicMidpoint().y, camLerp/(_variables.fps/60));
                        camFollow.x = spr.getGraphicMidpoint().x;
                        spr.scale.set(FlxMath.lerp(spr.scale.x, 0.9, camLerp/(_variables.fps/60)), FlxMath.lerp(spr.scale.y, 0.9, 0.4/(_variables.fps/60)));
                    }

                    spr.updateHitbox();
                });
        }

    // function updateResults():Void
    //     {
    
    //         switch (_variables.color)
    //         {
    //             case 0xFF008000:
    //                 fil = 0;
    //             case 0xFF00FFFF:
    //                 fil = 1;
    //             case 0xFF800080:
    //                 fil = 2;
    //         }
    
    //     }
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

    function changePress(Change:Int=0)
    {
        switch (optionShit[curSelected])
            {
                case 'chromakey':
                    _variables.chromakey = !_variables.chromakey;

                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case 'healthbarvis':
                    _variables.healthbarvis = !_variables.healthbarvis;

                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case 'characters':
                    _variables.charactervis = !_variables.charactervis;

                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);

                // case 'color':
                //     fil += Change;
                //     if (fil > 2)
                //         fil = 0;
                //     if (fil < 0)
                //         fil = 2;
    
                //     switch (fil)
                //     {
                //         case 0:
                //             _variables.color = 0xFF008000;
                //         case 1:
                //             _variables.color = 0xFF00FFFF;
                //         case 2:
                //             _variables.color = 0xFF800080;
                //     }
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
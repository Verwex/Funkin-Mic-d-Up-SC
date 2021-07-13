package;

import openfl.Lib;
import Discord.DiscordClient;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import MainVariables._variables;
import flixel.tweens.FlxEase;

using StringTools;

class PAGE3settings extends MusicBeatSubstate
{

    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String> = ['page', 'chromakeyM', 'iconZoom', 'cameraZoom', 'cameraSpeed', 'noteSplashes', 'noteGlow', 'eNoteGlow', 'hpIcons', 'iconStyle', 'hpAnims', 'hpColors', 'distractions', 'bgAlpha', 'enemyAlpha', 'rainbow', 'missAnims', 'score', 'misses', 'accuracy', 'nps', 'rating', 'timing', 'combo', 'songPos'];

    private var grpSongs:FlxTypedGroup<Alphabet>;
    var selectedSomethin:Bool = false;
    var curSelected:Int = 0;
    var camFollow:FlxObject;

    var ResultText:FlxText = new FlxText(20, 69, FlxG.width, "", 48);
    var ExplainText:FlxText = new FlxText(20, 69, FlxG.width/2, "", 48);

    var pause:Int = 0;

    var camLerp:Float = 0.32;

    var navi:FlxSprite;

    var style:Int;

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
        navi.animation.addByPrefix('enter', "navigation_enter", 24, true);
        navi.animation.addByPrefix('shiftArrow', "navigation_shiftArrow", 24, true);
		navi.animation.play('arrow');
        navi.scrollFactor.set();
        add(navi);
        navi.y = 700 - navi.height;
        navi.x = 1260 - navi.width;

        camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
        
        changeItem();

        createResults();

        updateResults();

        FlxG.camera.follow(camFollow, null, camLerp);

        DiscordClient.changePresence("Settings page: GFX", null);
    }

    function updateResults():Void
    {
        style = MainVariables.iconList.indexOf(_variables.iconStyle.toLowerCase());
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

                if (controls.ACCEPT)
                {
                    if (optionShit[curSelected] == 'chromakeyM')
                    {
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
                                navi.kill();
                                openSubState(new ChromaSettings());
                            });
                    }
                }
                
                    if (controls.BACK)
                        {
                            FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);
                            selectedSomethin = true;

                            DiscordClient.changePresence("Back to the main menu I go!", null);
    
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
                case "score":
                    ResultText.text = Std.string(_variables.scoreDisplay).toUpperCase();
                    ExplainText.text = "SCORE DISPLAY:\nSet your score display visible or invisible.";
                case "misses":
                    ResultText.text = Std.string(_variables.missesDisplay).toUpperCase();
                    ExplainText.text = "MISS COUNTER:\nSet your miss counter visible or invisible.";
                case "accuracy":
                    ResultText.text = Std.string(_variables.accuracyDisplay).toUpperCase();
                    ExplainText.text = "ACCURACY DISPLAY:\nSet your accuracy display visible or invisible.";
                case "page":
                    ResultText.text = "";
                    ExplainText.text = "Previous Page: SFX \nNext Page: GAMEPLAY";
                case "rating":
                    ResultText.text = Std.string(_variables.ratingDisplay).toUpperCase();
                    ExplainText.text = "RATING DISPLAY:\nSet your rating display of your note hits visible or invisible.";
                case "combo":
                    ResultText.text = Std.string(_variables.comboDisplay).toUpperCase();
                    ExplainText.text = "COMBO COUNTER:\nSet your combo counter of hit notes visible or invisible.";
                case "timing":
                    ResultText.text = Std.string(_variables.timingDisplay).toUpperCase();
                    ExplainText.text = "TIMING DISPLAY:\nSet your timing display of your note hits visible or invisible.";
                case "iconZoom":
                    ResultText.text = _variables.iconZoom+"x";
                    ExplainText.text = "ICON ZOOM:\nChange how zoomed in character icons become after a beat. The more, the bigger zoom.";
                case "cameraZoom":
                    ResultText.text = _variables.cameraZoom+"x";
                    ExplainText.text = "CAMERA ZOOM:\nChange how zoomed in the camera becomes after a beat. The more, the bigger zoom.";
                case "cameraSpeed":
                    ResultText.text = _variables.cameraSpeed+"x";
                    ExplainText.text = "CAMERA SPEED:\nChange how fast should the camera go to follow a character. The more, the faster camera goes.";
                case "songPos":
                    ResultText.text = Std.string(_variables.songPosition).toUpperCase();
                    ExplainText.text = "SONG POSITION DISPLAY:\nSet your song position display visible or invisible.";
                case "nps":
                    ResultText.text = Std.string(_variables.nps).toUpperCase();
                    ExplainText.text = "NOTES PER SECOND DISPLAY:\nSet your display of notes pressed per second visible or invisible.";
                case "rainbow":
                    ResultText.text = Std.string(_variables.rainbow).toUpperCase();
                    ExplainText.text = "RAINBOW FPS:\nMake your PFS counter all rainbow.";
                case "distractions":
                    ResultText.text = Std.string(_variables.distractions).toUpperCase();
                    ExplainText.text = "DISTRACTIONS:\nWould you want to get yourself entirely focused or get some spice to the life of stages?";
                case "chromakeyM":
                    ResultText.text = "";
                    ExplainText.text = "\nAdd Chromakey colors to the background!";
                case "bgAlpha":
                    ResultText.text = _variables.bgAlpha * 100 +"%";
                    ExplainText.text = "BACKGROUND ALPHA:\nSet the alpha of the background camera, to get yourself better focused at the game.";
                case "noteSplashes":
                    ResultText.text = Std.string(_variables.noteSplashes).toUpperCase();
                    ExplainText.text = "NOTE SPLASHES:\nTurn on note splashes when you hit notes really good.";
                case "noteGlow":
                    ResultText.text = Std.string(_variables.noteGlow).toUpperCase();
                    ExplainText.text = "NOTE GLOW:\nMake notes glow whenever you hit notes correctly.";
                case "eNoteGlow":
                    ResultText.text = Std.string(_variables.eNoteGlow).toUpperCase();
                    ExplainText.text = "ENEMY NOTE GLOW:\nAPPLIES ONLY FOR UP AND DOWNSCROLL.\nMake enemy's notes glow whenever they hit notes.";
                case "enemyAlpha":
                    ResultText.text = _variables.enemyAlpha * 100 +"%";
                    ExplainText.text = "ENEMY NOTE ALPHA:\nAPPLIES FOR LEFTSCROLL AND RIGHTSCROLL ONLY.\nHow much do you wanna see notes of your enemies?";
                case "missAnims":
                    ResultText.text = Std.string(_variables.missAnims).toUpperCase();
                    ExplainText.text = "MISS ANIMATIONS:\nPlay miss animation for the player if they miss a note?";
                case "hpColors":
                    ResultText.text = Std.string(_variables.hpColors).toUpperCase();
                    ExplainText.text = "HEALTH BAR COLORS:\nDo you want your health bar to reflet characters in a song?";
                case "hpIcons":
                    ResultText.text = Std.string(_variables.hpIcons).toUpperCase();
                    ExplainText.text = "HEALTH ICONS:\nShow the little health icons of people?";
                case "hpAnims":
                    ResultText.text = Std.string(_variables.hpAnims).toUpperCase();
                    ExplainText.text = "HEALTH ICON ANIMATIONS:\nPlay winning and losing animations for icons when HP is low or high?";
                case "iconStyle":
				    ResultText.text = Std.string(_variables.iconStyle).toUpperCase();
				    ExplainText.text = "ICON STYLE:\nHow would you want health icons to look like?";
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

            switch (optionShit[curSelected])
		    {
			    case 'cameraSpeed'|'iconZoom'|'cameraZoom'|'bgAlpha':
			    	navi.animation.play('shiftArrow');
                case 'chromakeyM':
                    navi.animation.play('enter');
			    default:
			    	navi.animation.play('arrow');
		    }
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
                            navi.kill();
                            menuItems.kill();
                            if (Change == 1)
                                openSubState(new PAGE4settings());
                            else
                                openSubState(new PAGE2settings());
                        });
                case "score":
                    _variables.scoreDisplay = !_variables.scoreDisplay;
        
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "misses":
                    _variables.missesDisplay = !_variables.missesDisplay;
            
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "missAnims":
                    _variables.missAnims = !_variables.missAnims;
            
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "songPos":
                    _variables.songPosition = !_variables.songPosition;
                
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "distractions":
                    _variables.distractions = !_variables.distractions;
                
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "accuracy":
                    _variables.accuracyDisplay = !_variables.accuracyDisplay;
            
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "rainbow":
                    _variables.rainbow = !_variables.rainbow;
                    
                    if (!_variables.rainbow)
                        (cast (Lib.current.getChildAt(0), Main)).changeColor(0xFFFFFFFF);
                
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "rating":
                    _variables.ratingDisplay = !_variables.ratingDisplay;
            
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "timing":
                    _variables.timingDisplay = !_variables.timingDisplay;
                
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "combo":
                    _variables.comboDisplay = !_variables.comboDisplay;
                
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "nps":
                    _variables.nps = !_variables.nps;
                    
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "noteSplashes":
                    _variables.noteSplashes = !_variables.noteSplashes;
                    
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "noteGlow":
                    _variables.noteGlow = !_variables.noteGlow;
                    
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "eNoteGlow":
                    _variables.eNoteGlow = !_variables.eNoteGlow;
                    
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "hpAnims":
                    _variables.hpAnims = !_variables.hpAnims;
                    
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "hpIcons":
                    _variables.hpIcons = !_variables.hpIcons;
                    
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "iconZoom":
                    if (controls.CENTER)
                        Change *= 2;

                    _variables.iconZoom += FlxMath.roundDecimal(Change/10, 2);
                    if (_variables.iconZoom < 0)
                        _variables.iconZoom = 0;

                    _variables.iconZoom = FlxMath.roundDecimal(_variables.iconZoom, 2);
    
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "cameraZoom":
                    if (controls.CENTER)
                        Change *= 2;

                    _variables.cameraZoom += FlxMath.roundDecimal(Change/10, 2);
                    if (_variables.cameraZoom < 0)
                        _variables.cameraZoom = 0;

                    _variables.cameraZoom = FlxMath.roundDecimal(_variables.cameraZoom, 2);
        
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "cameraSpeed":
                    if (controls.CENTER)
                        Change *= 2;

                    _variables.cameraSpeed += FlxMath.roundDecimal(Change/10, 2);
                    if (_variables.cameraSpeed < 0.1)
                        _variables.cameraSpeed = 0.1;

                    _variables.cameraSpeed = FlxMath.roundDecimal(_variables.cameraSpeed, 2);
            
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "hpColors":
                    _variables.hpColors = !_variables.hpColors;
                    
                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
                case "iconStyle":
				    style += Change;
				    if (style > MainVariables.iconList.length - 1)
				    	style = 0;
				    if (style < 0)
				    	style = MainVariables.iconList.length - 1;

				    _variables.iconStyle = MainVariables.iconList[style];

                    FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume/100);
			}

            new FlxTimer().start(0.2, function(tmr:FlxTimer)
                {
                    MainVariables.Save();
                });
		}

    function changeHold(Change:Int = 0)
    {
        if (controls.CENTER)
            Change *= 2;
        
        switch (optionShit[curSelected])
        {
            case "bgAlpha":
                _variables.bgAlpha += Change / 100;
                _variables.bgAlpha = FlxMath.roundDecimal(_variables.bgAlpha, 3);

                if (_variables.bgAlpha < 0)
                    _variables.bgAlpha = 0;
                if (_variables.bgAlpha > 1)
                    _variables.bgAlpha = 1;
        
                FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
            case "enemyAlpha":
                _variables.enemyAlpha += Change / 100;
                _variables.enemyAlpha = FlxMath.roundDecimal(_variables.enemyAlpha, 3);

                if (_variables.enemyAlpha < 0)
                    _variables.enemyAlpha = 0;
                if (_variables.enemyAlpha > 1)
                    _variables.enemyAlpha = 1;
        
                FlxG.sound.play(Paths.sound('scrollMenu'), _variables.svolume / 100);
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
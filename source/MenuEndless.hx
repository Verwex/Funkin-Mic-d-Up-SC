package;

import haxe.Json;
import sys.io.File;
import sys.FileSystem;
import flixel.addons.transition.FlxTransitionableState;
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

class MenuEndless extends MusicBeatState
{
    var bg:FlxSprite = new FlxSprite(-89).loadGraphic(Paths.image('EndBG_Main'));
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('End_Checker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);
	var side:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('End_Side'));

    public static var curSelected:Int = 0;
    var camLerp:Float = 0.1;
    var selectable:Bool = false;

    public static var substated:Bool = false;
    public static var no:Bool = false;
    public static var goingBack:Bool = false;

    var songs:Array<SongTitlesE> = [];

	var scoreText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;

    override function create()
    {
        substated = false;

        FlxG.game.scaleX = 1;
		FlxG.game.x = 0;
		FlxG.game.scaleY = 1;
		FlxG.game.y = 0;

        no = false;
        goingBack = false;

        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

        var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongTitlesE(data[0]));
		}

        bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.03;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x5576D3FF, 0xAAFFDCFF], 1, 90, true); 
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		add(checker);
		checker.scrollFactor.set(0.07, 0.07);

        grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

        for (i in 0...songs.length)
            {
                var songText:Alphabet = new Alphabet(0, (90 * i) + 50, songs[i].songName, true, false);
                songText.itemType = "D-Shape";
                songText.targetY = i;
                grpSongs.add(songText);
    
                // DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
                // songText.screenCenter(X);
            }

		side.scrollFactor.x = 0;
		side.scrollFactor.y = 0;
		side.antialiasing = true;
		side.screenCenter();
		add(side);

		side.screenCenter(Y);
        side.x = 500-side.width;
		FlxTween.tween(side, {x:0}, 0.6, {ease: FlxEase.quartInOut});

		FlxTween.tween(bg, { alpha:1}, 0.8, { ease: FlxEase.quartInOut});
		FlxG.camera.zoom = 0.6;
		FlxG.camera.alpha = 0;
		FlxTween.tween(FlxG.camera, { zoom:1, alpha:1}, 0.7, { ease: FlxEase.quartInOut});

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.alignment = LEFT;
		scoreText.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		scoreText.screenCenter(Y);
        scoreText.x = 10;
        scoreText.alpha = 0;
		add(scoreText);

        FlxTween.tween(scoreText, { alpha:1}, 0.5, { ease: FlxEase.quartInOut});

		changeSelection();

		new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				selectable = true;
			});

        if (!FlxG.sound.music.playing)
			switch (_variables.music)
            {
                case 'classic':
                    FlxG.sound.playMusic(Paths.music('freakyMenu'), _variables.mvolume/100);
					Conductor.changeBPM(102);
                case 'funky':
                    FlxG.sound.playMusic(Paths.music('funkyMenu'), _variables.mvolume/100);
					Conductor.changeBPM(140);
            }

        super.create();
    }

    override function update(elapsed:Float)
    {
        checker.x -= 0.27/(_variables.fps/60);
		checker.y -= -0.2/(_variables.fps/60);

        super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7*_variables.mvolume/100)
		{
			FlxG.sound.music.volume += 0.5*_variables.mvolume/100 * FlxG.elapsed;
		}

        lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5/(_variables.fps/60)));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:\n" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
        var back = controls.BACK;

        if (!substated && selectable && !goingBack && !substated)
            {
                if (upP)
                    changeSelection(-1);
                if (downP)
                    changeSelection(1);
    
                if (back)
                {
                    FlxG.switchState(new PlaySelection());
                    goingBack = true;
                    FlxTween.tween(FlxG.camera, { zoom:0.6, alpha:-0.6}, 0.7, { ease: FlxEase.quartInOut});
                    FlxTween.tween(bg, { alpha:0}, 0.7, { ease: FlxEase.quartInOut});
                    FlxTween.tween(checker, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
                    FlxTween.tween(gradientBar, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
                    FlxTween.tween(side, { x:-500 - side.width}, 0.3, { ease: FlxEase.quartInOut});
                    FlxTween.tween(scoreText, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
    
                    #if desktop
                            DiscordClient.changePresence("Going back!", null);
                    #end
    
                    FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);
                }

                if (accepted)
                {
                    FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);

                    Endless_Substate.song = songs[curSelected].songName.toLowerCase();

                    substated = true;
                    FlxG.state.openSubState(new Endless_Substate());
                }
            }

        if (no)
        {
            bg.kill();
            side.kill();
            gradientBar.kill();
            checker.kill();
            scoreText.kill();
            grpSongs.clear();
        }
    }
    
    function changeSelection(change:Int = 0)
        {
    
            // NGio.logEvent('Fresh');
            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4*_variables.svolume/100);
    
            curSelected += change;
    
            if (curSelected < 0)
                curSelected = songs.length - 1;
            if (curSelected >= songs.length)
                curSelected = 0;
    
            // selector.y = (70 * curSelected) + 30;
    
            #if !switch
                intendedScore = Highscore.getEndless(songs[curSelected].songName.toLowerCase());
            #end

            #if desktop
			DiscordClient.changePresence("Do I choose "+songs[curSelected].songName+" on Endless?", null);
		    #end
    
            var bullShit:Int = 0;
    
            for (item in grpSongs.members)
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
}

class SongTitlesE
{
	public var songName:String = "";

	public function new(song:String)
	{
		this.songName = song;
	}
}
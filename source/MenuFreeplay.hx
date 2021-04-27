package;

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

class MenuFreeplay extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;

	public static var curSelected:Int = 0;
	public static var curDifficulty:Int = 2;

	var scoreText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	var bg:FlxSprite = new FlxSprite(-89).loadGraphic(Paths.image('fBG_Main'));
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Free_Checker'), 0.2, 0.2, true, true);
	var gradientBar:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width, 300, 0xFFAA00AA);
	var side:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('Free_Bottom'));
	var boombox:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('Boombox'));

	var disc:FlxSprite = new FlxSprite(-200, 730);
	var discIcon:HealthIcon = new HealthIcon("bf");

	var sprDifficulty:FlxSprite;

	var rankTable:Array<String> = ['P','X','X-','SS+','SS','SS-','S+','S','S-','A+','A','A-','B','C','D','E','NA'];
	var rank:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('rankings/NA'));

	private var vocals:FlxSound;

	override function create()
	{
		FlxG.game.scaleX = 1;
		FlxG.game.x = 0;
		FlxG.game.scaleY = 1;
		FlxG.game.y = 0;
		
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		bg.alpha = 0;

		gradientBar = FlxGradient.createGradientFlxSprite(Math.round(FlxG.width), 512, [0x00ff0000, 0x55FFBDF8, 0xAAFFFDF3], 1, 90, true); 
		gradientBar.y = FlxG.height - gradientBar.height;
		add(gradientBar);
		gradientBar.scrollFactor.set(0, 0);

		add(checker);
		checker.scrollFactor.set(0, 0.07);

		side.scrollFactor.x = 0;
		side.scrollFactor.y = 0;
		side.antialiasing = true;
		side.screenCenter();
		add(side);
		side.y = FlxG.height;
		//side.y = FlxG.height - side.height/3*2;
		side.x = FlxG.width/2 - side.width/2;

		var tex = Paths.getSparrowAtlas('Freeplay_Discs');
		disc.frames = tex;
		disc.animation.addByPrefix("dad", "dad", 24);
		disc.animation.play("dad");
		add(disc);
		add(discIcon);
		discIcon.antialiasing = disc.antialiasing = true;

		rank.setGraphicSize(0,90);
		rank.updateHitbox();
		rank.scrollFactor.set();
		rank.y = 690 - rank.height;
		rank.x = disc.x + disc.width - 50;
		add(rank);
		rank.antialiasing = true;

		rank.alpha = 0;

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.itemType = "C-Shape";
			songText.targetY = i;
			grpSongs.add(songText);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
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
		sprDifficulty.screenCenter(X);
		sprDifficulty.y = FlxG.height - sprDifficulty.height - 8;
		add(sprDifficulty);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.alignment = CENTER;
		scoreText.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		scoreText.screenCenter(X);
		scoreText.y = sprDifficulty.y - 38;
		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));
			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;
			FlxG.stage.addChild(texFel);
			// scoreText.textField.htmlText = md;
			trace(md);
		 */

		super.create();

		FlxTween.tween(bg, { alpha:1}, 0.5, { ease: FlxEase.quartInOut});
		FlxTween.tween(side, { y:FlxG.height - side.height/3*2}, 0.5, { ease: FlxEase.quartInOut});
		disc.scale.x = 0;
		FlxTween.tween(disc, { 'scale.x':1, y: 480, x: -25}, 0.5, { ease: FlxEase.quartInOut});
		scoreText.alpha = sprDifficulty.alpha = 0;
		FlxTween.tween(scoreText, { alpha:1}, 0.5, { ease: FlxEase.quartInOut});
		FlxTween.tween(sprDifficulty, { alpha:1}, 0.5, { ease: FlxEase.quartInOut});
		FlxTween.tween(rank, { alpha:1}, 0.5, { ease: FlxEase.quartInOut});

		FlxG.camera.zoom = 0.6;
		FlxG.camera.alpha = 0;
		FlxTween.tween(FlxG.camera, { zoom:1, alpha:1}, 0.5, { ease: FlxEase.quartInOut});

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				selectable = true;
			});
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	var selectedSomethin:Bool = false;
	var selectable:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		rank.x = disc.x + disc.width - 50;

		checker.x -= -0.27/(_variables.fps/60);
		checker.y -= 0.63/(_variables.fps/60);

		persistentUpdate = persistentDraw = true;

		if (FlxG.sound.music.volume < 0.7*_variables.mvolume/100)
		{
			FlxG.sound.music.volume += 0.5*_variables.mvolume/100 * FlxG.elapsed;
		}

		if (vocals.volume < 0.7*_variables.vvolume/100)
		{
			vocals.volume += 0.5*_variables.vvolume/100 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5/(_variables.fps/60)));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (!selectedSomethin && selectable)
		{
			if (upP)
			{
				vocals.stop();
				changeSelection(-1);
			}
			if (downP)
			{
				vocals.stop();
				changeSelection(1);
			}

			if (controls.LEFT_P)
				changeDiff(-1);
			if (controls.RIGHT_P)
				changeDiff(1);

			if (controls.BACK)
			{
				FlxG.switchState(new PlaySelection());
				vocals.fadeOut(0.4, 0);
				selectedSomethin = true;
				FlxTween.tween(FlxG.camera, { zoom:0.6, alpha:-0.6}, 0.7, { ease: FlxEase.quartInOut});
				FlxTween.tween(bg, { alpha:0}, 0.7, { ease: FlxEase.quartInOut});
				FlxTween.tween(checker, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
				FlxTween.tween(gradientBar, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
				FlxTween.tween(side, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
				FlxTween.tween(sprDifficulty, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
				FlxTween.tween(scoreText, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
				FlxTween.tween(rank, { alpha:0}, 0.3, { ease: FlxEase.quartInOut});
				FlxTween.tween(disc, { alpha:0, 'scale.x':0}, 0.3, { ease: FlxEase.quartInOut});

				#if desktop
						DiscordClient.changePresence("Going back!", null);
				#end

				FlxG.sound.play(Paths.sound('cancelMenu'), _variables.svolume/100);
			}

			if (accepted)
			{
				selectedSomethin = true;

				#if desktop
						DiscordClient.changePresence("Selecting chart types.", null);
				#end

				FlxG.sound.play(Paths.sound('confirmMenu'), _variables.svolume/100);

				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				trace(poop);

				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				PlayState.gameplayArea = "Freeplay";
				PlayState.storyDifficulty = curDifficulty;

				FlxTween.tween(bg, { alpha:0}, 0.6, { ease: FlxEase.quartInOut});
				FlxTween.tween(checker, { alpha:0}, 0.6, { ease: FlxEase.quartInOut});
				FlxTween.tween(gradientBar, { alpha:0}, 0.6, { ease: FlxEase.quartInOut});
				FlxTween.tween(side, { alpha:0}, 0.8, { ease: FlxEase.quartInOut});
				FlxTween.tween(rank, { alpha:0}, 0.8, { ease: FlxEase.quartInOut});
				FlxTween.tween(disc, { alpha:0, 'scale.x':0}, 0.8, { ease: FlxEase.quartInOut});
				FlxTween.tween(scoreText, { y:750, alpha: 0}, 0.8, { ease: FlxEase.quartInOut});
				FlxTween.tween(sprDifficulty, { y:750, alpha: 0}, 0.8, { ease: FlxEase.quartInOut});
				for (item in grpSongs.members)
					{
						FlxTween.tween(item, { alpha:0}, 0.9, { ease: FlxEase.quartInOut});
					}

				PlayState.storyWeek = songs[curSelected].week;
				trace('CUR WEEK' + PlayState.storyWeek);

				vocals.fadeOut(0.9, 0);

				new FlxTimer().start(0.9, function(tmr:FlxTimer)
					{
						vocals.stop();
						FlxG.state.openSubState(new Substate_ChartType());
					});
			}
		}

		if (vocals.volume <= 0 && selectedSomethin)
			vocals.stop();

		discIcon.x = disc.x + disc.width/2 - discIcon.width/2;
		discIcon.y = disc.y + disc.height/2 - discIcon.height/2;
		discIcon.angle = disc.angle += 0.6 / (_variables.fps/60);
		discIcon.scale.set(disc.scale.x, disc.scale.y);
		scoreText.x = FlxG.width/2 - scoreText.width/2;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 5;
		if (curDifficulty > 5)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		rank.loadGraphic(Paths.image('rankings/'+rankTable[Highscore.getRank(songs[curSelected].songName, curDifficulty)]));
		rank.setGraphicSize(0,90);
		rank.updateHitbox();
		rank.scrollFactor.set();
		rank.y = 690 - rank.height;
		rank.x = disc.x + disc.width - 50;
		#end

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

		sprDifficulty.y = FlxG.height - sprDifficulty.height - 38;
		FlxTween.tween(sprDifficulty, {y: FlxG.height - sprDifficulty.height - 8, alpha: 1}, 0.04);
		sprDifficulty.x = FlxG.width/2 - sprDifficulty.width/2;
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
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		rank.loadGraphic(Paths.image('rankings/'+rankTable[Highscore.getRank(songs[curSelected].songName, curDifficulty)]));
		rank.setGraphicSize(0,90);
		rank.updateHitbox();
		rank.scrollFactor.set();
		rank.y = 690 - rank.height;
		rank.x = disc.x + disc.width - 50;
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		if (_modifiers.VibeSwitch)
			{
				switch (_modifiers.Vibe)
				{
				case 0.8:
					FlxG.sound.playMusic(Paths.instHIFI(songs[curSelected].songName), 0);
				case 1.2:
					FlxG.sound.playMusic(Paths.instLOFI(songs[curSelected].songName), 0);
				default:
					FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
				}
			}
			else
				FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		FlxG.sound.music.stop();

		if (_modifiers.VibeSwitch)
			{
				switch (_modifiers.Vibe)
				{
				case 0.8:
					vocals = new FlxSound().loadEmbedded(Paths.voicesHIFI(songs[curSelected].songName), true);
				case 1.2:
					vocals = new FlxSound().loadEmbedded(Paths.voicesLOFI(songs[curSelected].songName), true);
				default:
					vocals = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].songName), true);
				}
			}
		else
			vocals = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].songName), true);

		vocals.volume = 0;
		FlxG.sound.list.add(vocals);
		vocals.time = FlxG.sound.music.time;
		vocals.play();
		vocals.stop();

		if (_modifiers.VibeSwitch)
			{
				switch (_modifiers.Vibe)
				{
				case 0.8:
					FlxG.sound.playMusic(Paths.instHIFI(songs[curSelected].songName), 0);
				case 1.2:
					FlxG.sound.playMusic(Paths.instLOFI(songs[curSelected].songName), 0);
				default:
					FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
				}
			}
			else
				FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);

		vocals.play();

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

		#if desktop
		// Updating Discord Rich Presence
		switch (FlxG.random.int(0, 5))
		{
			case 0:
				DiscordClient.changePresence("Vibing to " + songs[curSelected].songName + " for:", null, null, true);
			case 1:
				DiscordClient.changePresence("Sleeping on someone with " + songs[curSelected].songName + " for:", null, null, true);
			case 2:
				DiscordClient.changePresence("Dreaming about " + songs[curSelected].songName + " for:", null, null, true);
			case 3:
				DiscordClient.changePresence("Suckling some " + songs[curSelected].songName + " for:", null, null, true);
			case 4:
				DiscordClient.changePresence("Presenting " + songs[curSelected].songName + " to myself for:", null, null, true);
			case 5:
					DiscordClient.changePresence("Admiring " + songs[curSelected].songName + " for:", null, null, true);
		}
		#end

		disc.animation.addByPrefix(songs[curSelected].songCharacter, songs[curSelected].songCharacter, 24);
		disc.animation.play(songs[curSelected].songCharacter);
		discIcon.animation.play(songs[curSelected].songCharacter);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
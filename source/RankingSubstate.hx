package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import MainVariables._variables;
import ModifierVariables._modifiers;

class RankingSubstate extends MusicBeatSubstate
{
	var pauseMusic:FlxSound;

	var rank:FlxSprite = new FlxSprite(-200, 730);
	var combo:FlxSprite = new FlxSprite(-200, 730);
	var comboRank:String = "N/A";
	var ranking:String = "N/A";
	var rankingNum:Int = 15;

	public function new(x:Float, y:Float)
	{
		super();

		generateRanking();
		Highscore.saveRank(PlayState.SONG.song, rankingNum, PlayState.storyDifficulty);
		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		rank = new FlxSprite(-20, 40).loadGraphic(Paths.image('rankings/$ranking'));
		rank.scrollFactor.set();
		add(rank);
		rank.antialiasing = true;
		rank.setGraphicSize(0,450);
		rank.updateHitbox();
		rank.screenCenter();

		combo = new FlxSprite(-20, 40).loadGraphic(Paths.image('rankings/$comboRank'));
		combo.scrollFactor.set();
		combo.screenCenter();
		combo.x = rank.x - combo.width/2;
		combo.y = rank.y - combo.height/2;
		add(combo);
		combo.antialiasing = true;
		combo.setGraphicSize(0,130);

		var press:FlxText = new FlxText(20, 15, 0, "Press ANY to continue.", 32);
		press.scrollFactor.set();
		press.setFormat(Paths.font("vcr.ttf"), 32);
		press.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		press.updateHitbox();
		add(press);

		var hint:FlxText = new FlxText(20, 15, 0, "You passed. Try getting under 10 misses for SDCB", 32);
		hint.scrollFactor.set();
		hint.setFormat(Paths.font("vcr.ttf"), 32);
		hint.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		hint.updateHitbox();
		add(hint);

		switch (comboRank)
		{
			case 'MFC':
				hint.text = "Congrats! You're perfect!";
			case 'GFC':
				hint.text = "You're doing great! Try getting only sicks for MFC";
			case 'FC':
				hint.text = "Good job. Try getting goods at minimum for GFC.";
			case 'SDCB':
				hint.text = "Nice. Try not missing at all for FC.";
		}
		hint.screenCenter(X);

		hint.alpha = press.alpha = 0;

		press.screenCenter();
		press.y = 670 - press.height;

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(press, {alpha: 1, y: 690 - press.height}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(hint, {alpha: 1, y: 645 - hint.height}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5 * _variables.mvolume/100)
			pauseMusic.volume += 0.01 * _variables.mvolume/100 * elapsed;

		super.update(elapsed);

		if (FlxG.keys.justPressed.ANY || _modifiers.Practice)
		{
			PlayState.ended = false;

			switch (PlayState.gameplayArea)
			{
				case "Story":
					if (PlayState.storyPlaylist.length <= 0)
					{
						switch (_variables.music)
            			{
    			            case 'classic':
    			                FlxG.sound.playMusic(Paths.music('freakyMenu'), _variables.mvolume/100);
								Conductor.changeBPM(102);
    			            case 'funky':
    			                FlxG.sound.playMusic(Paths.music('funkyMenu'), _variables.mvolume/100);
								Conductor.changeBPM(140);
    			        }
						FlxG.switchState(new MenuWeek());
					}
					else
					{
						var difficulty:String = "";

						if (PlayState.storyDifficulty == 0)
							difficulty = '-noob';

						if (PlayState.storyDifficulty == 1)
							difficulty = '-easy';

						if (PlayState.storyDifficulty == 3)
							difficulty = '-hard';

						if (PlayState.storyDifficulty == 4)
							difficulty = '-expert';

						if (PlayState.storyDifficulty == 5)
							difficulty = '-insane';

						trace('LOADING NEXT SONG');
						trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
						FlxG.sound.music.stop();

						LoadingState.loadAndSwitchState(new PlayState());
					}
				case "Freeplay":
					FlxG.switchState(new MenuFreeplay());
			}	
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function generateRanking():String
		{
			if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
				comboRank = "MFC";
			else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
				comboRank = "GFC";
			else if (PlayState.misses == 0) // Regular FC
				comboRank = "FC";
			else if (PlayState.misses < 10) // Single Digit Combo Breaks
				comboRank = "SDCB";
	
			// WIFE TIME :)))) (based on Wife3)
	
			var wifeConditions:Array<Bool> = [
				PlayState.accuracy >= 99.9935, // P
				PlayState.accuracy >= 99.980, // X
				PlayState.accuracy >= 99.950, // X-
				PlayState.accuracy >= 99.90, // SS+
				PlayState.accuracy >= 99.80, // SS
				PlayState.accuracy >= 99.70, // SS-
				PlayState.accuracy >= 99.50, // S+
				PlayState.accuracy >= 99, // S
				PlayState.accuracy >= 96.50, // S-
				PlayState.accuracy >= 93, // A+
				PlayState.accuracy >= 90, // A
				PlayState.accuracy >= 85, // A-
				PlayState.accuracy >= 80, // B
				PlayState.accuracy >= 70, // C
				PlayState.accuracy >= 60, // D
				PlayState.accuracy < 60 // E
			];
	
			for(i in 0...wifeConditions.length)
			{
				var b = wifeConditions[i];
				if (b)
				{
					rankingNum = i;
					switch(i)
					{
						case 0:
							ranking = "P";
						case 1:
							ranking = "X";
						case 2:
							ranking = "X-";
						case 3:
							ranking = "SS+";
						case 4:
							ranking = "SS";
						case 5:
							ranking = "SS-";
						case 6:
							ranking = "S+";
						case 7:
							ranking = "S";
						case 8:
							ranking = "S-";
						case 9:
							ranking = "A+";
						case 10:
							ranking = "A";
						case 11:
							ranking = "A-";
						case 12:
							ranking = "B";
						case 13:
							ranking = "C";
						case 14:
							ranking = "D";
						case 15:
							ranking = "E";
					}
					break;
				}
			}
			return ranking;
		}
}

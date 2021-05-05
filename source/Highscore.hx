package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var endlessScores:Map<String, Int> = new Map();
	public static var songRanks:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var endlessScores:Map<String, Int> = new Map<String, Int>();
	public static var songRanks:Map<String, Int> = new Map<String, Int>();
	#end


	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);


		#if !switch
		NGio.postScore(score, song);
		#end


		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveRank(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songRanks.exists(daSong))
		{
			if (songRanks.get(daSong) > score)
				setRank(daSong, score);
		}
		else
			setRank(daSong, score);
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{

		#if !switch
		NGio.postScore(score, "Week " + week);
		#end


		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	public static function saveMarathonScore(score:Int = 0):Void
		{
			if (score > FlxG.save.data.marathonScore || FlxG.save.data.marathonScore == null)
			{
				FlxG.save.data.marathonScore = score;
				FlxG.save.flush();
			}
		}

	public static function saveEndlessScore(song:String, score:Int = 0):Void
		{
			var daSong:String = song;

			if (endlessScores.exists(daSong))
			{
				if (endlessScores.get(daSong) < score)
					setEndless(daSong, score);
			}
			else
				setEndless(daSong, score);
		}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setEndless(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		endlessScores.set(song, score);
		FlxG.save.data.endlessScores = endlessScores;
		FlxG.save.flush();
	}

	static function setRank(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRanks.set(song, score);
		FlxG.save.data.songRanks = songRanks;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-noob';
		else if (diff == 1)
			daSong += '-easy';
		else if (diff == 3)
			daSong += '-hard';
		else if (diff == 4)
			daSong += '-expert';
		else if (diff == 5)
			daSong += '-insane';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getEndless(song:String):Int
		{
			if (!endlessScores.exists(song))
				setEndless((song), 0);
	
			return endlessScores.get(song);
		}

	public static function getRank(song:String, diff:Int):Int
	{
		if (!songRanks.exists(formatSong(song, diff)))
			setRank(formatSong(song, diff), 16);

		return songRanks.get(formatSong(song, diff));
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.endlessScores != null)
		{
			endlessScores = FlxG.save.data.endlessScores;
		}
		if (FlxG.save.data.songRanks != null)
		{
			songRanks = FlxG.save.data.songRanks;
		}
	}
}

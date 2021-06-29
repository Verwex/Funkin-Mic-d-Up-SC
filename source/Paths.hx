package;

import flixel.system.FlxAssets.FlxSoundAsset;
import lime.tools.AssetType;
import flixel.input.FlxInput;
import sys.io.FileInput;
import cpp.RawConstPointer;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Bytes;
import flixel.util.typeLimit.OneOfTwo;
import openfl.media.Sound;

using StringTools;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static function getPathImage(file:String, type:AssetType, library:Null<String>):FlxGraphicAsset
	{
		if (library != null)
			return getImageLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return BitmapData.fromBytes(ByteArray.fromBytes(File.getBytes(levelPath)));

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return BitmapData.fromBytes(ByteArray.fromBytes(File.getBytes(levelPath)));
		}

		return getImagePath(file);
	}

	static function getPathSound(file:String, type:AssetType, library:Null<String>):FlxSoundAsset
	{
		if (library != null)
			return getSoundLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:openfl.media.Sound = getSoundPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath.toString(), type))
				return levelPath;

			levelPath = getSoundPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath.toString(), type))
				return levelPath;
		}

		return getSoundPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	static public function getImageLibraryPath(file:String, library = "preload"):FlxGraphicAsset
	{
		return if (library == "preload" || library == "default") getImagePath(file); else getImagePathForce(file, library);
	}

	static public function getSoundLibraryPath(file:String, library = "preload"):FlxSoundAsset
	{
		return if (library == "preload" || library == "default") getSoundPath(file); else getSoundPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		if (FileSystem.exists('mods/mainMods/_append/$library/$file'))
		{
			return File.getContent('mods/mainMods/_append/$library/$file');
		}
		else
		{
			return '$library:assets/$library/$file';
		}
	}

	inline static function getPreloadPath(file:String)
	{
		if (FileSystem.exists('mods/mainMods/_append/$file'))
		{
			return File.getContent('mods/mainMods/_append/$file');
		}
		else
		{
			return 'assets/$file';
		}
	}

	inline static function getSoundPathForce(file:String, library:String):FlxSoundAsset
	{
		if (FileSystem.exists('mods/mainMods/_append/$library/$file'))
		{
			return Sound.fromFile('mods/mainMods/_append/$library/$file');
		}
		else
		{
			return Sound.fromFile('assets/$library/$file');
		}
	}

	inline static function getSoundPath(file:String):FlxSoundAsset
	{
		if (FileSystem.exists('mods/mainMods/_append/$file'))
		{
			return Sound.fromFile('mods/mainMods/_append/$file');
		}
		else
		{
			return Sound.fromFile('assets/$file');
		}
	}

	inline static function getImagePathForce(file:String, library:String):FlxGraphicAsset
	{
		if (FileSystem.exists('mods/mainMods/_append/$library/$file'))
		{
			var rawPic = File.getBytes('mods/mainMods/_append/$library/$file');
			return BitmapData.fromBytes(ByteArray.fromBytes(rawPic));
		}
		else
		{
			var rawPic = File.getBytes('assets/$library/$file');
			return BitmapData.fromBytes(ByteArray.fromBytes(rawPic));
		}
	}

	inline static function getImagePath(file:String):FlxGraphicAsset
	{
		if (FileSystem.exists('mods/mainMods/_append/$file'))
		{
			var rawPic = File.getBytes('mods/mainMods/_append/$file');
			return BitmapData.fromBytes(ByteArray.fromBytes(rawPic));
		}
		else
		{
			var rawPic = File.getBytes('assets/$file');
			return BitmapData.fromBytes(ByteArray.fromBytes(rawPic));
		}
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline public static function offsets(path:String, ?library:String):Array<String>
	{
		var daList:Array<String> = [];
		if (!FileSystem.exists('mods/mainMods/_append/shared/images/characters/$path.txt'))
		{
			// CRINGE ASS!
			daList = lime.utils.Assets.getText('shared:assets/shared/images/characters/$path.txt').trim().split('\n');
		}
		else
			daList = File.getContent('mods/mainMods/_append/shared/images/characters/$path.txt').trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		#if !sys
		return getPath('data/$key.json', TEXT, library);
		#else
		if (FileSystem.exists(('mods/mainMods/_append/data/$key.json')))
		{
			return 'mods/mainMods/_append/data/$key.json';
		}
		else
			return getPath('data/$key.json', TEXT, library);
		#end
	}

	static public function sound(key:String, ?library:String):FlxSoundAsset
	{
		if (FileSystem.exists('mods/mainMods/_append/sounds/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/shared/sounds/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week1/sounds/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week2/sounds/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week3/sounds/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week4/sounds/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week5/sounds/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week6/sounds/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/$library/sounds/$key.ogg'))
			return getPathSound('sounds/$key.$SOUND_EXT', SOUND, library);
		else
			return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String):FlxSoundAsset
	{
		if (FileSystem.exists('mods/mainMods/_append/music/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/shared/music/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week1/music/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week2/music/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week3/music/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week4/music/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week5/music/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/week6/music/$key.ogg')
			|| FileSystem.exists('mods/mainMods/_append/$library/music/$key.ogg'))
			return getPathSound('music/$key.$SOUND_EXT', MUSIC, library);
		else
			return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		var rawSound:flixel.system.FlxAssets.FlxSoundAsset = 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
		if (FileSystem.exists('mods/mainMods/_append/songs/${song.toLowerCase()}/Voices.$SOUND_EXT'))
			rawSound = Sound.fromFile('mods/mainMods/_append/songs/${song.toLowerCase()}/Voices.$SOUND_EXT');

		return rawSound;
	}

	inline static public function voicesHIFI(song:String)
	{
		var rawSound:flixel.system.FlxAssets.FlxSoundAsset = 'songs:assets/songs/${song.toLowerCase()}/Voices_HIFI.$SOUND_EXT';
		if (FileSystem.exists('mods/mainMods/_append/songs/${song.toLowerCase()}/Voices_HIFI.$SOUND_EXT'))
			rawSound = Sound.fromFile('mods/mainMods/_append/songs/${song.toLowerCase()}/Voices_HIFI.$SOUND_EXT');

		return rawSound;
	}

	inline static public function voicesLOFI(song:String)
	{
		var rawSound:flixel.system.FlxAssets.FlxSoundAsset = 'songs:assets/songs/${song.toLowerCase()}/Voices_LOFI.$SOUND_EXT';
		if (FileSystem.exists('mods/mainMods/_append/songs/${song.toLowerCase()}/Voices_LOFI.$SOUND_EXT'))
			rawSound = Sound.fromFile('mods/mainMods/_append/songs/${song.toLowerCase()}/Voices_LOFI.$SOUND_EXT');

		return rawSound;
	}

	inline static public function inst(song:String)
	{
		var rawSound:flixel.system.FlxAssets.FlxSoundAsset = 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
		if (FileSystem.exists('mods/mainMods/_append/songs/${song.toLowerCase()}/Inst.$SOUND_EXT'))
			rawSound = Sound.fromFile('mods/mainMods/_append/songs/${song.toLowerCase()}/Inst.$SOUND_EXT');

		return rawSound;
	}

	inline static public function instHIFI(song:String)
	{
		var rawSound:flixel.system.FlxAssets.FlxSoundAsset = 'songs:assets/songs/${song.toLowerCase()}/Inst_HIFI.$SOUND_EXT';
		if (FileSystem.exists('mods/mainMods/_append/songs/${song.toLowerCase()}/Inst_HIFI.$SOUND_EXT'))
			rawSound = Sound.fromFile('mods/mainMods/_append/songs/${song.toLowerCase()}/Inst_HIFI.$SOUND_EXT');

		return rawSound;
	}

	inline static public function instLOFI(song:String)
	{
		var rawSound:flixel.system.FlxAssets.FlxSoundAsset = 'songs:assets/songs/${song.toLowerCase()}/Inst_LOFI.$SOUND_EXT';
		if (FileSystem.exists('mods/mainMods/_append/songs/${song.toLowerCase()}/Inst_LOFI.$SOUND_EXT'))
			rawSound = Sound.fromFile('mods/mainMods/_append/songs/${song.toLowerCase()}/Inst_LOFI.$SOUND_EXT');

		return rawSound;
	}

	inline static public function image(key:String, ?library:String):FlxGraphicAsset
	{
		// i seriously dont know any other way of doing this
		if (FileSystem.exists('mods/mainMods/_append/images/$key.png')
			|| FileSystem.exists('mods/mainMods/_append/shared/images/$key.png')
			|| FileSystem.exists('mods/mainMods/_append/week1/images/$key.png')
			|| FileSystem.exists('mods/mainMods/_append/week2/images/$key.png')
			|| FileSystem.exists('mods/mainMods/_append/week3/images/$key.png')
			|| FileSystem.exists('mods/mainMods/_append/week4/images/$key.png')
			|| FileSystem.exists('mods/mainMods/_append/week5/images/$key.png')
			|| FileSystem.exists('mods/mainMods/_append/week6/images/$key.png')
			|| FileSystem.exists('mods/mainMods/_append/$library/images/$key.png')) // lol
			return getPathImage('images/$key.png', IMAGE, library);
		else
			return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}

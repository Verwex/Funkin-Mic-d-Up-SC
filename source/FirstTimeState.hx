package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import MainVariables._variables;
using StringTools;

#if desktop
import Discord.DiscordClient;
#end

class FirstTimeState extends MusicBeatState
{

	var sinMod:Float = 0;
	var txt:FlxText = new FlxText(0, 360, FlxG.width,
		"WARNING:\nFNF: Mic'd Up may potentially trigger seizures for people with photosensitive epilepsy.Viewer discretion is advised.\n\n"
		+ "FNF: Mic'd Up is a non-profit modification, aimed for entertainment purposes, and wasn't meant to be an attack on Ninjamuffin99"
		+ " and/or any other modmakers out there. I was not aiming for replacing what Friday Night Funkin' was, won't be aiming for that and never"
		+ " will be aiming for that. It was made for fun and from the love for the game itself. All of the comparisons between this and other mods are purely coincidental, unless stated otherwise.\n\n"
		+ "Now with that out of the way, I hope you'll enjoy this FNF mod.\nFunk all the way.\nPress ENTER to proceed",
		32);

	override function create()
	{

		#if desktop
				DiscordClient.changePresence("Started for the first time.", null);
		#end
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		add(txt);

		super.create();
	}

	override function update(elapsed:Float)
	{
		sinMod += 0.007;
		txt.y = Math.sin(sinMod)*60+100;

		if (controls.ACCEPT)
		{
			_variables.firstTime = false;
			MainVariables.Save();
			
			FlxG.switchState(new TitleState());
		}
		super.update(elapsed);
	}
}

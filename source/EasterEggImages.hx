package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class EasterEggImages extends MusicBeatState
{
    public static var image:String = "";
    public static var song:String = "";

    override function create()
    {
        super.create();
        
        var eggImage:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('fullscreen/'+image));
        eggImage.setGraphicSize(0, FlxG.height);
        eggImage.updateHitbox();
        eggImage.screenCenter();
        add(eggImage);

        if (song != '')
            FlxG.sound.play(song);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    
        if (controls.BACK)
        {
			if (Substate_PresetSave.coming == "Modifiers")
				FlxG.switchState(new MenuModifiers());
			else if (Substate_PresetSave.coming == "Marathon")
				FlxG.switchState(new MenuMarathon());
        }
    }
}
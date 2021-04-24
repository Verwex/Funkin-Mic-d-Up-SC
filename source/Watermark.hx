package;

import flixel.FlxG;
import flixel.FlxSprite;

class Watermark extends FlxSprite
{
    var water:FlxSprite;

    public function new() 
        {
            super();

            water = new FlxSprite(-89).loadGraphic(Paths.image('watermark'));
		    water.setGraphicSize(0, 75);
		    water.updateHitbox();
		    water.x = FlxG.width - 20 - water.width/2;
            water.y = FlxG.height - 20 - water.height/2;
		    water.antialiasing = true;
            water.alpha = 0.4;
        }
}
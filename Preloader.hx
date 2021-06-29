package;

import flixel.addons.editors.ogmo.FlxOgmo3Loader.LayerData;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxBasePreloader;
import flash.display.*;
import flash.text.*;
import flash.Lib;
import openfl.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;

@:bitmap("art/preloadBG.png") class LogoImage extends BitmapData
{
}

@:font("assets/fonts/vcr.ttf") class CustomFont extends Font
{
}

class Preloader extends FlxBasePreloader
{
	public function new(MinDisplayTime:Float = 5, ?AllowedURLs:Array<String>)
	{
		super(MinDisplayTime, AllowedURLs);
	}

	var logo:Sprite;
	var text:TextField;

	override function create():Void
	{
		this._width = Lib.current.stage.stageWidth;
		this._height = Lib.current.stage.stageHeight;

		var ratio:Float = this._width / 800; // This allows us to scale assets depending on the size of the screen.

		logo = new Sprite();
		logo.addChild(new Bitmap(new LogoImage(0, 0))); // Sets the graphic of the sprite to a Bitmap object, which uses our embedded BitmapData class.
		logo.x = ((this._width) / 2) - ((logo.width) / 2);
		logo.y = (this._height / 2) - ((logo.height) / 2);
		logo.scaleX -= 0.5;
		logo.scaleY -= 0.5;
		addChild(logo); // Adds the graphic to the NMEPreloader's buffer.

		Font.registerFont(CustomFont);
		text = new TextField();
		text.defaultTextFormat = new TextFormat("VCR OSD Mono", 12, 0xffffff);
		text.embedFonts = true;

		text.text = "Preloading assets...";
		addChild(text);

		super.create();
	}

	override function update(Percent:Float):Void
	{
		super.update(Percent);
		text.x = Lib.current.stage.stageWidth - 10 - text.width;
		text.y = Lib.current.stage.stageHeight - 10 - text.height;
		switch (Percent)
		{
			case 50:
				text.text = "Halfway there...";
			case 70:
				text.text = "Almost there...";
			case 80:
				text.text = "Done!";
			case 90:
				FlxTween.tween(text, {alpha: 0, y: text.y - 50}, 0.5, {ease: FlxEase.cubeInOut});
				FlxTween.tween(logo, {alpha: 0, y: text.y - 50}, 0.5, {ease: FlxEase.cubeInOut});
		}
	}
}

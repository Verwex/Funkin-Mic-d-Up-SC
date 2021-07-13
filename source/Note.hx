package;

import flixel.FlxG;
import sys.io.File;
import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import ModifierVariables._modifiers;
import MainVariables._variables;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	// MINES: mines. end of story.
	// ROLLS: taiko type rolls (jacks but you dont need to hit em)
	public var noteVariant:String = '';
	public var isRoll:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var canMissLeft:Bool = true;
	public static var canMissRight:Bool = true;
	public static var canMissUp:Bool = true;
	public static var canMissDown:Bool = true;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:String = '', ?roll:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		noteVariant = noteType;
		isRoll = roll;

		x += 95;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		switch (noteVariant)
		{
			default:
				switch (daStage)
				{
					case 'school' | 'schoolEvil':
						loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels', 'week6'), true, 17, 17);

						animation.add('greenScroll', [7]);
						animation.add('redScroll', [8]);
						animation.add('blueScroll', [6]);
						animation.add('purpleScroll', [5]);
						animation.add('yellowScroll', [9]);

						if (isSustainNote)
						{
							if (!isRoll)
							{
								loadGraphic(Paths.image('weeb/pixelUI/arrowEnds', 'week6'), true, 7, 6);

								animation.add('purpleholdend', [5]);
								animation.add('greenholdend', [7]);
								animation.add('redholdend', [8]);
								animation.add('blueholdend', [6]);
								animation.add('yellowholdend', [9]);

								animation.add('purplehold', [0]);
								animation.add('greenhold', [2]);
								animation.add('redhold', [3]);
								animation.add('bluehold', [1]);
								animation.add('yellowhold', [4]);
							}
							else
							{
								loadGraphic(Paths.image('weeb/pixelUI/rollEnds', 'week6'), true, 16, 6);

								animation.add('purplerollend', [5]);
								animation.add('greenrollend', [7]);
								animation.add('redrollend', [8]);
								animation.add('bluerollend', [6]);
								animation.add('yellowrollend', [9]);

								animation.add('purpleroll', [0]);
								animation.add('greenroll', [2]);
								animation.add('redroll', [3]);
								animation.add('blueroll', [1]);
								animation.add('yellowroll', [4]);
							}
						}

						setGraphicSize(Std.int(width * PlayState.daPixelZoom));
						updateHitbox();

					default:
						frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');

						animation.addByPrefix('greenScroll', 'green0');
						animation.addByPrefix('redScroll', 'red0');
						animation.addByPrefix('blueScroll', 'blue0');
						animation.addByPrefix('purpleScroll', 'purple0');
						animation.addByPrefix('yellowScroll', 'yellow0');

						animation.addByPrefix('purpleholdend', 'pruple end hold');
						animation.addByPrefix('greenholdend', 'green hold end');
						animation.addByPrefix('redholdend', 'red hold end');
						animation.addByPrefix('blueholdend', 'blue hold end');
						animation.addByPrefix('yellowholdend', 'yellow hold end');

						animation.addByPrefix('purplehold', 'purple hold piece');
						animation.addByPrefix('greenhold', 'green hold piece');
						animation.addByPrefix('redhold', 'red hold piece');
						animation.addByPrefix('bluehold', 'blue hold piece');
						animation.addByPrefix('yellowhold', 'yellow hold piece');

						animation.addByPrefix('purplerollend', 'purple roll end');
						animation.addByPrefix('greenrollend', 'green roll end');
						animation.addByPrefix('redrollend', 'red roll end');
						animation.addByPrefix('bluerollend', 'blue roll end');
						animation.addByPrefix('yellowrollend', 'yellow roll end');

						animation.addByPrefix('purpleroll', 'purple roll piece');
						animation.addByPrefix('greenroll', 'green roll piece');
						animation.addByPrefix('redroll', 'red roll piece');
						animation.addByPrefix('blueroll', 'blue roll piece');
						animation.addByPrefix('yellowroll', 'yellow roll piece');

						setGraphicSize(Std.int(width * 0.7));
						updateHitbox();
						antialiasing = true;
				}
			case 'mine':
				switch (daStage)
				{
					case 'school' | 'schoolEvil':
						loadGraphic(Paths.image('weeb/pixelUI/arrowMINE-pixel', 'week6'), true, 17, 17);
						animation.add('mineScroll', [0]);
						setGraphicSize(Std.int(width * PlayState.daPixelZoom));
						updateHitbox();

						if (isSustainNote)
						{
							if (isRoll)
							{
								loadGraphic(Paths.image('weeb/pixelUI/arrowEnds', 'week6'), true, 7, 6);

								animation.add('redholdend', [8]);

								animation.add('redhold', [3]);
							}
							else
							{
								loadGraphic(Paths.image('weeb/pixelUI/rollEnds', 'week6'), true, 16, 6);

								animation.add('redrollend', [8]);

								animation.add('redroll', [3]);
							}
						}

					default:
						// thanks catte
						loadGraphic(Paths.image('arrowMINE', 'shared'), true, 153, 153);
						animation.add('mineScroll', [0]);
						setGraphicSize(Std.int(width * 0.7));
						updateHitbox();
						antialiasing = true;

						if (isSustainNote)
						{
							frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
							animation.addByPrefix('redholdend', 'red hold end');
							animation.addByPrefix('redhold', 'red hold piece');
							animation.addByPrefix('redrollend', 'red roll end');
							animation.addByPrefix('redroll', 'red roll piece');
						}
				}
			case 'death':
				switch (daStage)
				{
					case 'school' | 'schoolEvil':
						loadGraphic(Paths.image('weeb/pixelUI/arrowDEATH-pixel', 'week6'), true, 17, 17);
						animation.add('deathScroll', [0]);
						setGraphicSize(Std.int(width * PlayState.daPixelZoom));
						updateHitbox();

						if (isSustainNote)
							{
								if (isRoll)
									{
										loadGraphic(Paths.image('weeb/pixelUI/arrowEnds', 'week6'), true, 7, 6);
		
										animation.add('redholdend', [8]);
		
										animation.add('redhold', [3]);
									}
									else
									{
										loadGraphic(Paths.image('weeb/pixelUI/rollEnds', 'week6'), true, 16, 6);
		
										animation.add('redrollend', [8]);
									}		
							}
					default:
						// thanks catte
						loadGraphic(Paths.image('arrowDEATH', 'shared'), true, 153, 153);
						animation.add('deathScroll', [0]);
						setGraphicSize(Std.int(width * 0.7));
						updateHitbox();
						antialiasing = true;

						if (isSustainNote)
							{
								frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
								animation.addByPrefix('redholdend', 'red hold end');
								animation.addByPrefix('redhold', 'red hold piece');
								animation.addByPrefix('redrollend', 'red roll end');
								animation.addByPrefix('redroll', 'red roll piece');
							}
				}
		}

		switch (noteVariant)
		{
			default:
				if (!_variables.fiveK)
					{
						switch (noteData)
						{
							case 0:
								x += swagWidth * 0;
								animation.play('purpleScroll');
							case 1:
								x += swagWidth * 1;
								animation.play('blueScroll');
							case 2:
								x += swagWidth * 2;
								animation.play('greenScroll');
							case 3:
								x += swagWidth * 3;
								animation.play('redScroll');
						}
					}
					else
					{
						switch (noteData)
						{
							case 0:
								x += swagWidth * 0;
								animation.play('purpleScroll');
							case 1:
								x += swagWidth * 1;
								animation.play('blueScroll');
							case 4:
								x += swagWidth * 2;
								animation.play('yellowScroll');
							case 2:
								x += swagWidth * 3;
								animation.play('greenScroll');
							case 3:
								x += swagWidth * 4;
								animation.play('redScroll');
						}
					}
			case 'mine':
				x += swagWidth * noteData;
				if (!isSustainNote)
					animation.play('mineScroll');
			case 'death':
				x += swagWidth * noteData;
				if (!isSustainNote)
					animation.play('deathScroll');
		}

		// trace(prevNote);

		if ((_variables.scroll == "down" || _variables.scroll == "right") && !sustainNote)
			flipY = true;

		if ((_variables.scroll == "left") && !isSustainNote)
			angle += 90;
		else if ((_variables.scroll == "right") && !isSustainNote)
			angle -= 90;

		if (_modifiers.FlippedNotes && !isSustainNote)
		{
			flipX = true;
			flipY = !flipY;
		}

		var sustainType = "hold";
		if (isRoll)
			sustainType = "roll";

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;

			if (!isRoll)
				alpha = 0.6;

			x += width / 2;

			switch (noteVariant)
			{
				default:
					if (!_variables.fiveK)
						{
							switch (noteData)
							{
								case 0:
									animation.play('purple' + sustainType + 'end');
								case 1:
									animation.play('blue' + sustainType + 'end');
								case 2:
									animation.play('green' + sustainType + 'end');
								case 3:
									animation.play('red' + sustainType + 'end');
							}
						}
						else
						{
							switch (noteData)
							{
								case 0:
									animation.play('purple' + sustainType + 'end');
								case 1:
									animation.play('blue' + sustainType + 'end');
								case 4:
									animation.play('yellow' + sustainType + 'end');
								case 2:
									animation.play('green' + sustainType + 'end');
								case 3:
									animation.play('red' + sustainType + 'end');
							}
						}
				case 'mine'|'death':
					animation.play('red' + sustainType + 'end');
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (noteVariant)
				{
					default:
						if (!_variables.fiveK)
							{
								switch (prevNote.noteData)
								{
									case 0:
										prevNote.animation.play('purple' + sustainType);
									case 1:
										prevNote.animation.play('blue' + sustainType);
									case 2:
										prevNote.animation.play('green' + sustainType);
									case 3:
										prevNote.animation.play('red' + sustainType);
								}
							}
							else
							{
								switch (prevNote.noteData)
								{
									case 0:
										prevNote.animation.play('purple' + sustainType);
									case 1:
										prevNote.animation.play('blue' + sustainType);
									case 4:
										prevNote.animation.play('yellow' + sustainType);
									case 2:
										prevNote.animation.play('green' + sustainType);
									case 3:
										prevNote.animation.play('red' + sustainType);
								}
							}
					case 'mine'|'death':
						prevNote.animation.play('red' + sustainType);
				}
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if ((noteVariant == "mine" || noteVariant == "death") && !isSustainNote)
			angle += 1;

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
			{
				canBeHit = true;
				setCanMiss(noteData, false);
			}
			else
			{
				canBeHit = false;
				setCanMiss(noteData, true);
			}
			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
			{
				tooLate = true;
				setCanMiss(noteData, false);
			}
		}
		else
		{
			canBeHit = false;
			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}

	public static function setCanMiss(data:Int, bool:Bool)
	{
		switch (data)
		{
			case 0:
				canMissLeft = bool;
			case 1:
				canMissDown = bool;
			case 2:
				canMissUp = bool;
			case 3:
				canMissRight = bool;
		}
	}
}

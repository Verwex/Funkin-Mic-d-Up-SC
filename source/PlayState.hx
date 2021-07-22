package;

import cpp.abi.Abi;
import lime.graphics.Image;
import lime.app.Application;
import sys.FileSystem;
import Discord.DiscordClient;
import sys.io.File;
import LoopState;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import openfl.filters.ShaderFilter;
import MainVariables._variables;
import ModifierVariables._modifiers;
import Endless_Substate._endless;
import Survival_GameOptions._survivalVars;
import seedyrng.Random;
import hscript.plus.ScriptState;

using StringTools;
using Std;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var gameplayArea:String = "Story";
	public static var chartType:String = "standard";
	public static var storyWeek:Int = 0;
	public static var curDeaths:Int = 0;

	public static var loops:Int = 0;
	public static var speed:Float = 0;

	var died:Bool = false;

	public static var storyPlaylist:Array<String> = [];
	public static var difficultyPlaylist:Array<String> = [];

	public static var storyDifficulty:Int = 1;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;
	public static var mashViolations:Int = 0;
	public static var mashing:Int = 0;

	var songName:FlxText;

	public static var botPlay:FlxText;

	public var songPositionBar:Float = 0;

	var halloweenLevel:Bool = false;
	var doof:DialogueBox;

	public var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	public var allNotes:Array<Note> = [];
	public var unspawnNotes:Array<Note> = [];
	public var loopA:Float = 0;
	public var loopB:Float;
	public var loopState:LoopState = NONE;

	public var strumLine:FlxSprite;
	public var curSection:Int = 0;

	public var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public var strumLineNotes:FlxTypedGroup<FlxSkewedSprite>;
	public var playerStrums:FlxTypedGroup<FlxSkewedSprite>;
	public var player2Strums:FlxTypedGroup<FlxSkewedSprite>;
	public var strums2:Array<Array<Bool>> = [[false, false], [false, false], [false, false], [false, false], [false, false]];
	public var hearts:FlxTypedGroup<FlxSprite>;

	public var camZooming:Bool = false;
	public var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;

	public var generatedMusic:Bool = false;
	public var startingSong:Bool = false;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camNOTES:FlxCamera;
	public var note0:FlxCamera;
	public var note1:FlxCamera;
	public var note2:FlxCamera;
	public var note3:FlxCamera;
	public var note4:FlxCamera;
	public var noteCamArray:Array<FlxCamera> = [];
	public var camSus:FlxCamera; // sussy!!1!11
	public var camNOTEHUD:FlxCamera;
	public var camHUD:FlxCamera;
	public var camPAUSE:FlxCamera;
	public var camGame:FlxCamera;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public static var dialogue:Array<String> = [];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var realSpeed:Float = 0;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	public var LightsOutBG:FlxSprite;
	public var BlindingBG:FlxSprite;
	public var freezeIndicator:FlxSprite;

	// Will fire once to prevent debug spam messages and broken animations
	public var triggeredAlready:Bool = false;

	// Will decide if she's even allowed to headbang at all depending on the song
	public var allowedToHeadbang:Bool = false;

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	public static var misses:Int = 0;
	var curMisses:Int;

	var missTxt:FlxText;

	public static var accuracy:Float = 0.00;

	public var totalNotesHit:Float = 0;
	public var totalPlayed:Int = 0;

	var accuracyTxt:FlxText;
	var canDie:Bool = true;

	public static var arrowLane:Int = 0;
	public static var arrowLane2:Int = 0;

	var nps:Int = 0;
	var npsTxt:FlxText;

	public static var ended:Bool = false;
	public static var reset:Bool = false;
	public static var cheated:Bool = false;

	var lives:Float = 1;
	var heartSprite:FlxSprite;
	var offbeatValue:Float = 0;
	var speedNote:Float = 1;
	var noteDrunk:Float = 0;
	var noteAccel:Float = 0;
	var paparazziInt:Int = 0;
	var missCounter:Int = 0;
	var frozen:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;
	var beginCutscene:Bool = false;

	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";

	var dialogueSuffix:String = "";

	public static var cameraX:Float;
	public static var cameraY:Float;

	var miscLerp:Float = 0.09;
	var camLerp:Float = 0.14;
	var zoomLerp:Float = 0.09;

	var susWiggle:ShaderFilter;

	var modState = new ScriptState();

	var hittingNote:Bool = false;

	var survivalTimer:Float = 0;
	public static var timeLeftOver:Float = 0;

	var seconds:Float;
	var survivalCountdown:FlxText;

	override public function create()
	{
		instance = this;
		// _positions = Json.parse(data);

		ended = false;
		reset = false;
		cheated = false;

		dialogue = null;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;
		accuracy = 0.00;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (_variables.hitsound.toLowerCase() != 'none')
			FlxG.sound.play(Paths.sound('hitsounds/' + _variables.hitsound, 'shared'), 0); // just a way to preload them

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camHUD.alpha = 0;
		camSus = new FlxCamera();
		camSus.bgColor.alpha = 0;
		camSus.alpha = 0;
		camSus.flashSprite.width = camSus.flashSprite.width * 2;
		camSus.flashSprite.height = camSus.flashSprite.height * 2;
		camNOTES = new FlxCamera();
		camNOTES.bgColor.alpha = 0;
		camNOTES.alpha = 0;
		camNOTES.flashSprite.width = camSus.flashSprite.width;
		camNOTES.flashSprite.height = camSus.flashSprite.height;
		camNOTEHUD = new FlxCamera();
		camNOTEHUD.bgColor.alpha = 0;
		camNOTEHUD.alpha = 0;
		camNOTEHUD.flashSprite.width = camSus.flashSprite.width;
		camNOTEHUD.flashSprite.height = camSus.flashSprite.height;
		camPAUSE = new FlxCamera();
		camPAUSE.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camNOTEHUD);
		FlxG.cameras.add(camSus);
		FlxG.cameras.add(camNOTES);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camPAUSE);

		modifierValues();

		// noteCamArray = [note0, note1, note2, note3, note4];

		if (_variables.scroll == "down" || _variables.scroll == "right")
		{
			camNOTES.flashSprite.scaleY = -1;
			camNOTEHUD.flashSprite.scaleY = -1;
			camSus.flashSprite.scaleY = -1;
		}

		if (_variables.scroll == 'left' || _variables.scroll == 'right')
		{
			camNOTES.angle -= 90;
			camNOTEHUD.angle -= 90;
			camSus.angle -= 90;

			camSus.y = -370;
			camNOTEHUD.y = -370;
			camNOTES.y = -370;

			if (_variables.scroll == "left")
			{
				camSus.x += 100;
				camNOTEHUD.x += 100;
				camNOTES.x += 100;
			}
			else if (_variables.scroll == "right")
			{
				camSus.x -= 95;
				camNOTEHUD.x -= 95;
				camNOTES.x -= 95;
			}

			camSus.height = FlxG.width + 200;
			camNOTES.height = FlxG.width + 200;
			camNOTEHUD.height = FlxG.width + 200;
		}

		// FlxG.cameras.setDefaultDrawTarget(camGame, true);
		// ! DEPRECATED
		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;
		
		if (gameplayArea == "Survival" && _survivalVars.carryTime)
			survivalTimer += timeLeftOver;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		if (gameplayArea == "Endless")
			SONG.speed = _endless.speed;

		if (gameplayArea != "Endless" && gameplayArea != "Charting" && _variables.speed != 0)
			SONG.speed = _variables.speed;

		Conductor.mapBPMChanges(SONG);

		Conductor.changeBPM(SONG.bpm);

		realSpeed = SONG.speed;

		if (_modifiers.LoveSwitch && _modifiers.Fright < _modifiers.Love)
			dialogueSuffix = "-love";
		else if (_modifiers.FrightSwitch && _modifiers.Fright < 50 && _modifiers.Love <= _modifiers.Fright)
			dialogueSuffix = "-uneasy";
		else if (_modifiers.FrightSwitch && (_modifiers.Fright >= 50 && _modifiers.Fright < 100) && _modifiers.Love <= _modifiers.Fright)
			dialogueSuffix = "-scared";
		else if (_modifiers.FrightSwitch && (_modifiers.Fright >= 100 && _modifiers.Fright < 200) && _modifiers.Love <= _modifiers.Fright)
			dialogueSuffix = "-terrified";
		else if (_modifiers.FrightSwitch && _modifiers.Fright >= 200 && _modifiers.Love <= _modifiers.Fright)
			dialogueSuffix = "-depressed";
			// else if (_modifiers.FrightSwitch && _modifiers.Fright >= 310)
		//	dialogueSuffix = "-dead"; ///yiiiiikes
		else if (_modifiers.Practice)
			dialogueSuffix = "-practice";
		else if (_modifiers.Perfect || _modifiers.BadTrip || _modifiers.ShittyEnding || _modifiers.TruePerfect)
			dialogueSuffix = "-perfect";

		if (FileSystem.exists(Paths.txt(SONG.song.toLowerCase() + '/dialogue$dialogueSuffix')))
		{
			dialogue = File.getContent(Paths.txt(SONG.song.toLowerCase() + '/dialogue$dialogueSuffix')).trim().split('\n');

			for (i in 0...dialogue.length)
			{
				dialogue[i] = dialogue[i].trim();
			}
		}

		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Noob";
			case 1:
				storyDifficultyText = "Easy";
			case 2:
				storyDifficultyText = "Normal";
			case 3:
				storyDifficultyText = "Hard";
			case 4:
				storyDifficultyText = "Expert";
			case 5:
				storyDifficultyText = "Insane";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		switch (gameplayArea)
		{
			case "Story":
				detailsText = "Week Selection: Week " + storyWeek;
			case "Freeplay":
				detailsText = "Freeplay:";
			case "Marathon":
				detailsText = "Marathon:";
			case "Survival":
				detailsText = "Survival: ";
			case "Endless":
				detailsText = "Endless: Loop " + loops;
		}

		// String for when the game is paused
		detailsPausedText = "BRB - " + detailsText;

		if (gameplayArea == "Endless")
			detailsPausedText = "BRB - Endless:";

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);

		if (gameplayArea == "Endless")
			DiscordClient.changePresence(detailsText, SONG.song, iconRPC, true);

		// Stage assigner if _variables.chromakey is true
		switch (SONG.song.toLowerCase())
		{
			case 'spookeez' | 'monster' | 'south':
				curStage = "spooky";

			case 'pico' | 'blammed' | 'philly nice':
				curStage = 'philly';

			case 'milf' | 'satin panties' | 'high':
				curStage = 'limo';
				defaultCamZoom = 0.90;

			case 'cocoa' | 'eggnog':
				curStage = 'mall';
				defaultCamZoom = 0.80;

			case 'winter horrorland':
				curStage = 'mallEvil';

			case 'senpai' | 'roses':
				curStage = 'school';

			case 'thorns':
				curStage = 'schoolEvil';

			default:
				curStage = 'stage';
				defaultCamZoom = 0.90;
		}

		// Greenscreen??
		if (!_variables.chromakey)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'spookeez' | 'monster' | 'south':
					{
						curStage = "spooky";
						halloweenLevel = true;

						var hallowTex = Paths.getSparrowAtlas('halloween_bg', 'week2');

						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -45)
							hallowTex = Paths.getSparrowAtlas('halloween_LObg', 'week2');

						halloweenBG = new FlxSprite(-200, -100);
						halloweenBG.frames = hallowTex;
						halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
						halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
						halloweenBG.animation.play('idle');
						halloweenBG.antialiasing = true;
						add(halloweenBG);

						var halloweenLight:FlxSprite = new FlxSprite(-100, -300);
						halloweenLight.frames = Paths.getSparrowAtlas('halloween_lightbulb', 'week2');
						halloweenLight.scrollFactor.set(0.85, 0.85);
						halloweenLight.animation.addByPrefix('Lightbulb', 'Lightbulb', 18, true);
						halloweenLight.animation.play('Lightbulb');
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness >= 50)
							add(halloweenLight);

						isHalloween = true;
					}
				case 'pico' | 'blammed' | 'philly nice':
					{
						curStage = 'philly';

						var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));

						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -15)
							bg = new FlxSprite(-100).loadGraphic(Paths.image('philly/skyLO', 'week3'));

						bg.scrollFactor.set(0.1, 0.1);
						add(bg);

						var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
						city.scrollFactor.set(0.3, 0.3);
						city.setGraphicSize(Std.int(city.width * 0.85));
						city.updateHitbox();
						add(city);

						phillyCityLights = new FlxTypedGroup<FlxSprite>();
						add(phillyCityLights);

						for (i in 0...5)
						{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
						}

						var discoBall:FlxSprite = new FlxSprite(800, 0);
						discoBall.frames = Paths.getSparrowAtlas('philly/discoBall', 'week3');
						discoBall.scrollFactor.set(0.45, 0.45);
						discoBall.animation.addByPrefix('discoBall', 'Glowing Ball', 24, true);
						discoBall.animation.play('discoBall');
						discoBall.antialiasing = true;
						discoBall.setGraphicSize(Std.int(discoBall.width * 1.3));
						add(discoBall);
						discoBall.visible = false;
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness >= 60)
							discoBall.visible = true;

						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -55)
							phillyCityLights.visible = false;

						var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));
						add(streetBehind);

						phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));
						add(phillyTrain);

						trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'shared'));
						FlxG.sound.list.add(trainSound);

						// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

						var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'week3'));
						add(street);

						var floorLights:FlxSprite = new FlxSprite(420, 70);
						floorLights.frames = Paths.getSparrowAtlas('philly/floorLights', 'week3');
						floorLights.scrollFactor.set(1, 1);
						floorLights.animation.addByPrefix('floorLights', 'Floor Lights', 24, true);
						floorLights.animation.play('floorLights');
						floorLights.setGraphicSize(Std.int(floorLights.width * 3));
						add(floorLights);
						floorLights.visible = false;
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness >= 30)
							floorLights.visible = true;
					}
				case 'milf' | 'satin panties' | 'high':
					{
						curStage = 'limo';
						defaultCamZoom = 0.90;

						var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'week4'));
						skyBG.scrollFactor.set(0.1, 0.1);
						add(skyBG);

						var TunnelBG:FlxSprite = new FlxSprite(-300, -100);
						TunnelBG.frames = Paths.getSparrowAtlas('limo/limoTunnel', 'week4');
						TunnelBG.scrollFactor.set(0.25, 0.25);
						TunnelBG.animation.addByPrefix('tunnel', 'Tunnel');
						TunnelBG.animation.play('tunnel');
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -55)
							add(TunnelBG);

						var limoStreet:FlxSprite = new FlxSprite(-850, -680);
						limoStreet.frames = Paths.getSparrowAtlas('limo/limoStreet', 'week4');
						limoStreet.scrollFactor.set(0.25, 0.25);
						limoStreet.animation.addByPrefix('limoStreet', 'Tunnel');
						limoStreet.animation.play('limoStreet');
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness >= 45)
							add(limoStreet);

						var bgLimo:FlxSprite = new FlxSprite(-200, 480);
						bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
						bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
						bgLimo.animation.play('drive');
						bgLimo.scrollFactor.set(0.4, 0.4);
						add(bgLimo);

						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);

						for (i in 0...5)
						{
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
							dancer.scrollFactor.set(0.4, 0.4);
							grpLimoDancers.add(dancer);
						}

						var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay', 'week4'));
						overlayShit.alpha = 0.5;
						// add(overlayShit);

						// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

						// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

						// overlayShit.shader = shaderBullshit;

						var limoTex = Paths.getSparrowAtlas('limo/limoDrive', 'week4');

						limo = new FlxSprite(-120, 550);
						limo.frames = limoTex;
						limo.animation.addByPrefix('drive', "Limo stage", 24);
						limo.animation.play('drive');
						limo.antialiasing = true;

						fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
						// add(limo);
					}
				case 'cocoa' | 'eggnog':
					{
						curStage = 'mall';

						defaultCamZoom = 0.80;

						var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls', 'week5'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -65)
							bg = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWallsLO', 'week5'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.2, 0.2);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 0.8));
						bg.updateHitbox();
						add(bg);

						upperBoppers = new FlxSprite(-240, -90);
						upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
						upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
						upperBoppers.antialiasing = true;
						upperBoppers.scrollFactor.set(0.33, 0.33);
						upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
						upperBoppers.updateHitbox();
						add(upperBoppers);
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -30)
							upperBoppers.visible = false;

						var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator', 'week5'));
						bgEscalator.antialiasing = true;
						bgEscalator.scrollFactor.set(0.3, 0.3);
						bgEscalator.active = false;
						bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
						bgEscalator.updateHitbox();
						add(bgEscalator);

						var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree', 'week5'));
						tree.antialiasing = true;
						tree.scrollFactor.set(0.40, 0.40);
						add(tree);

						bottomBoppers = new FlxSprite(-300, 140);
						bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop', 'week5');
						bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
						bottomBoppers.antialiasing = true;
						bottomBoppers.scrollFactor.set(0.9, 0.9);
						bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
						bottomBoppers.updateHitbox();
						add(bottomBoppers);
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -45)
							bottomBoppers.visible = false;

						var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow', 'week5'));
						fgSnow.active = false;
						fgSnow.antialiasing = true;
						add(fgSnow);

						santa = new FlxSprite(-840, 150);
						santa.frames = Paths.getSparrowAtlas('christmas/santa', 'week5');
						santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
						santa.antialiasing = true;
						add(santa);
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -70)
							santa.visible = false;
					}
				case 'winter horrorland':
					{
						curStage = 'mallEvil';
						var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG', 'week5'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -50)
							bg = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBGLO', 'week5'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.2, 0.2);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 0.8));
						bg.updateHitbox();
						add(bg);

						var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree', 'week5'));
						evilTree.antialiasing = true;
						evilTree.scrollFactor.set(0.2, 0.2);
						add(evilTree);

						var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow", 'week5'));
						evilSnow.antialiasing = true;
						add(evilSnow);
					}
				case 'senpai' | 'roses':
					{
						curStage = 'school';

						// defaultCamZoom = 0.9;

						var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky', 'week6'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -60)
							bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSkyLO', 'week6'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness >= 20)
							bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSkyB', 'week6'));
						bgSky.scrollFactor.set(0.1, 0.1);
						add(bgSky);

						var repositionShit = -200;

						var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool', 'week6'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -60)
							bgSchool = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchoolLO', 'week6'));
						bgSchool.scrollFactor.set(0.6, 0.90);
						add(bgSchool);

						var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet', 'week6'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -60)
							bgStreet = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreetLO', 'week6'));
						bgStreet.scrollFactor.set(0.95, 0.95);
						add(bgStreet);

						var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack', 'week6'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -60)
							fgTrees = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBackLO', 'week6'));
						fgTrees.scrollFactor.set(0.9, 0.9);
						add(fgTrees);

						var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
						var treetex = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -60)
							treetex = Paths.getPackerAtlas('weeb/weebTreesLO', 'week6');
						bgTrees.frames = treetex;
						bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
						bgTrees.animation.play('treeLoop');
						bgTrees.scrollFactor.set(0.85, 0.85);
						add(bgTrees);

						var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
						treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'week6');
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -60)
							treeLeaves.frames = Paths.getSparrowAtlas('weeb/petalsLO', 'week6');
						treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
						treeLeaves.animation.play('leaves');
						treeLeaves.scrollFactor.set(0.85, 0.85);
						add(treeLeaves);

						var widShit = Std.int(bgSky.width * 6);

						bgSky.setGraphicSize(widShit);
						bgSchool.setGraphicSize(widShit);
						bgStreet.setGraphicSize(widShit);
						bgTrees.setGraphicSize(Std.int(widShit * 1.4));
						fgTrees.setGraphicSize(Std.int(widShit * 0.8));
						treeLeaves.setGraphicSize(widShit);

						fgTrees.updateHitbox();
						bgSky.updateHitbox();
						bgSchool.updateHitbox();
						bgStreet.updateHitbox();
						bgTrees.updateHitbox();
						treeLeaves.updateHitbox();

						bgGirls = new BackgroundGirls(-100, 190);
						bgGirls.scrollFactor.set(0.9, 0.9);

						if (SONG.song.toLowerCase() == 'roses')
						{
							bgGirls.getScared();
						}

						bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
						bgGirls.updateHitbox();
						add(bgGirls);
						if (_modifiers.BrightnessSwitch && (_modifiers.Brightness <= -30 || _modifiers.Brightness >= 40))
							bgGirls.visible = false;
					}
				case 'thorns':
					{
						curStage = 'schoolEvil';

						var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
						var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

						var posX = 400;
						var posY = 200;

						var bg:FlxSprite = new FlxSprite(posX, posY);
						bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool', 'week6');
						bg.animation.addByPrefix('idle', 'background 2', 24);
						bg.animation.play('idle');
						bg.scrollFactor.set(0.8, 0.9);
						bg.scale.set(6, 6);
						add(bg);
					}
				default:
					{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback', 'week1'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront', 'week1'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness >= 35)
							stageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefrontB', 'week1'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -35)
							stageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefrontLO', 'week1'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);

						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains', 'week1'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness >= 35)
							stageCurtains = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtainsB', 'week1'));
						if (_modifiers.BrightnessSwitch && _modifiers.Brightness <= -35)
							stageCurtains = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtainsLO', 'week1'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;

						add(stageCurtains);
					}
			}
		}
		else
		{
			var chromaScreen = new FlxSprite(-5000, -2000).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.GREEN);
			chromaScreen.scrollFactor.set(0, 0);
			chromaScreen.scale.set(3, 3);
			chromaScreen.updateHitbox();
			add(chromaScreen);
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		if (curStage == "schoolEvil" && !_variables.chromakey)
		{
			var image = Image.fromFile('assets/images/hell.png');
			Application.current.window.setIcon(image);
		}

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (gameplayArea == "Story")
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		if (!boyfriend.curCharacter.startsWith('bf'))
			boyfriend.y = 100;

		switch (SONG.player1)
		{
			case 'gf':
				boyfriend.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (gameplayArea == "Story")
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				boyfriend.y += 200;
			case "monster":
				boyfriend.y += 100;
			case 'monster-christmas':
				boyfriend.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				boyfriend.y += 300;
			case 'parents-christmas':
				boyfriend.x -= 500;
			case 'senpai':
				boyfriend.x += 150;
				boyfriend.y += 360;
				camPos.set(boyfriend.getGraphicMidpoint().x + 300, boyfriend.getGraphicMidpoint().y);
			case 'senpai-angry':
				boyfriend.x += 150;
				boyfriend.y += 360;
				camPos.set(boyfriend.getGraphicMidpoint().x + 300, boyfriend.getGraphicMidpoint().y);
			case 'spirit':
				boyfriend.x -= 150;
				boyfriend.y += 100;
				camPos.set(boyfriend.getGraphicMidpoint().x + 300, boyfriend.getGraphicMidpoint().y);
			case 'bf-pixel':
				if (curStage.startsWith('school'))
				{
					boyfriend.x += 200;
					boyfriend.y += 220;
				}
				else
				{
					boyfriend.x += 200;
					boyfriend.y += 170;
				}
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				if (_variables.distractions && !_variables.chromakey)
				{
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				gf.x += 180;
				gf.y += 300;
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo' && !_variables.chromakey)
			add(limo);

		add(dad);
		add(boyfriend);

		if (_variables.chromakey && _variables.charactervis)
		{
			gf.visible = false;
			dad.visible = false;
			boyfriend.visible = false;
		}

		doof = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		// le wiggle
		wiggleShit.waveAmplitude = 0.07;
		wiggleShit.effectType = WiggleEffect.WiggleEffectType.DREAMY;
		wiggleShit.waveFrequency = 0;
		wiggleShit.waveSpeed = 1.8; // fasto
		wiggleShit.shader.uTime.value = [(strumLine.y - Note.swagWidth * 4) / FlxG.height]; // from 4mbr0s3 2
		susWiggle = new ShaderFilter(wiggleShit.shader);
		// le wiggle 2
		var wiggleShit2:WiggleEffect = new WiggleEffect();
		wiggleShit2.waveAmplitude = 0.10;
		wiggleShit2.effectType = WiggleEffect.WiggleEffectType.HEAT_WAVE_VERTICAL;
		wiggleShit2.waveFrequency = 0;
		wiggleShit2.waveSpeed = 1.8; // fasto
		wiggleShit2.shader.uTime.value = [(strumLine.y - Note.swagWidth * 4) / FlxG.height]; // from 4mbr0s3 2
		var susWiggle2 = new ShaderFilter(wiggleShit2.shader);
		camSus.setFilters([susWiggle]); // only enable it for snake notes

		strumLineNotes = new FlxTypedGroup<FlxSkewedSprite>();
		add(strumLineNotes);

		if (_modifiers.InvisibleNotes)
		{
			strumLine.visible = false;
			strumLineNotes.visible = false;
		}

		playerStrums = new FlxTypedGroup<FlxSkewedSprite>();
		player2Strums = new FlxTypedGroup<FlxSkewedSprite>();

		// startCountdown();

		generateSong(SONG.song);
		speed = SONG.speed;

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, camLerp);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (_variables.songPosition) // I dont wanna talk about this code :(
		{
			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar', 'shared'));
			if (_variables.scroll == "down")
				songPosBG.y = FlxG.height * 0.9 + 45;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);
			songPosBG.cameras = [camHUD];

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, 90000);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);
			songPosBar.cameras = [camHUD];

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20, songPosBG.y, 0, SONG.song, 16);
			if (_variables.scroll == "down")
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			songName.screenCenter(X);
			add(songName);
			songName.cameras = [camHUD];
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar', 'shared'));
		if (_variables.scroll == "down")
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.numDivisions = 1000;
		// healthBar
		add(healthBar);

		botPlay = new FlxText(healthBar.x, healthBar.y, 0, "AutoPlayCPU", 20);
		botPlay.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT);
		botPlay.setBorderStyle(OUTLINE, 0xFF000000, 3, 1);
		botPlay.scrollFactor.set();
		botPlay.screenCenter(X);
		add(botPlay);
		botPlay.visible = _variables.botplay;

		scoreTxt = new FlxText(healthBarBG.x - healthBarBG.width / 2, healthBarBG.y + 26, 0, "", 20);
		if (_variables.scroll == "down")
			scoreTxt.y = healthBarBG.y - 18;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT);
		scoreTxt.setBorderStyle(OUTLINE, 0xFF000000, 3, 1);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);
		scoreTxt.visible = _variables.scoreDisplay;

		missTxt = new FlxText(scoreTxt.x, scoreTxt.y - 26, 0, "", 20);
		if (_variables.scroll == "down")
			missTxt.y = scoreTxt.y + 26;
		missTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT);
		missTxt.setBorderStyle(OUTLINE, 0xFF000000, 3, 1);
		missTxt.scrollFactor.set();
		add(missTxt);
		missTxt.visible = _variables.missesDisplay;

		accuracyTxt = new FlxText(missTxt.x, missTxt.y - 26, 0, "", 20);
		if (_variables.scroll == "down")
			accuracyTxt.y = missTxt.y + 26;
		accuracyTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT);
		accuracyTxt.setBorderStyle(OUTLINE, 0xFF000000, 3, 1);
		accuracyTxt.scrollFactor.set();
		add(accuracyTxt);
		accuracyTxt.visible = _variables.accuracyDisplay;

		npsTxt = new FlxText(accuracyTxt.x, accuracyTxt.y - 26, 0, "", 20);
		if (_variables.scroll == "down")
			npsTxt.y = accuracyTxt.y + 26;
		npsTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT);
		npsTxt.setBorderStyle(OUTLINE, 0xFF000000, 3, 1);
		npsTxt.scrollFactor.set();
		add(npsTxt);
		npsTxt.visible = _variables.nps;

		scoreTxt.text = "Score: " + songScore;
		missTxt.text = "Misses: " + misses;
		accuracyTxt.text = "Accuracy: " + truncateFloat(accuracy, 2) + "%";

		if (gameplayArea == "Survival")
		{
			survivalCountdown = new FlxText(0, 0, "", 20);
			survivalCountdown.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER);
			survivalCountdown.setBorderStyle(OUTLINE, 0xFF000000, 3, 1);
			survivalCountdown.scrollFactor.set();

			survivalCountdown.y = 80;
			if (_variables.scroll == "down")
				survivalCountdown.y = 640;

			add(survivalCountdown);

			survivalCountdown.x = FlxG.width / 2 - survivalCountdown.width / 2;
		}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		iconP1.visible = _variables.hpIcons;
		iconP2.visible = _variables.hpIcons;
		iconP1.animation.curAnim.curFrame = 0;
		iconP2.animation.curAnim.curFrame = 0;

		var colorBar1:FlxColor = 0xFF66FF33;
		var colorBar2:FlxColor = 0xFFFF0000;

		if (_variables.hpColors)
		{
			if (!iconP1.usingFallback)
				colorBar1 = dominantColor(iconP1);

			if (!iconP2.usingFallback) 
				colorBar2 = dominantColor(iconP2);
		}

		healthBar.createFilledBar(colorBar2, colorBar1);

		hearts = new FlxTypedGroup<FlxSprite>();
		add(hearts);

		if (_modifiers.Enigma || (_variables.chromakey && _variables.healthbarvis))
		{
			iconP1.visible = false;
			iconP2.visible = false;
			healthBar.visible = false;
			healthBarBG.visible = false;
			hearts.visible = false;
		}

		var heartTex = Paths.getSparrowAtlas('heartUI', 'shared');
		switch (curStage)
		{
			case 'school' | 'schoolEvil':
				heartTex = Paths.getSparrowAtlas('weeb/pixelUI/heartUI-pixel', 'week6');
		}

		for (i in 0...Std.int(_modifiers.Lives))
		{
			heartSprite = new FlxSprite(healthBarBG.x + 5 + (i * 40), 20);
			heartSprite.frames = heartTex;
			heartSprite.antialiasing = false;
			heartSprite.updateHitbox();
			heartSprite.y = healthBarBG.y + healthBarBG.height + 10;
			heartSprite.scrollFactor.set();
			heartSprite.animation.addByPrefix('Idle', "Hearts", 24, false);
			heartSprite.ID = i;
			if (_variables.scroll == "down")
				heartSprite.y = healthBarBG.y - heartSprite.height - 10;
			if (!_modifiers.LivesSwitch)
				heartSprite.visible = false;

			hearts.add(heartSprite);
		}

		freezeIndicator = new FlxSprite(0, 0).loadGraphic(Paths.image('FreezeIndicator', 'shared'));
		add(freezeIndicator);
		switch (curStage)
		{
			case 'school' | 'schoolEvil':
				freezeIndicator.loadGraphic(Paths.image('weeb/pixelUI/FreezeIndicator-pixel', 'week6'));
		}
		freezeIndicator.alpha = 0;

		LightsOutBG = new FlxSprite(0, 0).loadGraphic(Paths.image('LightsOutBG', 'shared'));
		add(LightsOutBG);
		switch (curStage)
		{
			case 'school' | 'schoolEvil':
				LightsOutBG.loadGraphic(Paths.image('weeb/pixelUI/LightsOutBG-pixel', 'week6'));
		}

		BlindingBG = new FlxSprite(0, 0).loadGraphic(Paths.image('BlindingBG', 'shared'));
		add(BlindingBG);
		switch (curStage)
		{
			case 'school' | 'schoolEvil':
				BlindingBG.loadGraphic(Paths.image('weeb/pixelUI/BlindingBG-pixel', 'week6'));
		}
		if (_modifiers.BrightnessSwitch)
		{
			LightsOutBG.alpha = _modifiers.Brightness / 100 * -1;
			BlindingBG.alpha = _modifiers.Brightness / 100;
		}
		else
		{
			LightsOutBG.alpha = 0;
			BlindingBG.alpha = 0;
		}

		strumLineNotes.cameras = [camNOTEHUD];
		notes.cameras = [camNOTES];
		hearts.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		botPlay.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		missTxt.cameras = [camHUD];
		accuracyTxt.cameras = [camHUD];
		npsTxt.cameras = [camHUD];

		if (gameplayArea == "Survival")
			survivalCountdown.cameras = [camHUD];

		doof.cameras = [camPAUSE];
		freezeIndicator.cameras = [camPAUSE];
		LightsOutBG.cameras = [camPAUSE];
		BlindingBG.cameras = [camPAUSE];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (gameplayArea == "Story" && _variables.cutscene)
		{
			switch (curSong.toLowerCase())
			{
				case "winter horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On', 'shared'), _variables.svolume / 100);
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									dialogueOrCountdown();
								}
							});
						});
					});
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY', 'shared'), _variables.svolume / 100);
					FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX', 'shared'), _variables.svolume / 100);
					dialogueOrCountdown();
				default:
					dialogueOrCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		var blackness:FlxSprite = new FlxSprite(-500, -500).makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
		blackness.scrollFactor.set();
		add(blackness);
		blackness.alpha = 1 - _variables.bgAlpha;

		super.create();
	}

	function dialogueOrCountdown():Void
	{
		if (dialogue == null)
			startCountdown();
		else
		{
			if (_variables.skipCS == -1 || (_variables.skipCS > -1 && curDeaths < _variables.skipCS))
				schoolIntro(doof);
			else if (_variables.skipCS > -1 && curDeaths >= _variables.skipCS)
				startCountdown();
		}
	}

	function modifierValues():Void
	{
		if (_modifiers.LivesSwitch)
			lives = _modifiers.Lives;

		if (_modifiers.StartHealthSwitch)
			health = 1 + _modifiers.StartHealth / 100;

		if (_modifiers.HitZonesSwitch)
		{
			Conductor.safeFrames = Std.int(13 + _modifiers.HitZones);
			Conductor.safeZoneOffset = (Conductor.safeFrames / 60) * 1000;
			Conductor.timeScale = Conductor.safeZoneOffset / 166;
		}
		else
		{
			Conductor.safeFrames = 13; // why tf did i forget this
			Conductor.safeZoneOffset = (Conductor.safeFrames / 60) * 1000;
			Conductor.timeScale = Conductor.safeZoneOffset / 166;
		}

		if (_modifiers.Mirror)
		{
			camGame.flashSprite.scaleX *= -1;
			camNOTEHUD.flashSprite.scaleX *= -1;
			camSus.flashSprite.scaleX *= -1;
			camNOTES.flashSprite.scaleX *= -1;
			camHUD.flashSprite.scaleX *= -1;
		}

		if (_modifiers.UpsideDown)
		{
			camGame.flashSprite.scaleY *= -1;
			camNOTEHUD.flashSprite.scaleY *= -1;
			camSus.flashSprite.scaleY *= -1;
			camNOTES.flashSprite.scaleY *= -1;
			camHUD.flashSprite.scaleY *= -1;
		}
	}

	function updateAccuracy()
	{
		if (!cheated)
		{
			totalPlayed += 1;
			accuracy = totalNotesHit / totalPlayed * 100;
			if (accuracy >= 100.00)
			{
				if (misses == 0)
					accuracy = 100.00;
				else
				{
					accuracy = 99.98;
				}
			}
		}
		else
		{
			accuracy = 0;
			misses = 999;
		}

		accuracyTxt.text = "Accuracy: " + truncateFloat(accuracy, 2) + "%";
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		beginCutscene = true;

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy', 'week6');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns' || SONG.song.toLowerCase() == 'winter horrorland')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies', 'shared'), _variables.svolume / 100, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;
		beginCutscene = false;

		if (gameplayArea != "Endless" || (gameplayArea == "Endless" && loops == 0))
		{
			if (_variables.fiveK)
			{
				if (_variables.scroll != 'left' && _variables.scroll != 'right')
					generateStaticArrows5(0);
				generateStaticArrows5(1);
				// i am going to murder someone
				// - haya
				for (item in strumLineNotes.members)
				{
					item.x -= 50;
				}
				if (FileSystem.exists('assets/data/' + SONG.song.toLowerCase() + '/scripts/chart.hx'))
				{
					modState.set("strum0", strumLineNotes.members[0]);
					modState.set("strum1", strumLineNotes.members[1]);
					modState.set("strum2", strumLineNotes.members[2]);
					modState.set("strum3", strumLineNotes.members[3]);
					modState.set("strum4", strumLineNotes.members[4]);
					modState.set("strum5", strumLineNotes.members[5]);
					modState.set("strum6", strumLineNotes.members[6]);
					modState.set("strum7", strumLineNotes.members[7]);
					modState.set("strum8", strumLineNotes.members[8]);
					modState.set("strum9", strumLineNotes.members[9]);
					hscript();
					if (FileSystem.exists('assets/data/' + SONG.song.toLowerCase() + '/scripts/start.hx'))
						loadStartScript();
					trace('SOME MODIFIERS ARE DISABLED! THEY WONT WORK PROPERLY WITH MODCHARTS');
				}
			}
			else
			{
				if (_variables.scroll != 'left' && _variables.scroll != 'right')
					generateStaticArrows(0);
				generateStaticArrows(1);
				if (FileSystem.exists('assets/data/' + SONG.song.toLowerCase() + '/scripts/chart.hx'))
				{
					modState.set("strum0", strumLineNotes.members[0]);
					modState.set("strum1", strumLineNotes.members[1]);
					modState.set("strum2", strumLineNotes.members[2]);
					modState.set("strum3", strumLineNotes.members[3]);
					modState.set("strum4", strumLineNotes.members[4]);
					modState.set("strum5", strumLineNotes.members[5]);
					modState.set("strum6", strumLineNotes.members[6]);
					modState.set("strum7", strumLineNotes.members[7]);
					hscript();
					if (FileSystem.exists('assets/data/' + SONG.song.toLowerCase() + '/scripts/start.hx'))
						loadStartScript();
					trace('SOME MODIFIERS ARE DISABLED! THEY WONT WORK PROPERLY WITH MODCHARTS');
				}
			}
		}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			iconP1.setGraphicSize(Std.int(iconP1.width + 30));
			dad.dance();
			gf.dance();
			if (!frozen)
			{
				boyfriend.playAnim('idle');
				if (_modifiers.FrightSwitch)
				{
					if (_modifiers.Fright >= 50 && _modifiers.Fright < 100)
							boyfriend.playAnim('scared');
					else if (_modifiers.Fright >= 100)
					{
						if (boyfriend.animation.getByName('worried') != null)
							boyfriend.playAnim('worried');
						else
							boyfriend.playAnim('idle');
					}
				}
			}
			else
			{
				if (boyfriend.animation.getByName('frozen') != null)
					boyfriend.playAnim('frozen');
				else
				{
					boyfriend.playAnim('idle');
					boyfriend.animation.curAnim.frameRate = 0;
					boyfriend.color = 0xFF00D0FF;
				}
			}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix, 'shared'), 0.6 * _variables.svolume / 100);

					new FlxTimer().start(0.03, function(tmr:FlxTimer)
					{
						camHUD.alpha += 1 / 6;
						camNOTES.alpha += 1 / 6;
						camSus.alpha += 1 / 6;
						camNOTEHUD.alpha += 1 / 6;
					}, 10);
				case 1:
					var ready:FlxSprite = new FlxSprite();
					ready.cameras = [camHUD];
					if (introAlts[0] == 'ready')
						ready.loadGraphic(Paths.image(introAlts[0], 'shared'));
					else
						ready.loadGraphic(Paths.image(introAlts[0], 'week6'));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix, 'shared'), 0.6 * _variables.svolume / 100);
				case 2:
					var set:FlxSprite = new FlxSprite();
					set.cameras = [camHUD];
					if (introAlts[1] == 'set')
						set.loadGraphic(Paths.image(introAlts[1], 'shared'));
					else
						set.loadGraphic(Paths.image(introAlts[1], 'week6'));

					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix, 'shared'), 0.6 * _variables.svolume / 100);
				case 3:
					var go:FlxSprite = new FlxSprite();
					go.cameras = [camHUD];
					if (introAlts[2] == 'go')
						go.loadGraphic(Paths.image(introAlts[2], 'shared'));
					else
						go.loadGraphic(Paths.image(introAlts[2], 'week6'));

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.scrollFactor.set();

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix, 'shared'), 0.6 * _variables.svolume / 100);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			if (_modifiers.VibeSwitch)
			{
				switch (_modifiers.Vibe)
				{
					case 0.8:
						FlxG.sound.playMusic(Paths.instHIFI(PlayState.SONG.song), _variables.mvolume / 100, false);
					case 1.2:
						FlxG.sound.playMusic(Paths.instLOFI(PlayState.SONG.song), _variables.mvolume / 100, false);
					default:
						FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), _variables.mvolume / 100, false);
				}
			}
			else
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), _variables.mvolume / 100, false);

			if (gameplayArea == "Survival")
			{
				if (timeLeftOver == 0 || timeLeftOver > 0 && _survivalVars.addSongTimeToCurrentTime)
				survivalTimer += FlxG.sound.music.length * (_survivalVars.timePercentage / 100);

				survivalCountdown.x = FlxG.width / 2 - survivalCountdown.width / 2;

				FlxTween.color(survivalCountdown, 0.2, FlxColor.GREEN, FlxColor.WHITE, {
					ease: FlxEase.quadInOut
				});
			}
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();
		loopB = FlxG.sound.music.length - 100;

		if (_modifiers.OffbeatSwitch)
			vocals.time = Conductor.songPosition + (512 * _modifiers.Offbeat / 100);

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (_variables.songPosition) // I dont wanna talk about this code :(
		{
			songPosBar.setRange(0, songLength - 100);
			songPosBar.numDivisions = 1000;
		}

		// Song check real quick
		switch (curSong.toLowerCase())
		{
			case 'bopeebo' | 'philly nice' | 'blammed' | 'cocoa' | 'eggnog':
				allowedToHeadbang = true;
			default:
				allowedToHeadbang = false;
		}

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
	}

	var debugNum:Int = 0;
	var stair:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;

		Conductor.changeBPM(songData.bpm);

		if (_modifiers.VibeSwitch)
		{
			switch (_modifiers.Vibe)
			{
				case 0.8:
					Conductor.changeBPM(songData.bpm * 1.2);
				case 1.2:
					Conductor.changeBPM(songData.bpm * 0.8);
			}
		}

		curSong = songData.song;

		if (SONG.needsVoices)
			if (_modifiers.VibeSwitch)
			{
				switch (_modifiers.Vibe)
				{
					case 0.8:
						vocals = new FlxSound().loadEmbedded(Paths.voicesHIFI(PlayState.SONG.song));
					case 1.2:
						vocals = new FlxSound().loadEmbedded(Paths.voicesLOFI(PlayState.SONG.song));
					default:
						vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				}
			}
			else
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		var random = null;
		if (chartType == "chaos")
		{
			random = new Random(null, new seedyrng.Xorshift64Plus());
			if (FlxG.random.bool(50))
			{
				if (FlxG.random.bool(50))
				{
					var seed = FlxG.random.int(1000000, 9999999); // seed in string numbers
					FlxG.log.add('SEED (STRING): ' + seed);
					random.setStringSeed(Std.string(seed));
				}
				else
				{
					var seed = Random.Random.string(7);
					FlxG.log.add('SEED (STRING): ' + seed); // seed in string (alphabet edition)
					random.setStringSeed(seed);
				}
			}
			else
			{
				var seed = FlxG.random.int(1000000, 9999999); // seed in int
				FlxG.log.add('SEED (INT): ' + seed);
				random.seed = seed;
			}
		}

		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			// I don't know why, I don't want to wonder why,
			// but i have no idea what better way I can do this cos I fucking hate it.
			if (section.sectionSpeed < 1 || Math.isNaN(section.sectionSpeed))
			{
				// This is a terrible way of doing this!
				section.sectionSpeed = SONG.speed;

				var json:Dynamic = {
					"song": SONG
				}

				var data:String = haxe.Json.stringify(json, null, '    ');

				if ((data != null) && (data.length > 0))
				{
					File.saveContent('assets/data/' + SONG.song.toLowerCase() + "/" + SONG.song.toLowerCase() + "-"
						+ CoolUtil.difficultyString().toLowerCase() + ".json",
						data);
					PlayState.SONG = Song.loadFromJson(SONG.song + "-" + CoolUtil.difficultyString().toLowerCase(), SONG.song);
					FlxG.log.add('RELOADING JSON: ' + SONG.song + "-" + CoolUtil.difficultyString().toLowerCase());
					generateSong(SONG.song);
					break;
				}
			}

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 5);

				if (songNotes[3] == null)
					songNotes[3] = false;

				var noteType:String = songNotes[3];
				var isRoll:Bool = songNotes[4];

				var gottaHitNote:Bool = section.mustHitSection;

				if (_modifiers.OffbeatSwitch)
				{
					offbeatValue = 512 * _modifiers.Offbeat / 100;
				}

				if (_modifiers.VibeSwitch)
				{
					switch (_modifiers.Vibe)
					{
						case 0.8:
							daStrumTime = (daStrumTime + _variables.noteOffset + offbeatValue) * 0.8332; // somewhere around 0.832
						case 1.2:
							daStrumTime = (daStrumTime + _variables.noteOffset + offbeatValue) * 1.25;
						default:
							daStrumTime = daStrumTime + _variables.noteOffset + offbeatValue;
					}
				}
				else
					daStrumTime = daStrumTime + _variables.noteOffset + offbeatValue;

				if (songNotes[1] > 3 && !_variables.fiveK || songNotes[1] > 4 && _variables.fiveK)
				{
					gottaHitNote = !section.mustHitSection;
				}

				switch (chartType)
				{
					case "standard":
						if (_variables.fiveK)
							daNoteData = Std.int(songNotes[1] % 5);
						else
							daNoteData = Std.int(songNotes[1] % 4);
					case "flip":
						if (gottaHitNote)
						{
							// B-SIDE FLIP???? Rozebud be damned lmao
							if (_variables.fiveK)
								daNoteData = 4 - Std.int(songNotes[1] % 5);
							else
								daNoteData = 3 - Std.int(songNotes[1] % 4);
						}

					case "chaos":
						if (_variables.fiveK)
						{
							daNoteData = random.randomInt(0, 4);
						}
						else
						{
							daNoteData = random.randomInt(0, 3);
						}

					case "onearrow":
						daNoteData = arrowLane;
					case "stair":
						if (_variables.fiveK)
							daNoteData = stair % 5;
						else
							daNoteData = stair % 4;
						stair++;
					case "dualarrow":
						switch (stair)
						{
							case 0:
								daNoteData = arrowLane;
								stair = 1;
							case 1:
								daNoteData = arrowLane2;
								stair = 0;
						}
					case "dualchaos":
						if (FlxG.random.bool(50))
							daNoteData = arrowLane;
						else
							daNoteData = arrowLane2;
					case "wave":
						if (_variables.fiveK)
						{
							switch (stair % 8)
							{
								case 0 | 1 | 2 | 3 | 4:
									daNoteData = stair % 8;
								case 5:
									daNoteData = 3;
								case 6:
									daNoteData = 2;
								case 7:
									daNoteData = 1;
							}
						}
						else
						{
							switch (stair % 6)
							{
								case 0 | 1 | 2 | 3:
									daNoteData = stair % 6;
								case 4:
									daNoteData = 2;
								case 5:
									daNoteData = 1;
							}
						}

						stair++;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, noteType, false);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				if (_modifiers.WidenSwitch)
					swagNote.scale.x *= _modifiers.Widen / 100 + 1;
				if (_modifiers.StretchSwitch && !swagNote.isSustainNote)
					swagNote.scale.y *= _modifiers.Stretch / 100 + 1;

				var susLength:Float = swagNote.sustainLength;

				if (_modifiers.EelNotesSwitch)
					susLength += 10 * _modifiers.EelNotes;

				if (_modifiers.VibeSwitch)
				{
					switch (_modifiers.Vibe)
					{
						case 0.8:
							susLength = susLength / Conductor.stepCrochet * 0.8338 / speedNote; // somewhere around 0.832
						case 1.2:
							susLength = susLength / Conductor.stepCrochet * 1.25 / speedNote;
						default:
							susLength = susLength / Conductor.stepCrochet / speedNote;
					}
				}
				else
					susLength = susLength / Conductor.stepCrochet / speedNote;

				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
					noteType, isRoll);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress && (_variables.scroll != 'left' && _variables.scroll != 'right'))
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}

					if (_variables.fiveK)
						sustainNote.x -= 50;

					if (_variables.scroll == 'left' || _variables.scroll == 'right')
					{
						sustainNote.x += FlxG.width / 4 + 50;
						if (!sustainNote.mustPress)
							sustainNote.alpha *= _variables.enemyAlpha;
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress && (_variables.scroll != 'left' && _variables.scroll != 'right'))
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}

				var jackNote:Note;

				if (_modifiers.JacktasticSwitch)
				{
					for (i in 0...Std.int(_modifiers.Jacktastic))
					{
						jackNote = new Note(swagNote.strumTime + 70 * (i + 1), swagNote.noteData, oldNote, false, swagNote.noteVariant, false);
						jackNote.scrollFactor.set(0, 0);

						if (_modifiers.WidenSwitch)
							jackNote.scale.x *= _modifiers.Widen / 100 + 1;
						if (_modifiers.StretchSwitch)
							jackNote.scale.y *= _modifiers.Stretch / 100 + 1;

						unspawnNotes.push(jackNote);

						jackNote.mustPress = swagNote.mustPress;

						if (jackNote.mustPress && (_variables.scroll != 'left' && _variables.scroll != 'right'))
						{
							jackNote.x += FlxG.width / 2; // general offset
						}

						if (_variables.fiveK)
							jackNote.x -= 50;

						if (_variables.scroll == 'left' || _variables.scroll == 'right')
						{
							jackNote.x += FlxG.width / 4 + 50;
							if (!jackNote.mustPress)
								jackNote.alpha *= _variables.enemyAlpha;
						}
					}
				}

				if (_variables.fiveK)
					swagNote.x -= 50;

				if (_variables.scroll == 'left' || _variables.scroll == 'right')
				{
					swagNote.x += FlxG.width / 4 + 50;
					if (!swagNote.mustPress)
						swagNote.alpha *= _variables.enemyAlpha;
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		allNotes = deepCopyNotes(unspawnNotes);

		generatedMusic = true;
	}

	function deepCopyNotes(noteArray:Array<Note>, ?startingpoint:Float = 0):Array<Note>
	{
		var noteRef:Note = null;
		var newNoteArray:Array<Note> = [];

		for (note in noteArray)
		{
			if (note.strumTime > startingpoint)
			{
				noteRef = newNoteArray.length > 0 ? newNoteArray[newNoteArray.length - 1] : null;
				var deepCopy:Note = new Note(note.strumTime, note.noteData, noteRef, note.isSustainNote, note.noteVariant, note.isRoll);
				deepCopy.mustPress = note.mustPress;
				deepCopy.x = note.x;
				newNoteArray.push(deepCopy);
			}
		}
		return newNoteArray;
	}

	function loopHandler(abLoop:Bool):LoopState
	{
		FlxG.log.add("Made it" + abLoop);

		if (abLoop)
		{
			switch (loopState)
			{
				case REPEAT | NONE:
					if (!startingSong)
						loopA = Conductor.songPosition;
					else
						loopA = 0;
					loopState = ANODE;
					FlxG.log.add("Setting A Node");
				case ANODE:
					loopB = Conductor.songPosition;
					loopState = ABREPEAT;
					FlxG.log.add("Setting B Node");
				case ABREPEAT:
					loopState = NONE;
					FlxG.log.add("Removing Nodes");
			}
		}
		else
		{
			switch (loopState)
			{
				case NONE | ABREPEAT:
					loopA = 0;
					loopB = FlxG.sound.music.length - 100;
					loopState = REPEAT;
					FlxG.log.add("Looping Entire Song");
				case REPEAT | ANODE:
					loopState = NONE;
					FlxG.log.add("No longer Looping");
			}
		}
		return loopState;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	var noteOutput:Float = 0;

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSkewedSprite = new FlxSkewedSprite(0, strumLine.y);

			if (_modifiers.FlippedNotes)
				noteOutput = Math.abs(3 - i);
			else
				noteOutput = Math.abs(i);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels', 'week6'), true, 17, 17);
					babyArrow.animation.add('green', [7]);
					babyArrow.animation.add('red', [8]);
					babyArrow.animation.add('blue', [6]);
					babyArrow.animation.add('purplel', [5]);
					babyArrow.animation.add('yellow', [9]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (noteOutput)
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [5, 10], 12, false);
							babyArrow.animation.add('confirm', [15, 20, 20, 20, 20], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [6, 11], 12, false);
							babyArrow.animation.add('confirm', [16, 21, 21, 21, 21], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [7, 12], 12, false);
							babyArrow.animation.add('confirm', [17, 22, 22, 22, 22], 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [8, 13], 12, false);
							babyArrow.animation.add('confirm', [18, 23, 23, 23, 23], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (noteOutput)
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'left confirm', [0, 1, 2, 3, 3, 3, 3], "", 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'down confirm', [0, 1, 2, 3, 3, 3, 3], "", 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'up confirm', [0, 1, 2, 3, 3, 3, 3], "", 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'right confirm', [0, 1, 2, 3, 3, 3, 3], "", 24, false);
					}
			}

			if (_variables.scroll == "down")
				babyArrow.flipY = true;

			if (_variables.scroll == "right")
				babyArrow.flipX = true;

			if (_modifiers.FlippedNotes)
			{
				babyArrow.flipX = !babyArrow.flipX;
				babyArrow.flipY = !babyArrow.flipY;
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.ID = i;
			babyArrow.cameras = [camNOTEHUD];

			switch (player)
			{
				case 0:
					{
						player2Strums.add(babyArrow);
					}
				case 1:
					{
						playerStrums.add(babyArrow);
					}
			}

			if (_variables.scroll == "left")
				babyArrow.angle += 90;
			else if (_variables.scroll == "right")
				babyArrow.angle += 90;

			babyArrow.animation.play('static');
			babyArrow.x += 95;
			if (_variables.scroll != 'left' && _variables.scroll != 'right')
				babyArrow.x += ((FlxG.width / 2) * player);
			else
				babyArrow.x += FlxG.width / 4 + 50;

			strumLineNotes.add(babyArrow);
		}
	}

	private function generateStaticArrows5(player:Int):Void
	{
		for (i in 0...5)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSkewedSprite = new FlxSkewedSprite(0, strumLine.y);

			if (_modifiers.FlippedNotes)
				noteOutput = Math.abs(4 - i);
			else
				noteOutput = Math.abs(i);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels', 'week6'), true, 17, 17);
					babyArrow.animation.add('green', [7]);
					babyArrow.animation.add('red', [8]);
					babyArrow.animation.add('blue', [6]);
					babyArrow.animation.add('purplel', [5]);
					babyArrow.animation.add('yellow', [9]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (noteOutput)
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [5, 10], 12, false);
							babyArrow.animation.add('confirm', [15, 20, 20, 20, 20], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [6, 11], 12, false);
							babyArrow.animation.add('confirm', [16, 21, 21, 21, 21], 24, false);
						case 4:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [4]);
							babyArrow.animation.add('pressed', [9, 14], 12, false);
							babyArrow.animation.add('confirm', [19, 24, 24, 24, 24], 12, false);
						case 2:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [7, 12], 12, false);
							babyArrow.animation.add('confirm', [17, 22, 22, 22, 22], 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 4;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [8, 13], 12, false);
							babyArrow.animation.add('confirm', [18, 23, 23, 23, 23], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
					babyArrow.animation.addByPrefix('yellow', 'arrowCENTER');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (noteOutput)
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'left confirm', [0, 1, 2, 3, 3, 3, 3], "", 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'down confirm', [0, 1, 2, 3, 3, 3, 3], "", 24, false);
						case 4:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowCENTER');
							babyArrow.animation.addByPrefix('pressed', 'center press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'center confirm', [0, 1, 2, 3, 3, 3, 3], "", 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'up confirm', [0, 1, 2, 3, 3, 3, 3], "", 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 4;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByIndices('confirm', 'right confirm', [0, 1, 2, 3, 3, 3, 3], "", 24, false);
					}
			}

			if (_variables.scroll == "down")
				babyArrow.flipY = true;

			if (_variables.scroll == "right")
				babyArrow.flipX = true;

			if (_modifiers.FlippedNotes)
			{
				babyArrow.flipX = !babyArrow.flipX;
				babyArrow.flipY = !babyArrow.flipY;
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.ID = i;
			babyArrow.cameras = [camNOTEHUD];

			switch (player)
			{
				case 0:
					{
						player2Strums.add(babyArrow);
					}
				case 1:
					{
						playerStrums.add(babyArrow);
					}
			}

			if (_variables.scroll == "left")
				babyArrow.angle += 90;
			else if (_variables.scroll == "right")
				babyArrow.angle += 90;

			babyArrow.animation.play('static');
			babyArrow.x += 95;
			if (_variables.scroll != 'left' && _variables.scroll != 'right')
				babyArrow.x += ((FlxG.width / 2) * player);
			else
				babyArrow.x += FlxG.width / 4 + 50;

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.3}, (Conductor.stepCrochet / 1000 * 4), {ease: FlxEase.quadInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		if (health > -0.1 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		if (health > -0.00001 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);

			if (!ended && !died && startedCountdown && canPause && _variables.autoPause)
			{
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, loopHandler.bind(_), loopState));
			}
		}

		super.onFocusLost();
	}

	function resyncVocals(alt:Bool = false):Void
	{
		if (!alt)
		{
			vocals.pause();

			FlxG.sound.music.play();
			Conductor.songPosition = FlxG.sound.music.time;
			if (_modifiers.OffbeatSwitch)
			{
				vocals.time = Conductor.songPosition + (512 * _modifiers.Offbeat / 100);
			}
			else
				vocals.time = Conductor.songPosition;

			vocals.play();
		}
		else
		{
			FlxG.sound.music.play();
			Conductor.songPosition = FlxG.sound.music.time;
			if (_modifiers.OffbeatSwitch)
			{
				vocals.time = Conductor.songPosition + (512 * _modifiers.Offbeat / 100);
			}
			else
				vocals.time = Conductor.songPosition;
		}
	}

	public var paused:Bool = false;

	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Float):Float
	{
		var realNum:Float = number;
		realNum = realNum * Math.pow(10, precision);
		realNum = Math.round(realNum) / Math.pow(10, precision);
		return realNum;
	}

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (startedCountdown)
		{
			if (_modifiers.EarthquakeSwitch)
				FlxG.cameras.shake(_modifiers.Earthquake / 2000, 0.2);

			if (_modifiers.LoveSwitch)
				health += _modifiers.Love / 600000;

			if (_modifiers.FrightSwitch)
				health -= _modifiers.Fright / 700000;

			if (_modifiers.PaparazziSwitch && paparazziInt == 0)
			{
				paparazziInt = 1;
				new FlxTimer().start(FlxG.random.float(2 / _modifiers.Paparazzi, 6 / _modifiers.Paparazzi), function(tmr:FlxTimer)
				{
					camHUD.flash(0xFFFFFFFF, FlxG.random.float(0.1, 0.3), null, true);
					FlxG.sound.play(Paths.sound('paparazzi', 'shared'), FlxG.random.float(0.1, 0.3) * _variables.svolume / 100);
					paparazziInt = 0;
				});
			}

			if (_modifiers.SeasickSwitch)
			{
				FlxG.camera.angle += Math.sin(Conductor.songPosition * Conductor.bpm / 100 / 500) * (0.008 * _modifiers.Seasick);
				camHUD.angle += Math.cos(Conductor.songPosition * Conductor.bpm / 100 / 500) * (0.008 * _modifiers.Seasick);
				camNOTES.angle += Math.cos(Conductor.songPosition * Conductor.bpm / 100 / 500) * (0.008 * _modifiers.Seasick);
				camSus.angle += Math.cos(Conductor.songPosition * Conductor.bpm / 100 / 500) * (0.008 * _modifiers.Seasick);
				camNOTEHUD.angle += Math.cos(Conductor.songPosition * Conductor.bpm / 100 / 500) * (0.008 * _modifiers.Seasick);
			}

			if (_modifiers.CameraSwitch)
			{
				FlxG.camera.angle += 0.01 * _modifiers.Camera;
				camHUD.angle -= 0.01 * _modifiers.Camera;
				camNOTES.angle -= 0.01 * _modifiers.Camera;
				camSus.angle -= 0.01 * _modifiers.Camera;
				camNOTEHUD.angle -= 0.01 * _modifiers.Camera;
			}
		}

		cameraX = camFollow.x;
		cameraY = camFollow.y;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		if (FlxG.keys.justPressed.F8)
		{
			_variables.botplay = !_variables.botplay;
			botPlay.visible = _variables.botplay;
			MainVariables.Save();
		}

		if (!_variables.chromakey && !_variables.healthbarvis)
		{
			iconP1.visible = !botPlay.visible;
			iconP2.visible = !botPlay.visible;
		}

		if (currentFrames == _variables.fps && _variables.nps)
		{
			for (i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
						notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);
			currentFrames = 0;
		}
		else if (currentFrames != _variables.fps)
			currentFrames++;
		else if (!_variables.nps)
			nps = 0; // shut up

		/**
		 * it lags a lil so its only if you dont have a choice
		**/
		if (FileSystem.exists('assets/data/' + SONG.song.toLowerCase() + '/scripts/chart.hx') && startedCountdown)
		{
			loadScript();
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24 && !_variables.chromakey)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
			case 'schoolEvil':
				Application.current.window.title = randString(FlxG.random.int(8, 16));
				Application.current.window.x += FlxG.random.int(-1, 1);
				Application.current.window.y += FlxG.random.int(-1, 1);
		}

		super.update(elapsed);

		wiggleShit.waveAmplitude = FlxMath.lerp(wiggleShit.waveAmplitude, 0, 0.035 / (_variables.fps / 60));
		wiggleShit.waveFrequency = FlxMath.lerp(wiggleShit.waveFrequency, 0, 0.035 / (_variables.fps / 60));

		wiggleShit.update(elapsed);

		npsTxt.text = "NPS: " + nps;

		if (gameplayArea == "Survival")
		{
			seconds = Std.int(survivalTimer / 1000);

			survivalCountdown.text = '$seconds';
		}

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
			{
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, loopHandler.bind(_), loopState));
			}

			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			canDie = false;
			FlxG.switchState(new ChartingState());
			curDeaths = 0;
			var image = lime.graphics.Image.fromFile('assets/images/iconOG.png');
			lime.app.Application.current.window.setIcon(image);
			Application.current.window.title = Application.current.meta.get('name');

			DiscordClient.changePresence("Charting a song", null, null, true);
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, zoomLerp / (_variables.fps / 60))));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, zoomLerp / (_variables.fps / 60))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (_variables.hpAnims)
		{
			if (healthBar.percent < 20)
				iconP1.animation.curAnim.curFrame = 1;
			else if (healthBar.percent > 80)
				iconP1.animation.curAnim.curFrame = 2;
			else
				iconP1.animation.curAnim.curFrame = 0;

			if (healthBar.percent > 80)
				iconP2.animation.curAnim.curFrame = 1;
			else if (healthBar.percent < 20)
				iconP2.animation.curAnim.curFrame = 2;
			else
				iconP2.animation.curAnim.curFrame = 0;
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			if (gameplayArea == "Survival" && !ended)
			{
				survivalTimer -= FlxG.elapsed * 1000;
				FlxG.watch.addQuick('Survival Timer', survivalTimer);
			}
			FlxG.watch.addQuick("songPosition", Conductor.songPosition);
			if (loopState != NONE && Conductor.songPosition >= loopB)
			{
				Conductor.songPosition = loopA;
				FlxG.sound.music.time = loopA;
				resyncVocals();
				unspawnNotes = deepCopyNotes(allNotes, loopA);
				songScore = 0;
				combo = 0;

				updateScoreText();
			}

			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if (allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if (gf.animation.curAnim.name == 'danceLeft'
					|| gf.animation.curAnim.name == 'danceRight'
					|| gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch (curSong.toLowerCase())
					{
						case 'philly nice':
							{
								// General duration of the song
								if (curBeat < 250)
								{
									// Beats to skip or to stop GF from cheering
									if (curBeat != 184 && curBeat != 216)
									{
										if (curBeat % 16 == 8)
										{
											// Just a garantee that it'll trigger just once
											if (!triggeredAlready)
											{
												gf.playAnim('cheer');
												triggeredAlready = true;
											}
										}
										else
											triggeredAlready = false;
									}
								}
							}
						case 'bopeebo':
							{
								// Where it starts || where it ends
								if (curBeat > 5 && curBeat < 130)
								{
									if (curBeat % 8 == 7)
									{
										if (!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}
									else
										triggeredAlready = false;
								}
							}
						case 'blammed':
							{
								if (curBeat > 30 && curBeat < 190)
								{
									if (curBeat < 90 || curBeat > 128)
									{
										if (curBeat % 4 == 2)
										{
											if (!triggeredAlready)
											{
												gf.playAnim('cheer');
												triggeredAlready = true;
											}
										}
										else
											triggeredAlready = false;
									}
								}
							}
						case 'cocoa':
							{
								if (curBeat < 170)
								{
									if (curBeat < 65 || curBeat > 130 && curBeat < 145)
									{
										if (curBeat % 16 == 15)
										{
											if (!triggeredAlready)
											{
												gf.playAnim('cheer');
												triggeredAlready = true;
											}
										}
										else
											triggeredAlready = false;
									}
								}
							}
						case 'eggnog':
							{
								if (curBeat > 10 && curBeat != 111 && curBeat < 220)
								{
									if (curBeat % 8 == 7)
									{
										if (!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}
									else
										triggeredAlready = false;
								}
							}
					}
				}
			}
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.x = FlxMath.lerp(camFollow.x, dad.getMidpoint().x + 150, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
				camFollow.y = FlxMath.lerp(camFollow.y, dad.getMidpoint().y - 100, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = FlxMath.lerp(camFollow.y, dad.getMidpoint().y, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
					case 'senpai' | 'senpai-angry':
						camFollow.x = FlxMath.lerp(camFollow.x, dad.getMidpoint().x - 190, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
						camFollow.y = FlxMath.lerp(camFollow.y, dad.getMidpoint().y - 830, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = _variables.vvolume / 100;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.x = FlxMath.lerp(camFollow.x, boyfriend.getMidpoint().x - 100, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
				camFollow.y = FlxMath.lerp(camFollow.y, boyfriend.getMidpoint().y - 100, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));

				switch (curStage)
				{
					case 'limo':
						camFollow.x = FlxMath.lerp(camFollow.x, boyfriend.getMidpoint().x - 300, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
					case 'mall':
						camFollow.y = FlxMath.lerp(camFollow.y, boyfriend.getMidpoint().y - 200, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
					case 'school' | 'schoolEvil':
						camFollow.x = FlxMath.lerp(camFollow.x, boyfriend.getMidpoint().x - 300, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
						camFollow.y = FlxMath.lerp(camFollow.y, boyfriend.getMidpoint().y - 300, (camLerp * _variables.cameraSpeed) / (_variables.fps / 60));
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.stepCrochet / 1000 * 4), {ease: FlxEase.quadInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, defaultCamZoom, zoomLerp / (_variables.fps / 60));
			camHUD.zoom = FlxMath.lerp(camHUD.zoom, 1, zoomLerp / (_variables.fps / 60));
			camNOTES.zoom = FlxMath.lerp(camNOTES.zoom, 1, zoomLerp / (_variables.fps / 60));
			camSus.zoom = FlxMath.lerp(camSus.zoom, 1, zoomLerp / (_variables.fps / 60));
			camNOTEHUD.zoom = FlxMath.lerp(camNOTEHUD.zoom, 1, zoomLerp / (_variables.fps / 60));
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET && !paused && !inCutscene && !beginCutscene && _variables.resetButton)
		{
			canDie = true;
			health = -10;
			reset = true;
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT && _variables.cheatButton)
		{
			health += 1;
			trace("User is cheating!");
			cheated = true;
			updateAccuracy();
		}

		if ((health <= -0.00001 && canDie && !_modifiers.Practice && !ended) || reset || (curMisses >= 10 && _modifiers.SingleDigits)
			|| (gameplayArea == "Survival" && survivalTimer <= 0 && Conductor.songPosition > 250))
		{
			lives -= 1;
			curMisses = 0;

			if (_modifiers.FreezeSwitch)
			{
				missCounter = 0;
				if (frozen)
				{
					FlxG.sound.play(Paths.sound('Ice_Shatter', 'shared'), _variables.svolume / 100);
					frozen = false;
					freezeIndicator.alpha = 0;
				}
			}

			if ((lives <= 0 && gameplayArea != "Survival") || reset || ended || (gameplayArea == "Survival" && survivalTimer <= 0))
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				if (gameplayArea == "Endless" && !cheated && !_variables.botplay)
					Highscore.saveEndlessScore(SONG.song.toLowerCase(), songScore);

				speed = 0;
				loops = 0;

				camHUD.angle = 0;
				camNOTES.angle = 0;
				camSus.angle = 0;
				camNOTEHUD.angle = 0;
				FlxG.camera.angle = 0;

				if (gameplayArea != "Charting")
				{
					Highscore.saveDeaths(SONG.song, 1, storyDifficulty);
					curDeaths++;
				}

				if (!_variables.skipGO)
					FlxG.state.openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				else
				{
					if (!died)
					{
						FlxG.cameras.fade(0xff000000, 0.01, true);
						var stageSuffix:String = "";

						switch (curStage)
						{
							case 'school' | 'schoolEvil':
								stageSuffix = '-pixel';
							default:
						}

						FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix, 'shared'), _variables.svolume / 100);

						switch (gameplayArea)
						{
							case "Marathon":
								FlxG.switchState(new MenuMarathon());
							case "Endless":
								FlxG.switchState(new MenuEndless());
							case "Survival":
								FlxG.switchState(new MenuSurvival());
							default:
								LoadingState.loadAndSwitchState(new PlayState());
						}
					}
				}

				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Aw man, I died at " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			else
			{
				if (lives > 0)
				{
					FlxG.camera.flash(0xFFFF0000, 0.3 * SONG.bpm / 100);
					new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
					{
						gf.playAnim('sad', true);
					});
					FlxG.sound.play(Paths.sound('missnote2', 'shared'), _variables.svolume / 100);
					health = 1 / _modifiers.Lives * lives;
				}

				if (lives > 0 && gameplayArea == "Survival")
				{
					survivalTimer -= 2000 * MenuModifiers.fakeMP * _survivalVars.subtractTimeMultiplier;

					FlxTween.color(survivalCountdown, 0.2, FlxColor.RED, FlxColor.WHITE, {
						ease: FlxEase.quadInOut
					});
				}
				else if (lives <= 0 && gameplayArea == "Survival")
				{
					survivalTimer -= 10000 * MenuModifiers.fakeMP * _survivalVars.subtractTimeMultiplier;

					FlxTween.color(survivalCountdown, 0.2, FlxColor.GREEN, FlxColor.RED, {
						ease: FlxEase.quadInOut
					});

					FlxG.camera.flash(0xFFFF0000, 0.3 * SONG.bpm / 100);
					FlxG.sound.play(Paths.sound('missnote2', 'shared'), _variables.svolume / 100);
					health = 1;

					if (_modifiers.LivesSwitch)
					{
						lives = _modifiers.Lives;

						hearts.clear();

						var heartTex = Paths.getSparrowAtlas('heartUI', 'shared');
						switch (curStage)
						{
							case 'school' | 'schoolEvil':
								heartTex = Paths.getSparrowAtlas('weeb/pixelUI/heartUI-pixel', 'week6');
						}

						for (i in 0...Std.int(_modifiers.Lives))
							{
								heartSprite = new FlxSprite(healthBarBG.x + 5 + (i * 40), 20);
								heartSprite.frames = heartTex;
								heartSprite.antialiasing = false;
								heartSprite.updateHitbox();
								heartSprite.y = healthBarBG.y + healthBarBG.height + 10;
								heartSprite.scrollFactor.set();
								heartSprite.animation.addByPrefix('Idle', "Hearts", 24, false);
								heartSprite.ID = i;
								if (_variables.scroll == "down")
									heartSprite.y = healthBarBG.y - heartSprite.height - 10;
								if (!_modifiers.LivesSwitch)
									heartSprite.visible = false;
					
								hearts.add(heartSprite);
							}
					}
				}
			}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				// a
				var mania = 4;
				if (_variables.fiveK)
					mania = 5;
				var arrowStrum = strumLineNotes.members[daNote.noteData % mania].y;
				daNote.scrollFactor.set();
				daNote.cameras = [camNOTES, /*noteCamArray[daNote.noteData % mania]*/];
				if (daNote.isSustainNote)
					daNote.cameras = [camSus, /*noteCamArray[daNote.noteData % mania]*/];

				if (daNote.y > camNOTES.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					if (_modifiers.InvisibleNotes)
						daNote.visible = false;
					else
						daNote.visible = true;

					daNote.active = true;
				}

				if (_modifiers.NoteSpeedSwitch)
					speedNote = 1 + 1 * (_modifiers.NoteSpeed / 100);

				if (_modifiers.DrunkNotesSwitch)
					noteDrunk = _modifiers.DrunkNotes * 3;

				if (_modifiers.AccelNotesSwitch)
					noteAccel += _modifiers.AccelNotes * 0.0001;

				if (realSpeed < 1 || Math.isNaN(realSpeed))
				{
					realSpeed = SONG.speed;
				}

				if (!_modifiers.DrunkNotesSwitch || !_modifiers.AccelNotesSwitch || !_modifiers.NoteSpeedSwitch)
				{
					daNote.y = (arrowStrum - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(realSpeed, 2)));
				}
				else
				{
					daNote.y = ((arrowStrum
						- (Conductor.songPosition
							- daNote.strumTime
							+ noteAccel
							+ (_modifiers.DrunkNotes * Math.sin(Conductor.songPosition / 300)))) * (0.45 * FlxMath.roundDecimal(realSpeed, 2) * speedNote));
				}

				if (_modifiers.SnakeNotesSwitch && !daNote.isSustainNote)
					daNote.x += (_modifiers.SnakeNotes * 0.025) * Math.sin(Conductor.songPosition / 300);

				if ((_modifiers.ShortsightedSwitch
					&& daNote.y > FlxG.height - (FlxG.height - arrowStrum) * (_modifiers.Shortsighted / 100) - 11 * _modifiers.AccelNotes))
					daNote.alpha = 0;
				else if ((_modifiers.ShortsightedSwitch
					&& daNote.y <= FlxG.height - (FlxG.height - arrowStrum) * (_modifiers.Shortsighted / 100) - 11 * _modifiers.AccelNotes))
					daNote.alpha = FlxMath.lerp(daNote.alpha, 1, miscLerp / (_variables.fps / 60));

				if ((_modifiers.LongsightedSwitch
					&& daNote.y > arrowStrum + (FlxG.height - arrowStrum) * (_modifiers.Longsighted / 100) - 11 * _modifiers.AccelNotes))
					daNote.alpha = 1;
				else if ((_modifiers.LongsightedSwitch
					&& daNote.y <= arrowStrum + (FlxG.height - arrowStrum) * (_modifiers.Longsighted / 100) - 11 * _modifiers.AccelNotes))
					daNote.alpha = FlxMath.lerp(daNote.alpha, 0, miscLerp / (_variables.fps / 60));

				if (_modifiers.HyperNotesSwitch)
				{
					daNote.x += 0.25 * FlxG.random.int(Std.int(_modifiers.HyperNotes * -1), Std.int(_modifiers.HyperNotes));
					daNote.y += 0.25 * FlxG.random.int(Std.int(_modifiers.HyperNotes * -1), Std.int(_modifiers.HyperNotes));
				}

				// i am so fucking sorry for this if condition
				if (daNote.isSustainNote && !daNote.isRoll
					&& daNote.y + daNote.offset.y <= arrowStrum + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var swagRect = new FlxRect(0, arrowStrum + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;

					daNote.clipRect = swagRect;
				}

				if (!daNote.mustPress && daNote.wasGoodHit && (daNote.noteVariant != "mine" && daNote.noteVariant != 'death'))
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					if (!_variables.fiveK)
					{
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
						}
					}
					else
					{
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 4:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
						}
					}

					player2Strums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(daNote.noteData) == spr.ID && _variables.eNoteGlow)
						{
							spr.animation.play('confirm', true);
							sustain2(spr.ID, daNote);
						}
					});

					hittingNote = true;

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = _variables.vvolume / 100;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();

					if (_modifiers.MustDieSwitch)
						health -= _modifiers.MustDie / 7000;
				}

				// Guitar Hero Type Held Notes by Rozebud:tm:
				if (_variables.guitarSustain && daNote.isSustainNote && daNote.mustPress && !daNote.wasGoodHit && !daNote.isRoll)
				{
					if (daNote.prevNote.tooLate)
					{
						daNote.tooLate = true;
						daNote.destroy();
					}

					if (daNote.prevNote.wasGoodHit)
					{
						var heldKeys:Array<Bool> = [controls.UP, controls.RIGHT, controls.DOWN, controls.LEFT, controls.CENTER];

						switch (daNote.noteData)
						{
							case 0:
								if (!heldKeys[3])
									noteMiss(0, daNote);
							case 1:
								if (!heldKeys[2])
									noteMiss(1, daNote);
							case 2:
								if (!heldKeys[0])
								{
									if (!_variables.fiveK)
										noteMiss(2, daNote);
									else
										noteMiss(3, daNote);
								}
							case 3:
								if (!heldKeys[1])
									{
										if (!_variables.fiveK)
											noteMiss(3, daNote);
										else
											noteMiss(4, daNote);
									}
							case 4:
								if (!heldKeys[4] && _variables.fiveK)
									noteMiss(2, daNote);
						}

						if (!heldKeys.contains(true))
						{
							vocals.volume = 0;
							daNote.tooLate = true;
							daNote.destroy();
						}
					}
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < (arrowStrum - 75) - 25 * (SONG.speed) - 70 * _modifiers.NoteSpeed - 1.5 * _modifiers.DrunkNotes - 11 * _modifiers.AccelNotes
					- 128 * Math.abs(_modifiers.Offbeat / 100))
				{
					if (daNote.noteVariant != "mine" && daNote.noteVariant != 'death')
					{
						if (!daNote.isSustainNote)
							daNote.tooLate = true;
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						else
						{
							if (startedCountdown && daNote.mustPress && !botPlay.visible && !daNote.isRoll)
							{
								if (_modifiers.HPLossSwitch)
									health -= 0.0475 * _modifiers.HPLoss + (_variables.comboH ? 0.00075 * combo : 0);
								else
									health -= 0.0475 + (_variables.comboH ? 0.00075 * combo : 0);

								if (_modifiers.Perfect || _modifiers.BadTrip || _modifiers.ShittyEnding || _modifiers.TruePerfect) // if perfect
									health = -10;

								if (_variables.missAnims)
								{
									if (_variables.fiveK)
									{
										switch (daNote.noteData)
										{
											case 0:
												boyfriend.playAnim('singLEFTmiss', true);
											case 1:
												boyfriend.playAnim('singDOWNmiss', true);
											case 2:
												boyfriend.playAnim('singUPmiss', true);
											case 3:
												boyfriend.playAnim('singRIGHTmiss', true);
										}
									}
									else
									{
										switch (daNote.noteData)
										{
											case 0:
												boyfriend.playAnim('singLEFTmiss', true);
											case 1:
												boyfriend.playAnim('singDOWNmiss', true);
											case 2:
												boyfriend.playAnim('singUPmiss', true);
											case 4:
												boyfriend.playAnim('singUPmiss', true);
											case 3:
												boyfriend.playAnim('singRIGHTmiss', true);
										}
									}
								}

								if (_variables.muteMiss)
									vocals.volume = 0;

								songScore -= Math.floor(10 + (_variables.comboP ? 0.3 * combo : 0) * MenuModifiers.fakeMP);

								if ((daNote.isSustainNote && !daNote.wasGoodHit) || !daNote.isSustainNote)
								{
									updateAccuracy();
									misses++;
									curMisses++;

									if (gameplayArea == "Survival")
									{
										survivalTimer -= 500 * MenuModifiers.fakeMP * _survivalVars.subtractTimeMultiplier;

										FlxTween.color(survivalCountdown, 0.2, FlxColor.RED, FlxColor.WHITE, {
											ease: FlxEase.quadInOut
										});
									}

									combo = 0;
								}

								if (!frozen && _modifiers.FreezeSwitch)
								{
									missCounter++;
									freezeIndicator.alpha = missCounter / (31 - _modifiers.Freeze);
								}

								if (_modifiers.FreezeSwitch && missCounter >= 31 - _modifiers.Freeze)
									freezeBF();

								updateScoreText();
							}
						}
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		hearts.forEach(function(heart:FlxSprite)
		{
			if (heart.ID > (lives - 1))
			{
				heart.angle = FlxMath.lerp(heart.angle, 30, miscLerp / (_variables.fps / 60));

				if (_variables.scroll == "up")
					heart.y = FlxMath.lerp(heart.y, FlxG.height + heart.height + 100, miscLerp / (_variables.fps / 60));
				else
					heart.y = FlxMath.lerp(heart.y, 0 - heart.height - 100, miscLerp / (_variables.fps / 60));

				if ((heart.y >= FlxG.height + heart.height && (_variables.scroll == "up"))
					|| (heart.y <= 0 - heart.height && (_variables.scroll == "down")))
					heart.kill();
			}
		});

		if (!inCutscene && !botPlay.visible)
			keyShit();
		else if (botPlay.visible)
			autoShit();
		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function sustain2(strum:Int, note:Note):Void
	{
		var length:Float = note.sustainLength;

		if (length > 0)
		{
			switch (strum)
			{
				case 0:
					strums2[0][0] = true;
				case 1:
					strums2[1][0] = true;
				case 2:
					strums2[2][0] = true;
				case 3:
					strums2[3][0] = true;
				case 4:
					strums2[4][0] = true;
			}
		}

		var bps:Float = Conductor.bpm / 60;
		var spb:Float = 1 / bps;

		if (!note.isSustainNote)
		{
			new FlxTimer().start(length == 0 ? 0.2 : (length / Conductor.crochet * spb) + 0.1, function(tmr:FlxTimer)
			{
				switch (strum)
				{
					case 0:
						if (!strums2[0][0])
						{
							strums2[0][1] = true;
						}
						else if (length > 0)
						{
							strums2[0][0] = false;
							strums2[0][1] = true;
						}
					case 1:
						if (!strums2[1][0])
						{
							strums2[1][1] = true;
						}
						else if (length > 0)
						{
							strums2[1][0] = false;
							strums2[1][1] = true;
						}
					case 2:
						if (!strums2[2][0])
						{
							strums2[2][1] = true;
						}
						else if (length > 0)
						{
							strums2[2][0] = false;
							strums2[2][1] = true;
						}
					case 3:
						if (!strums2[3][0])
						{
							strums2[3][1] = true;
						}
						else if (length > 0)
						{
							strums2[3][0] = false;
							strums2[3][1] = true;
						}
					case 4:
						if (!strums2[4][0])
						{
							strums2[4][1] = true;
						}
						else if (length > 0)
						{
							strums2[4][0] = false;
							strums2[4][1] = true;
						}
				}
			});
		}
	}

	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (gameplayArea != "Endless")
		{
			camHUD.angle = 0;
			camNOTES.angle = 0;
			camSus.angle = 0;
			camNOTEHUD.angle = 0;

			if (SONG.validScore && !cheated && !_variables.botplay)
			{
				#if !switch
				Highscore.saveScore(SONG.song, songScore, storyDifficulty);
				#end
			}
		}

		canDie = false;
		ended = true;
		curDeaths = 0;

		switch (gameplayArea)
		{
			case "Story":
				campaignScore += songScore;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					// if ()
					MenuWeek.weekUnlocked[Std.int(Math.min(storyWeek + 1, MenuWeek.weekUnlocked.length - 1))] = true;

					if (SONG.validScore && !cheated && !_variables.botplay)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = MenuWeek.weekUnlocked;
					FlxG.save.flush();

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						camHUD.alpha -= 1 / 10;
						camNOTES.alpha -= 1 / 10;
						camSus.alpha -= 1 / 10;
						camNOTEHUD.angle -= 1 / 10;
					}, 10);

					openSubState(new RankingSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
				else
				{
					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;
						camNOTES.visible = false;
						camSus.visible = false;
						camNOTEHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off', 'shared'), _variables.svolume / 100);
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;
					openSubState(new RankingSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						camHUD.alpha -= 1 / 10;
						camNOTES.alpha -= 1 / 10;
						camSus.alpha -= 1 / 10;
						camNOTEHUD.alpha -= 1 / 10;
					}, 10);
				}
			case "Freeplay":
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					camHUD.alpha -= 1 / 10;
					camNOTES.alpha -= 1 / 10;
					camSus.alpha -= 1 / 10;
					camNOTEHUD.alpha -= 1 / 10;
				}, 10);

				openSubState(new RankingSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			case "Marathon":
				campaignScore += songScore;

				storyPlaylist.remove(storyPlaylist[0]);
				difficultyPlaylist.remove(difficultyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					if (!cheated && !_variables.botplay)
						Highscore.saveMarathonScore(campaignScore);

					FlxG.sound.music.stop();

					FlxG.switchState(new MenuMarathon());
				}
				else
				{
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					var difficulty:String = "";

					if (difficultyPlaylist[0].contains('0'))
						difficulty = '-noob';

					if (difficultyPlaylist[0].contains('1'))
						difficulty = '-easy';

					if (difficultyPlaylist[0].contains('3'))
						difficulty = '-hard';

					if (difficultyPlaylist[0].contains('4'))
						difficulty = '-expert';

					if (difficultyPlaylist[0].contains('5'))
						difficulty = '-insane';

					storyDifficulty = Std.parseInt(difficultyPlaylist[0]);

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			case "Endless":
				loops++;

				if (speed < 8 && _endless.ramp)
					speed = SONG.speed + 0.15;

				FlxG.sound.music.stop();
				vocals.stop();

				detailsText = "Endless: Loop " + loops;
				DiscordClient.changePresence(detailsText, SONG.song, iconRPC, true);

				FlxG.sound.music.volume = _variables.mvolume / 100;
				vocals.volume = _variables.vvolume / 100;

				canPause = true;
				canDie = true;
				ended = false;
				startingSong = true;

				if (storyDifficulty < 5 && loops % 8 == 0 && loops > 0 && _endless.ramp)
				{
					storyDifficulty++;

					var diffic:String = "";

					switch (storyDifficulty)
					{
						case 0:
							diffic = '-noob';
						case 1:
							diffic = '-easy';
						case 3:
							diffic = '-hard';
						case 4:
							diffic = '-expert';
						case 5:
							diffic = '-insane';
					}

					PlayState.SONG = Song.loadFromJson(SONG.song.toLowerCase() + diffic, SONG.song.toLowerCase());
				}

				SONG.speed = speed;

				Conductor.songPosition = -5000;
				generateSong(SONG.song);
				startCountdown();
			case "Charting":
				FlxG.switchState(new ChartingState());
			case "Survival":
				campaignScore += songScore;
				timeLeftOver = FlxMath.roundDecimal(survivalTimer, 2);

				storyPlaylist.remove(storyPlaylist[0]);
				difficultyPlaylist.remove(difficultyPlaylist[0]);

				FlxG.sound.music.stop();

				if (storyPlaylist.length <= 0)
				{
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					if (!cheated && !_variables.botplay)
						Highscore.saveSurvivalScore(campaignScore, survivalTimer);

					FlxG.sound.music.stop();
					FlxG.sound.music.stop();
					FlxG.sound.music.stop(); //just to make sure

					FlxG.switchState(new MenuSurvival());
				}
				else
				{
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					var difficulty:String = "";

					if (difficultyPlaylist[0].contains('0'))
						difficulty = '-noob';

					if (difficultyPlaylist[0].contains('1'))
						difficulty = '-easy';

					if (difficultyPlaylist[0].contains('3'))
						difficulty = '-hard';

					if (difficultyPlaylist[0].contains('4'))
						difficulty = '-expert';

					if (difficultyPlaylist[0].contains('5'))
						difficulty = '-insane';

					storyDifficulty = Std.parseInt(difficultyPlaylist[0]);

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
		}
	}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(strumtime:Float, note:Note):Void
	{
		var noteDiff:Float = strumtime - Conductor.songPosition;
		// boyfriend.playAnim('hey');
		vocals.volume = _variables.vvolume / 100;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.cameras = [camHUD];
		//

		var rating:FlxSprite = new FlxSprite();
		var timing:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";
		var daTiming:String = "";

		// Sweet Math.abs

		if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			score = 50;
			shits++;
			if (_modifiers.ShittyEnding || _modifiers.BadTrip || _modifiers.TruePerfect)
				health = -10;

			if (gameplayArea == "Survival")
			{
				survivalTimer -= 500 * MenuModifiers.fakeMP * _survivalVars.subtractTimeMultiplier;

				FlxTween.color(survivalCountdown, 0.2, FlxColor.RED, FlxColor.WHITE, {
					ease: FlxEase.quadInOut
				});
			}
		}
		else if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'bad';
			score = 100;
			bads++;
			if (_modifiers.BadTrip || _modifiers.TruePerfect)
				health = -10;

			if (gameplayArea == "Survival")
			{
				survivalTimer -= 250 * MenuModifiers.fakeMP * _survivalVars.subtractTimeMultiplier;

				FlxTween.color(survivalCountdown, 0.2, FlxColor.RED, FlxColor.WHITE, {
					ease: FlxEase.quadInOut
				});
			}
		}
		else if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'good';
			score = 200;
			goods++;
			if (_modifiers.TruePerfect)
				health = -10;
		}

		if (daRating == "sick")
		{
			sicks++;

			if (gameplayArea == "Survival")
			{
				survivalTimer += 1000 * MenuModifiers.fakeMP * _survivalVars.addTimeMultiplier;

				FlxTween.color(survivalCountdown, 0.2, FlxColor.GREEN, FlxColor.WHITE, {
					ease: FlxEase.quadInOut
				});
			}
		}

		if (!botPlay.visible)
		{
			if (noteDiff > Conductor.safeZoneOffset * 0.1)
				daTiming = "early";
			else if (noteDiff < Conductor.safeZoneOffset * -0.1)
				daTiming = "late";
		}
		else
		{
			daTiming = "";
			daRating = 'sick';
		}

		switch (_variables.accuracyType.toLowerCase())
		{
			case 'simple':
				totalNotesHit += 1;
			case 'complex':
				if (noteDiff > Conductor.safeZoneOffset * Math.abs(0.1))
					totalNotesHit += 1 - Math.abs(noteDiff / 200); // seems like the sweet spot
				else
					totalNotesHit += 1; // this feels so much better than you think, and saves up code space
			case 'rating-based':
				switch (daRating)
				{
					case 'sick':
						totalNotesHit += 1;
					case 'good':
						totalNotesHit += 0.75;
					case 'bad':
						totalNotesHit += 0.5;
					case 'shit':
						totalNotesHit += 0.25;
				}
		}

		if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.75 && _variables.lateD)
		{
			switch (daRating)
			{
				case 'bad':
					if (_modifiers.HPLossSwitch)
						health -= 0.06 * _modifiers.HPLoss;
					else
						health -= 0.06;
				case 'shit':
					if (_modifiers.HPLossSwitch)
						health -= 0.2 * _modifiers.HPLoss;
					else
						health -= 0.2;
			}
		}

		songScore += Math.floor((score + (_variables.comboP ? 2 * combo : 0)) * MenuModifiers.fakeMP);

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		if (pixelShitPart2 == '')
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2, 'shared'));
		else
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2, 'week6'));
		rating.screenCenter();
		rating.x = _variables.sickX;
		rating.y = _variables.sickY;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.cameras = [camHUD];

		if (daTiming == "")
		{
			if (pixelShitPart2 == '')
				timing.loadGraphic(Paths.image(pixelShitPart1 + pixelShitPart2, 'shared'));
			else
				timing.loadGraphic(Paths.image(pixelShitPart1 + pixelShitPart2, 'week6'));
		}
		else
		{
			if (pixelShitPart2 == '')
				timing.loadGraphic(Paths.image(pixelShitPart1 + daTiming + pixelShitPart2, 'shared'));
			else
				timing.loadGraphic(Paths.image(pixelShitPart1 + daTiming + pixelShitPart2, 'week6'));
		}

		timing.screenCenter();
		timing.x = rating.x - 80;
		timing.y = rating.y + 80;
		timing.acceleration.y = 550;
		timing.velocity.y -= FlxG.random.int(140, 175);
		timing.velocity.x -= FlxG.random.int(0, 10);
		timing.cameras = [camHUD];

		var comboSpr:FlxSprite = new FlxSprite();
		if (pixelShitPart2 == '')
			comboSpr.loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2, 'shared'));
		else
			comboSpr.loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2, 'week6'));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.cameras = [camHUD];

		comboSpr.velocity.x += FlxG.random.int(1, 10);

		var msTiming = truncateFloat(noteDiff, 3);

		if (botPlay.visible)
			msTiming = 0;

		if (currentTimingShown != null)
			remove(currentTimingShown);

		currentTimingShown = new FlxText(0, 0, 0, "0ms");
		timeShown = 0;

		if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.75)
			currentTimingShown.color = FlxColor.RED;
		else if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.2)
			currentTimingShown.color = FlxColor.GREEN;
		else if (Math.abs(noteDiff) <= Conductor.safeZoneOffset * 0.2)
			currentTimingShown.color = FlxColor.CYAN;

		currentTimingShown.borderStyle = OUTLINE;
		currentTimingShown.borderSize = 1;
		currentTimingShown.borderColor = FlxColor.BLACK;
		currentTimingShown.text = msTiming + "ms";
		currentTimingShown.size = 20;
		currentTimingShown.screenCenter();
		currentTimingShown.x = rating.x + 90;
		currentTimingShown.y = rating.y + 100;
		currentTimingShown.acceleration.y = 600;
		currentTimingShown.velocity.y -= 150;
		comboSpr.velocity.x += FlxG.random.int(1, 10);

		if (currentTimingShown.alpha != 1)
			currentTimingShown.alpha = 1;

		currentTimingShown.cameras = [camHUD];

		if (_variables.ratingDisplay)
			add(rating);

		if (daTiming != "" && _variables.timingDisplay)
			add(timing);

		if (_variables.timingDisplay)
			add(currentTimingShown);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
			timing.setGraphicSize(Std.int(timing.width * 0.7));
			timing.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			timing.setGraphicSize(Std.int(timing.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();
		timing.updateHitbox();

		var sploosh:FlxSprite = new FlxSprite(note.x, playerStrums.members[note.noteData].y);
		if (!_modifiers.InvisibleNotes && _variables.noteSplashes)
		{
			if (!curStage.startsWith('school'))
			{
				var tex:flixel.graphics.frames.FlxAtlasFrames = Paths.getSparrowAtlas('noteSplashes', 'shared');
				sploosh.frames = tex;
				sploosh.animation.addByPrefix('splash 0 0', 'note impact 1 purple', 24, false);
				sploosh.animation.addByPrefix('splash 0 1', 'note impact 1 blue', 24, false);
				sploosh.animation.addByPrefix('splash 0 2', 'note impact 1 green', 24, false);
				sploosh.animation.addByPrefix('splash 0 3', 'note impact 1 red', 24, false);
				sploosh.animation.addByPrefix('splash 0 4', 'note impact 1 yellow', 24, false);
				sploosh.animation.addByPrefix('splash 1 0', 'note impact 2 purple', 24, false);
				sploosh.animation.addByPrefix('splash 1 1', 'note impact 2 blue', 24, false);
				sploosh.animation.addByPrefix('splash 1 2', 'note impact 2 green', 24, false);
				sploosh.animation.addByPrefix('splash 1 3', 'note impact 2 red', 24, false);
				sploosh.animation.addByPrefix('splash 1 4', 'note impact 2 yellow', 24, false);
				if (daRating == 'sick')
				{
					add(sploosh);
					sploosh.cameras = [camNOTEHUD];
					sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + note.noteData);
					sploosh.alpha = 0.6;
					sploosh.offset.x += 90;
					sploosh.offset.y += 80;
					sploosh.animation.finishCallback = function(name) sploosh.kill();
				}
			}
			else
			{
				sploosh.loadGraphic(Paths.image('weeb/pixelUI/noteSplashes-pixels', 'week6'), true, 50, 50);
				sploosh.animation.add('splash 0 0', [0, 1, 2, 3], 24, false);
				sploosh.animation.add('splash 1 0', [4, 5, 6, 7], 24, false);
				sploosh.animation.add('splash 0 1', [8, 9, 10, 11], 24, false);
				sploosh.animation.add('splash 1 1', [12, 13, 14, 15], 24, false);
				sploosh.animation.add('splash 0 2', [16, 17, 18, 19], 24, false);
				sploosh.animation.add('splash 1 2', [20, 21, 22, 23], 24, false);
				sploosh.animation.add('splash 0 3', [24, 25, 26, 27], 24, false);
				sploosh.animation.add('splash 1 3', [28, 29, 30, 31], 24, false);
				sploosh.animation.add('splash 0 4', [32, 33, 34, 35], 24, false);
				sploosh.animation.add('splash 1 4', [36, 37, 38, 39], 24, false);
				if (daRating == 'sick')
				{
					sploosh.setGraphicSize(Std.int(sploosh.width * daPixelZoom));
					sploosh.updateHitbox();
					add(sploosh);
					sploosh.cameras = [camNOTEHUD];
					sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + note.noteData);
					sploosh.alpha = 0.6;
					sploosh.offset.x += 90;
					sploosh.offset.y += 80;
					sploosh.animation.finishCallback = function(name) sploosh.kill();
				}
			}
		}

		var seperatedScore:Array<Int> = [];

		if (combo == 0)
			combo += 1;

		var comboSplit:Array<String> = (combo + "").split('');

		if (comboSplit.length == 2)
			seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!
		if (comboSplit.length == 1)
		{
			seperatedScore.push(0); // make sure theres two 0s in front or it looks weird lol!
			seperatedScore.push(0);
		}

		for (i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite();
			if (pixelShitPart2 == '')
				numScore.loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			else
				numScore.loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2, 'week6'));
			numScore.screenCenter();
			numScore.x = rating.x + (43 * daLoop) - 40;
			numScore.y = rating.y + 180;
			numScore.cameras = [camHUD];

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (_variables.comboDisplay)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001,
			onUpdate: function(tween:FlxTween)
			{
				if (currentTimingShown != null)
					currentTimingShown.alpha -= 0.02;
				timeShown++;
			}
		});

		FlxTween.tween(timing, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();
				if (currentTimingShown != null && timeShown >= 10)
				{
					remove(currentTimingShown);
					currentTimingShown = null;
				}
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;

		updateScoreText();
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	var noteHit:Int = 0;

	var manager:FlxTimerManager = new FlxTimerManager();
	var manager2:FlxTimerManager = new FlxTimerManager();

	private function autoShit():Void
	{
		var mania = 4;
		if (_variables.fiveK)
			mania = 5;

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;

				if (_variables.scroll == "left" || _variables.scroll == "right")
					spr.offset.x -= 50;
			}
			else
				spr.centerOffsets();

			if (spr.animation.curAnim.name == 'confirm' && spr.animation.curAnim.finished)
			{
				spr.animation.play('static');
				spr.centerOffsets();
			}
		});

		player2Strums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 0:
					if (strums2[0][1])
						spr.animation.play('static');
					strums2[0][1] = false;
				case 1:
					if (strums2[1][1])
						spr.animation.play('static');
					strums2[1][1] = false;

				case 2:
					if (strums2[2][1])
						spr.animation.play('static');
					strums2[2][1] = false;
				case 3:
					if (strums2[3][1])
						spr.animation.play('static');
					strums2[3][1] = false;
				case 4:
					if (strums2[4][1])
						spr.animation.play('static');
					strums2[4][1] = false;
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.y < strumLineNotes.members[daNote.noteData % mania].y)
			{
				// Force good note hit regardless if it's too late to hit it or not as a fail safe
				if (daNote.canBeHit && daNote.mustPress || daNote.tooLate && daNote.mustPress)
				{
					if (daNote.noteVariant != "mine" && daNote.noteVariant != 'death')
					{
						goodNoteHit(daNote);
						boyfriend.holdTimer = 0;
						// manager2.clear();
						misses = 0;
						accuracy = 100.00;
					}
				}
			}
		});
	}

	private function keyShit():Void // I've invested in emma stocks
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT, controls.CENTER];
		var pressArray:Array<Bool> = [
			controls.LEFT_P,
			controls.DOWN_P,
			controls.UP_P,
			controls.RIGHT_P,
			controls.CENTER_P
		];
		var releaseArray:Array<Bool> = [
			controls.LEFT_R,
			controls.DOWN_R,
			controls.UP_R,
			controls.RIGHT_R,
			controls.CENTER_R
		];

		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && !frozen && !ended)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData] && !daNote.isRoll)
					goodNoteHit(daNote);
			});
		}

		// PRESSES, check for note hits
		if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && !frozen && !ended)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{ // if it's the same note twice at < 10ms distance, just delete it
								// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{ // if daNote is earlier than existing note (coolNote), replace
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			var dontCheck = false;

			for (i in 0...pressArray.length)
			{
				if (pressArray[i] && !directionList.contains(i))
					dontCheck = true;
			}

			if (perfectMode)
				goodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0 && !dontCheck || possibleNotes.length > 0 && !_variables.spamPrevention)
			{
				if (!_variables.ghostTapping)
					{
						for (shit in 0...pressArray.length)
							{ // if a direction is hit that shouldn't be
								if (pressArray[shit] && !directionList.contains(shit))
									noteMiss(shit, null);
							}
					}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
					{
						if (!coolNote.prevNote.isSustainNote && coolNote.isSustainNote && coolNote.prevNote != null && !_variables.guitarSustain)
							goodNoteHit(coolNote.prevNote);
						if (mashViolations != 0)
							mashViolations--;
						scoreTxt.color = FlxColor.WHITE;
						goodNoteHit(coolNote);
					}
				}
			}
			else if (!_variables.ghostTapping)
				{
					for (shit in 0...pressArray.length)
						if (pressArray[shit])
							noteMiss(shit, null);
				}

			if (dontCheck && possibleNotes.length > 0 || _variables.spamPrevention && possibleNotes.length > 0)
			{
				if (mashViolations > 4 && _variables.spamPrevention)
				{
					trace('mash violations ' + mashViolations);
					scoreTxt.color = FlxColor.RED;
					for (shit in 0...pressArray.length)
						if (pressArray[shit])
							noteMiss(shit);
				}
				else
					mashViolations++;
			}
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true)))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				if (!frozen)
				{
					boyfriend.playAnim('idle');
					if (_modifiers.FrightSwitch)
					{
						if (_modifiers.Fright >= 50 && _modifiers.Fright < 100)
								boyfriend.playAnim('scared');
						else if (_modifiers.Fright >= 100)
						{
							if (boyfriend.animation.getByName('worried') != null)
								boyfriend.playAnim('worried');
							else
								boyfriend.playAnim('idle');
						}
					}
				}
				else
				{
					if (boyfriend.animation.getByName('frozen') != null)
						boyfriend.playAnim('frozen');
					else
					{
						boyfriend.playAnim('idle');
						boyfriend.animation.curAnim.frameRate = 0;
						boyfriend.color = 0xFF00D0FF;
					}
				}
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
			{
				spr.animation.play('pressed');
			}
			if (!holdArray[spr.ID])
				spr.animation.play('static');

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;

				if (_variables.scroll == "left" || _variables.scroll == "right")
					spr.offset.x -= 50;
			}
			else
				spr.centerOffsets();
		});
		player2Strums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 0:
					if (strums2[0][1])
						spr.animation.play('static');
					strums2[0][1] = false;
				case 1:
					if (strums2[1][1])
						spr.animation.play('static');
					strums2[1][1] = false;

				case 2:
					if (strums2[2][1])
						spr.animation.play('static');
					strums2[2][1] = false;
				case 3:
					if (strums2[3][1])
						spr.animation.play('static');
					strums2[3][1] = false;
				case 4:
					if (strums2[4][1])
						spr.animation.play('static');
					strums2[4][1] = false;
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1, ?note:Note = null):Void
	{
		if (!boyfriend.stunned)
		{
			if (note != null)
			{
				switch (note.noteVariant)
				{
					default:
						if (_modifiers.HPLossSwitch)
							health -= 0.04 * _modifiers.HPLoss + (_variables.comboH ? 0.00075 * combo : 0);
						else
							health -= 0.04 + (_variables.comboH ? 0.00075 * combo : 0);
					case 'mine':
						if (_modifiers.HPLossSwitch)
							health -= 0.16 * _modifiers.HPLoss + (_variables.comboH ? 0.001 * combo : 0);
						else
							health -= 0.16 + (_variables.comboH ? 0.001 * combo : 0);
					case 'death':
						health = -10;
				}
			}
			else
			{
				if (_modifiers.HPLossSwitch)
					health -= 0.04 * _modifiers.HPLoss + (_variables.comboH ? 0.00075 * combo : 0);
				else
					health -= 0.04 + (_variables.comboH ? 0.00075 * combo : 0);
			}

			if (_modifiers.Perfect || _modifiers.BadTrip || _modifiers.ShittyEnding || _modifiers.TruePerfect) // if perfect
				health = -10;

			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}

			misses++;
			curMisses++;

			if (gameplayArea == "Survival")
			{
				survivalTimer -= 500 * MenuModifiers.fakeMP * _survivalVars.subtractTimeMultiplier;

				FlxTween.color(survivalCountdown, 0.2, FlxColor.RED, FlxColor.WHITE, {
					ease: FlxEase.quadInOut
				});
			}

			// e
			if (!frozen && _modifiers.FreezeSwitch)
			{
				missCounter++;
				freezeIndicator.alpha = missCounter / (31 - _modifiers.Freeze);
			}

			songScore -= Math.floor(10 + (_variables.comboP ? 0.3 * combo : 0) * MenuModifiers.fakeMP);

			combo = 0;
			updateAccuracy();

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3, 'shared'), FlxG.random.float(0.1, 0.2) * _variables.svolume / 100);
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			if (_variables.missAnims)
			{
				if (_variables.fiveK)
				{
					switch (direction)
					{
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
					}
				}
				else
				{
					switch (direction)
					{
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 4:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
					}
				}
			}
			
			if (note != null)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			if (_modifiers.FreezeSwitch && missCounter >= 31 - _modifiers.Freeze)
				freezeBF();

			updateScoreText();
		}
	}

	function updateScoreText()
	{
		scoreTxt.text = "Score: " + songScore;
		missTxt.text = "Misses: " + misses;
	}

	function freezeBF():Void
	{
		frozen = true;
		missCounter = 0;
		FlxG.sound.play(Paths.sound('Ice_Appear', 'shared'), _variables.svolume / 100);

		if (boyfriend.animation.getByName('frozen') != null)
			boyfriend.playAnim('frozen', true);
		else
		{
			boyfriend.playAnim('idle', true);
			boyfriend.animation.curAnim.frameRate = 0;
			boyfriend.color = 0xFF00D0FF;
		}


		freezeIndicator.alpha = 1;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			missCounter = 0;
			freezeIndicator.alpha = 0;
			FlxG.sound.play(Paths.sound('Ice_Shatter', 'shared'), _variables.svolume / 100);
			frozen = false;

			if (boyfriend.animation.curAnim.name == "idle")
			{
				boyfriend.color = 0xFFFFFFFF;
				boyfriend.animation.curAnim.frameRate = 24;
			}
			else
				boyfriend.playAnim('idle', true);

			if (_modifiers.FrightSwitch)
			{
				if (_modifiers.Fright >= 50 && _modifiers.Fright < 100)
						boyfriend.playAnim('scared', true);
				else if (_modifiers.Fright >= 100)
					if (boyfriend.animation.getByName('worried') != null)
						boyfriend.playAnim('worried', true);
					else
						boyfriend.playAnim('idle', true);
			}
		});
	}

	function badNoteCheck()
	{
		// REDO THIS SHIT!!!!
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		if (_variables.fiveK)
		{
			pressArray = [
				controls.LEFT_P,
				controls.DOWN_P,
				controls.UP_P,
				controls.RIGHT_P,
				controls.CENTER_P
			];
		}
		// notes.forEachAlive(function(daNote:Note)
		// {
		// 	if (daNote.canBeHit)
		// 		doNothing = true;
		// });
		// if (!doNothing)
		// {
		// 	Note.setCanMiss(0, true);
		// 	Note.setCanMiss(1, true);
		// 	Note.setCanMiss(2, true);
		// 	Note.setCanMiss(3, true);
		// }
		// if (canMiss) {
		if (pressArray[0])
			noteMiss(0);
		if (pressArray[1])
			noteMiss(1);
		if (pressArray[2])
			noteMiss(2);
		if (pressArray[3])
			noteMiss(3);
		if (pressArray[4])
			noteMiss(4);
		// }
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else
		{
			if (_variables.spamPrevention)
				badNoteCheck();
		}
	}

	var resetMashViolation = false;

	function goodNoteHit(note:Note):Void
	{
		// ditto
		if (_variables.guitarSustain && note.isSustainNote && !note.prevNote.wasGoodHit && note.prevNote.isSustainNote)
		{
			if (!note.isRoll)
				noteMiss(note.noteData, note);
			note.prevNote.tooLate = true;
			note.prevNote.destroy();
			if (_variables.muteMiss && !note.isRoll)
				vocals.volume = 0;
		}
		else if (!note.wasGoodHit)
		{
			hittingNote = true;

			if (note.noteVariant == "mine" || note.noteVariant == 'death')
			{
				noteMiss(note.noteData, note);
			}
			else
			{
				if (mashing != 0)
					mashing = 0;

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.isSustainNote || (note.isSustainNote && note.isRoll))
				{
					if (_variables.hitsound.toLowerCase() != 'none')
						FlxG.sound.play(Paths.sound('hitsounds/' + _variables.hitsound, 'shared'), _variables.hvolume / 100);

					if (_variables.nps)
						notesHitArray.push(Date.now());
					popUpScore(note.strumTime, note);
					combo += 1;
				}

				if (note.isSustainNote)
					totalNotesHit += 1;

				// no
				if (note.noteData >= 0)
				{
					if (_modifiers.HPGainSwitch)
						health += 0.023 * _modifiers.HPGain + (_variables.comboH ? 0.001 * combo : 0);
					else
						health += 0.023 + (_variables.comboH ? 0.001 * combo : 0);
				}
				else
				{
					if (_modifiers.HPGainSwitch)
						health += 0.004 * _modifiers.HPGain + (_variables.comboH ? 0.001 * combo : 0);
					else
						health += 0.004 + (_variables.comboH ? 0.001 * combo : 0);
				}

				if (!_variables.fiveK)
				{
					switch (note.noteData)
					{
						case 0:
							boyfriend.playAnim('singLEFT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
					}
				}
				else
				{
					switch (note.noteData)
					{
						case 0:
							boyfriend.playAnim('singLEFT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 2:
							boyfriend.playAnim('singUP', true);
						case 4:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
					}
				}

				playerStrums.forEach(function(spr:FlxSkewedSprite)
				{
					if (Math.abs(note.noteData) == spr.ID && _variables.noteGlow)
					{
						spr.animation.play('confirm', true);
					}
				});

				note.wasGoodHit = true;
				vocals.volume = _variables.vvolume / 100;

				if (!note.isSustainNote || (note.isSustainNote && note.isRoll))
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}

				missCounter = 0;
				freezeIndicator.alpha = 0;
				updateAccuracy();
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1, 'shared'), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2, 'shared'));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		// hscriptBeat();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		// if (_variables.fps < (FlxG.drawFramerate - 4 + 20) && generatedMusic)
		// 	resyncVocals(true);

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				if (_modifiers.VibeSwitch)
				{
					switch (_modifiers.Vibe)
					{
						case 0.8:
							Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm * 1.2); // :(
						case 1.2:
							Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm * 0.7); // :(
					}
				}
				else
					Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);

				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			/*if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance(); DUMB!!!!!!! */
		}

		// THIS SHIT DOES NOT WORK PROPERLY!
		// WHY?
		// HAS I EVER?
		if (!ended)
		{
			/*if (SONG.notes[Math.floor(curStep / 16)].sectionSpeed != 0)
				realSpeed = SONG.notes[Math.floor(curStep / 16)].sectionSpeed;
			else*/
				realSpeed = SONG.speed;
		}

		// a dumb way of doing this but theres no other way because of ninja's ass code
		// notes.forEachAlive(function(daNote:Note)
		// {
		// 	if (daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end') && realSpeed > SONG.speed && curBeat % 4 == 0)
		// 	{
		// 		daNote.scale.y = 1;
		// 		daNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * realSpeed;
		// 		daNote.updateHitbox();
		// 	}
		// });

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
			camNOTES.zoom += 0.03;
			camSus.zoom += 0.03;
			camNOTEHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
			camNOTES.zoom += 0.03;
			camSus.zoom += 0.03;
			camNOTEHUD.zoom += 0.03;
		}

		wiggleShit.waveAmplitude = 0.035;
		wiggleShit.waveFrequency = 10;

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (curBeat % 1 == 0)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.noteVariant == "mine" || daNote.noteVariant == 'death')
				{
					FlxTween.color(daNote, 0, FlxColor.WHITE, FlxColor.RED, {
						ease: FlxEase.quadInOut
					});
				}
			});
		}

		if (curBeat % 2 == 0)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.noteVariant == "mine" || daNote.noteVariant == 'death')
				{
					FlxTween.color(daNote, 0, FlxColor.RED, FlxColor.WHITE, {
						ease: FlxEase.quadInOut
					});
				}
			});
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			if (!frozen)
			{
				boyfriend.playAnim('idle');
				if (_modifiers.FrightSwitch)
				{
					if (_modifiers.Fright >= 50 && _modifiers.Fright < 100)
							boyfriend.playAnim('scared');
					else if (_modifiers.Fright >= 100)
					{
						if (boyfriend.animation.getByName('worried') != null)
							boyfriend.playAnim('worried');
						else
							boyfriend.playAnim('idle');
					}
				}
			}
			else
			{
				if (boyfriend.animation.getByName('frozen') != null)
					boyfriend.playAnim('frozen');
				else
				{
					boyfriend.playAnim('idle');
					boyfriend.animation.curAnim.frameRate = 0;
					boyfriend.color = 0xFF00D0FF;
				}
			}

			hittingNote = false;
		}

		if (!dad.animation.curAnim.name.startsWith("sing"))
		{
			dad.dance(); // ill make this better later i promise
			hittingNote = false;
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			if (!frozen)
				boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			if (!frozen)
				boyfriend.playAnim('hey', true);
			
			dad.playAnim('cheer', true);
		}

		if (!_variables.chromakey)
		{
			switch (curStage)
			{
				case 'school':
					bgGirls.dance();

				case 'mall':
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);

				case 'limo':
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});

					if (FlxG.random.bool(10) && fastCarCanDrive && _variables.distractions)
						fastCarDrive();
				case "philly":
					if (!trainMoving)
						trainCooldown += 1;

					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});

						curLight = FlxG.random.int(0, phillyCityLights.length - 1);

						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
					}

					if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8 && _variables.distractions)
					{
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
			}
		}

		if (isHalloween
			&& FlxG.random.bool(10)
			&& curBeat > lightningStrikeBeat + lightningOffset
			&& _variables.distractions
			&& !_variables.chromakey)
		{
			lightningStrikeShit();
		}
	}

	public static function randString(Length:Int)
	{
		var string:String = '';
		var data:String = 'qwertyuiopasdfghjklzxcvbnm1234567890QWERTYUIOPASDFGHJKLZXCVBNM';

		for (i in 0...Length)
		{
			string += data.charAt(FlxG.random.int(0, data.length - 1));
		}
		return string;
	}

	/**
	 * NOTICE: If lua aint enough to do ur wacky shit, use hscript :troll:
	 * Its haxe but you dont need to compile it
	**/
	public function hscript()
	{
		if (FileSystem.exists('assets/data/' + SONG.song.toLowerCase() + '/scripts/chart.hx'))
		{
			// sets most of the variables
			modState.set("FlxSprite", flixel.FlxSprite);
			modState.set("FlxTimer", FlxTimer);
			modState.set("File", sys.io.File);
			modState.set("fs", FileSystem);
			modState.set("Math", Math);
			modState.set("Std", Std);
			modState.set("FlxTween", FlxTween);
			modState.set("FlxText", FlxText);
			modState.set("camera", FlxG.camera);
			modState.set("hud", camHUD);
			modState.set("noteCamera", camNOTES);
			modState.set("sustainCamera", camSus);
			modState.set("noteHudCam", camNOTEHUD);
			modState.set("gf", gf);
			modState.set("dad", dad);
			modState.set("boyfriend", boyfriend);
			modState.set("beatHit", beatHit);
			modState.set("stepHit", stepHit);
			modState.set("add", addObject);
			// beat shit
			modState.set("step", curStep);
			modState.set("beat", curBeat);

			notes.forEachAlive(function(daNote:Note)
			{
				var mania:Int = 4;
				if (_variables.fiveK)
					mania = 5;
				for (i in 0...mania)
				{
					if (daNote.noteData == i)
						modState.set("note" + i, daNote);
				}

				modState.set("allNotes", daNote);
			});
		}
	}

	public function loadScript()
	{
		modState.executeString(File.getContent('assets/data/' + SONG.song.toLowerCase() + '/scripts/chart.hx'));
	}

	public function loadStartScript()
	{
		modState.executeString(File.getContent('assets/data/' + SONG.song.toLowerCase() + '/scripts/start.hx'));
	}

	public function addObject(object:flixel.FlxBasic) // fallback
	{
		add(object);
	}

	var curLight:Int = 0;

	public static function dominantColor(sprite:FlxSprite):Int 
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth) {
			for (row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0) {
					if (countByColor.exists(colorOfThisPixel)) {
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					} else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687)) {
						countByColor[colorOfThisPixel] = 1;
					}
				}
			}
		}
		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for (key in countByColor.keys()) {
			if (countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}
}

package;

import sys.FileSystem;
#if desktop
import Discord.DiscordClient;
#end
import sys.io.File;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import MainVariables._variables;
import ModifierVariables._modifiers;
import Endless_Substate._endless;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var gameplayArea:String = "Story";
	public static var chartType:String = "standard";
	public static var storyWeek:Int = 0;

	public static var loops:Int = 0;
	public static var speed:Float = 0; 
	
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
	private var songPositionBar:Float = 0;

	var halloweenLevel:Bool = false;
	var doof:DialogueBox;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var player2Strums:FlxTypedGroup<FlxSprite>;
	private var strums2:Array<Array<Bool>> = [[false, false], [false, false], [false, false], [false, false]];
	private var hearts:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camNOTES:FlxCamera;
	private var camHUD:FlxCamera;
	private var camPAUSE:FlxCamera;
	private var camGame:FlxCamera;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public static var dialogue:Array<String> = [];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	private var LightsOutBG:FlxSprite;
	private var BlindingBG:FlxSprite;
	private var freezeIndicator:FlxSprite;

	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	public static var misses:Int = 0;
	var missTxt:FlxText;
	public static var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	var accuracyTxt:FlxText;
	var canDie:Bool = true;
	public static var arrowLane:Int = 0;
	var nps:Int = 0;
	var npsTxt:FlxText;
	public static var ended:Bool = false;

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

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	var dialogueSuffix:String = "";

	public static var cameraX:Float;
	public static var cameraY:Float;

	var miscLerp:Float = 0.09;
	var camLerp:Float = 0.14;
	var zoomLerp:Float = 0.09;

	override public function create()
	{
		modifierValues();
        //_positions = Json.parse(data);

		ended = false;

		dialogue = null;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;
		accuracy = 0.00;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camHUD.alpha = 0;
		camNOTES = new FlxCamera();
		camNOTES.bgColor.alpha = 0;
		camNOTES.alpha = 0;
		camPAUSE = new FlxCamera();
		camPAUSE.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camNOTES);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camPAUSE);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		if (gameplayArea == "Endless")
			SONG.speed = _endless.speed;

		Conductor.mapBPMChanges(SONG);

		Conductor.changeBPM(SONG.bpm);

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
		//else if (_modifiers.FrightSwitch && _modifiers.Fright >= 310)
		//	dialogueSuffix = "-dead"; ///yiiiiikes
		else if(_modifiers.Practice)
			dialogueSuffix = "-practice";
		else if(_modifiers.Perfect)
			dialogueSuffix = "-perfect";


		/*
		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
		}
		*/

		if (FileSystem.exists(Paths.txt(SONG.song.toLowerCase()+'/dialogue$dialogueSuffix')))
		{
			dialogue = File.getContent(Paths.txt(SONG.song.toLowerCase()+'/dialogue$dialogueSuffix')).trim().split('\n');

			for (i in 0...dialogue.length)
			{
				dialogue[i] = dialogue[i].trim();
			}
		}

		#if desktop
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
		case "Endless":
			detailsText = "Endless: Loop "+ loops;
		}

		// String for when the game is paused
		detailsPausedText = "BRB - " + detailsText;

		if (gameplayArea == "Endless")
			detailsPausedText = "BRB - Endless:";

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);

		if (gameplayArea == "Endless")
			DiscordClient.changePresence(detailsText, SONG.song, iconRPC, true);
		#end

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
		case 'pico' | 'blammed' | 'philly':
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
		case 'milf' | 'satin-panties' | 'high':
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
		case 'winter-horrorland':
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
			if (_modifiers.BrightnessSwitch && (_modifiers.Brightness <= -30 || _modifiers.Brightness >= 40 ))
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

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

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

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		doof = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		if (_modifiers.InvisibleNotes)
		{
			strumLine.visible = false;
			strumLineNotes.visible = false;
		}

		playerStrums = new FlxTypedGroup<FlxSprite>();
		player2Strums = new FlxTypedGroup<FlxSprite>();

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
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (_variables.scroll == "down")
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
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
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		scoreTxt = new FlxText(healthBarBG.x - healthBarBG.width/2, healthBarBG.y + 26, 0, "", 20);
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

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		hearts = new FlxTypedGroup<FlxSprite>();
		add(hearts);

		if (_modifiers.Enigma)
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

		strumLineNotes.cameras = [camNOTES];
		notes.cameras = [camNOTES];
		hearts.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		missTxt.cameras = [camHUD];
		accuracyTxt.cameras = [camHUD];
		npsTxt.cameras = [camHUD];
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
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On', 'shared'), _variables.svolume/100);
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
					FlxG.sound.play(Paths.sound('ANGRY', 'shared'), _variables.svolume/100);
					FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX', 'shared'), _variables.svolume/100);
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

		super.create();
	}

	function dialogueOrCountdown():Void
	{
		trace(dialogue);
		if (dialogue == null)
			startCountdown();
		else
			schoolIntro(doof);
	}

	function modifierValues():Void
	{
		if (_modifiers.LivesSwitch)
			lives = _modifiers.Lives;

		if (_modifiers.StartHealthSwitch)
			health = 1 + _modifiers.StartHealth/100;

		if (_modifiers.HitZonesSwitch)
		{
			Conductor.safeFrames = Std.int(10 + _modifiers.HitZones);
			Conductor.safeZoneOffset = (Conductor.safeFrames / 60) * 1000;
			Conductor.timeScale = Conductor.safeZoneOffset / 166;
		}
		else
		{
			Conductor.safeFrames = 10;
			Conductor.safeZoneOffset = (Conductor.safeFrames / 60) * 1000;
			Conductor.timeScale = Conductor.safeZoneOffset / 166;
		}

		if (_modifiers.Mirror)
		{
			FlxG.game.scaleX = -1;
			FlxG.game.x += FlxG.width;
		}
		if (_modifiers.UpsideDown)
		{
			FlxG.game.scaleY = -1;
			FlxG.game.y += FlxG.height;
		}
	}

	function updateAccuracy()
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

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
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

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns' || SONG.song.toLowerCase() == 'winter-horrorland')
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
								FlxG.sound.play(Paths.sound('Senpai_Dies', 'shared'), _variables.svolume/100, false, null, true, function()
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

		if (gameplayArea != "Endless" || (gameplayArea == "Endless" && loops == 0))
		{
			generateStaticArrows(0);
			generateStaticArrows(1);
		}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
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
							boyfriend.playAnim('worried');
					}
			}
			else
				boyfriend.playAnim('frozen');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

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
					FlxG.sound.play(Paths.sound('intro3'+altSuffix, 'shared'), 0.6*_variables.svolume/100);

					new FlxTimer().start(0.03, function(tmr:FlxTimer)
						{
							camHUD.alpha += 1 / 6;
							camNOTES.alpha += 1 / 6;
						}, 10);
				case 1:
					var ready:FlxSprite = new FlxSprite();
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
					FlxG.sound.play(Paths.sound('intro2'+altSuffix, 'shared'), 0.6*_variables.svolume/100);
				case 2:
					var set:FlxSprite = new FlxSprite();
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
					FlxG.sound.play(Paths.sound('intro1'+altSuffix, 'shared'), 0.6*_variables.svolume/100);
				case 3:
					var go:FlxSprite = new FlxSprite();
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
					FlxG.sound.play(Paths.sound('introGo'+altSuffix, 'shared'), 0.6*_variables.svolume/100);
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
			if (_modifiers.VibeSwitch)
			{
				switch (_modifiers.Vibe)
				{
				case 0.8:
					FlxG.sound.playMusic(Paths.instHIFI(PlayState.SONG.song), _variables.mvolume/100, false);
				case 1.2:
					FlxG.sound.playMusic(Paths.instLOFI(PlayState.SONG.song), _variables.mvolume/100, false);
				default:
					FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), _variables.mvolume/100, false);
				}
			}
			else
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), _variables.mvolume/100, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		if (_modifiers.OffbeatSwitch)
			vocals.time = Conductor.songPosition + (512 * _modifiers.Offbeat/100);

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (_variables.songPosition) // I dont wanna talk about this code :(
			{
				remove(songPosBG);
				remove(songPosBar);
				remove(songName);

				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar', 'shared'));
				if (_variables.scroll == "down")
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				songPosBG.cameras = [camHUD];
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
				songPosBar.numDivisions = 1000;
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
				songPosBar.cameras = [camHUD];
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (_variables.scroll == "down")
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}

		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;
	var stair:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

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
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{

				var daStrumTime:Float = songNotes[0];
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (_modifiers.OffbeatSwitch)
				{
					offbeatValue = 512 * _modifiers.Offbeat/100;
				}

				if (_modifiers.VibeSwitch)
					{
						switch (_modifiers.Vibe)
						{
						case 0.8:
							daStrumTime = (daStrumTime + _variables.noteOffset + offbeatValue) * 0.8332; //somewhere around 0.832
						case 1.2:
							daStrumTime = (daStrumTime + _variables.noteOffset + offbeatValue) * 1.25;
						default:
							daStrumTime = daStrumTime + _variables.noteOffset + offbeatValue;
						}
					}
				else
					daStrumTime = daStrumTime + _variables.noteOffset + offbeatValue;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				switch (chartType)
				{
					case "standard":
						daNoteData = Std.int(songNotes[1] % 4);
					case "flip":
						if (gottaHitNote)
							daNoteData = 3 - Std.int(songNotes[1] % 4);  //B-SIDE FLIP???? Rozebud be damned lmao
					case "chaos":
						switch (FlxG.random.int(0, 3)) //Randomness initiative
						{
							case 0:
								daNoteData = 0;
							case 1:
								daNoteData = 1;
							case 2:
								daNoteData = 2;
							case 3:
								daNoteData = 3;
						}
					case "onearrow":
						daNoteData = arrowLane;
					case "stair":
						daNoteData = stair % 4;
						stair++;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				if (_modifiers.WidenSwitch)
					swagNote.scale.x *= _modifiers.Widen/100 + 1;
				if (_modifiers.StretchSwitch && !swagNote.isSustainNote)
					swagNote.scale.y *= _modifiers.Stretch/100 + 1;

				var susLength:Float = swagNote.sustainLength;

				if (_modifiers.EelNotesSwitch)
					susLength += 10 * _modifiers.EelNotes;

				if (_modifiers.VibeSwitch)
					{
						switch (_modifiers.Vibe)
						{
						case 0.8:
							susLength = susLength / Conductor.stepCrochet * 0.8338 / speedNote; //somewhere around 0.832
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

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
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
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			if (_modifiers.FlippedNotes)
				noteOutput = Math.abs(3 - i);
			else
				noteOutput = Math.abs(i);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels', 'week6'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (noteOutput)
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
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
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			if (_modifiers.FlippedNotes)
			{
				babyArrow.flipX = true;
				babyArrow.flipY = true;
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.ID = i;

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

			babyArrow.animation.play('static');
			babyArrow.x += 95;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.quadInOut});
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

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
		{
			#if desktop
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
			#end
	
			super.onFocus();
		}
	
	override public function onFocusLost():Void
		{
			#if desktop
			if (health > -0.00001 && !paused)
			{
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
	
			super.onFocusLost();
		}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		if (_modifiers.OffbeatSwitch)
			{
				vocals.time = Conductor.songPosition + (512 * _modifiers.Offbeat/100);
			}
		else
			vocals.time = Conductor.songPosition;

		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}

		override public function update(elapsed:Float)
			{
				#if !debug
				perfectMode = false;
				#end
		
				if (startedCountdown)
				{
					if (_modifiers.EarthquakeSwitch)
						FlxG.cameras.shake(_modifiers.Earthquake/2000, 0.2);
		
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
								FlxG.sound.play(Paths.sound('paparazzi', 'shared'), FlxG.random.float(0.1, 0.3)*_variables.svolume/100);	
								paparazziInt = 0;
							});
						}
		
					if (_modifiers.SeasickSwitch)
						{
							FlxG.camera.angle += Math.sin(Conductor.songPosition * Conductor.bpm/100 / 500) * (0.008 * _modifiers.Seasick);
							camHUD.angle += Math.cos(Conductor.songPosition * Conductor.bpm/100 / 500) * (0.008 * _modifiers.Seasick);
							camNOTES.angle += Math.cos(Conductor.songPosition * Conductor.bpm/100 / 500) * (0.008 * _modifiers.Seasick);
						}
					
					if (_modifiers.CameraSwitch)
						{
							FlxG.camera.angle += 0.01 * _modifiers.Camera;
							camHUD.angle -= 0.01 * _modifiers.Camera;
							camNOTES.angle -= 0.01 * _modifiers.Camera;
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
		
				if (currentFrames == _variables.fps)
					{
						for(i in 0...notesHitArray.length)
						{
							var cock:Date = notesHitArray[i];
							if (cock != null)
								if (cock.getTime() + 2000 < Date.now().getTime())
									notesHitArray.remove(cock);
						}
						nps = Math.floor(notesHitArray.length / 2);
						currentFrames = 0;
					}
					else
						currentFrames++;
		
				switch (curStage)
				{
					case 'philly':
						if (trainMoving)
						{
							trainFrameTiming += elapsed;
		
							if (trainFrameTiming >= 1 / 24)
							{
								updateTrainPos();
								trainFrameTiming = 0;
							}
						}
						// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
				}
		
				super.update(elapsed);
		
				scoreTxt.text = "Score: " + songScore;
				missTxt.text = "Misses: " + misses;
				accuracyTxt.text = "Accuracy: " + truncateFloat(accuracy, 2) + "%";
				npsTxt.text = "NPS: " + nps;
		
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
						openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
					}
					
					#if desktop
					DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
					#end
				}
		
				if (FlxG.keys.justPressed.SEVEN)
				{
					canDie = false;
					FlxG.switchState(new ChartingState());
		
					#if desktop
					DiscordClient.changePresence("Charting a song", null, null, true);
					#end
				}
		
				// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
				// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);
		
				iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, zoomLerp/(_variables.fps/60))));
				iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, zoomLerp/(_variables.fps/60))));
		
				iconP1.updateHitbox();
				iconP2.updateHitbox();
		
				var iconOffset:Int = 26;
		
				iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
				iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		
				if (health > 2)
					health = 2;
		
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
						if(allowedToHeadbang)
						{
							// Don't animate GF if something else is already animating her (eg. train passing)
							if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
							{
								// Per song treatment since some songs will only have the 'Hey' at certain times
								switch(curSong)
								{
									case 'Philly':
									{
										// General duration of the song
										if(curBeat < 250)
										{
											// Beats to skip or to stop GF from cheering
											if(curBeat != 184 && curBeat != 216)
											{
												if(curBeat % 16 == 8)
												{
													// Just a garantee that it'll trigger just once
													if(!triggeredAlready)
													{
														gf.playAnim('cheer');
														triggeredAlready = true;
													}
												}else triggeredAlready = false;
											}
										}
									}
									case 'Bopeebo':
									{
										// Where it starts || where it ends
										if(curBeat > 5 && curBeat < 130)
										{
											if(curBeat % 8 == 7)
											{
												if(!triggeredAlready)
												{
													gf.playAnim('cheer');
													triggeredAlready = true;
												}
											}else triggeredAlready = false;
										}
									}
									case 'Blammed':
									{
										if(curBeat > 30 && curBeat < 190)
										{
											if(curBeat < 90 || curBeat > 128)
											{
												if(curBeat % 4 == 2)
												{
													if(!triggeredAlready)
													{
														gf.playAnim('cheer');
														triggeredAlready = true;
													}
												}else triggeredAlready = false;
											}
										}
									}
									case 'Cocoa':
									{
										if(curBeat < 170)
										{
											if(curBeat < 65 || curBeat > 130 && curBeat < 145)
											{
												if(curBeat % 16 == 15)
												{
													if(!triggeredAlready)
													{
														gf.playAnim('cheer');
														triggeredAlready = true;
													}
												}else triggeredAlready = false;
											}
										}
									}
									case 'Eggnog':
									{
										if(curBeat > 10 && curBeat != 111 && curBeat < 220)
										{
											if(curBeat % 8 == 7)
											{
												if(!triggeredAlready)
												{
													gf.playAnim('cheer');
													triggeredAlready = true;
												}
											}else triggeredAlready = false;
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
						camFollow.x = FlxMath.lerp(camFollow.x, dad.getMidpoint().x + 150, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
						camFollow.y = FlxMath.lerp(camFollow.y, dad.getMidpoint().y - 100, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
						// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
		
						switch (dad.curCharacter)
						{
							case 'mom':
								camFollow.y = FlxMath.lerp(camFollow.y, dad.getMidpoint().y, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
							case 'senpai' | 'senpai-angry':
								camFollow.x = FlxMath.lerp(camFollow.x, dad.getMidpoint().x - 190, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
								camFollow.y = FlxMath.lerp(camFollow.y, dad.getMidpoint().y - 830, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
						}
		
						if (dad.curCharacter == 'mom')
							vocals.volume = _variables.vvolume/100;
		
						if (SONG.song.toLowerCase() == 'tutorial')
						{
							tweenCamIn();
						}
					}
		
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
						{
							camFollow.x = FlxMath.lerp(camFollow.x, boyfriend.getMidpoint().x - 100, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
							camFollow.y = FlxMath.lerp(camFollow.y, boyfriend.getMidpoint().y - 100, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
			
							switch (curStage)
							{
								case 'limo':
									camFollow.x = FlxMath.lerp(camFollow.x, boyfriend.getMidpoint().x - 300, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
								case 'mall':
									camFollow.y = FlxMath.lerp(camFollow.y, boyfriend.getMidpoint().y - 200, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
								case 'school' | 'schoolEvil':
									camFollow.x = FlxMath.lerp(camFollow.x, boyfriend.getMidpoint().x - 300, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
									camFollow.y = FlxMath.lerp(camFollow.y, boyfriend.getMidpoint().y - 300, (camLerp * _variables.cameraSpeed)/(_variables.fps/60));
							}
		
						if (SONG.song.toLowerCase() == 'tutorial')
						{
							FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.quadInOut});
						}
					}
				}
		
				if (camZooming)
				{
					FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, defaultCamZoom, zoomLerp/(_variables.fps/60));
					camHUD.zoom = FlxMath.lerp(camHUD.zoom, 1, zoomLerp/(_variables.fps/60));
					camNOTES.zoom = FlxMath.lerp(camNOTES.zoom, 1, zoomLerp/(_variables.fps/60));
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
				if (controls.RESET)
				{
					canDie = true;
					health = -10;
					trace("RESET = True");
				}
		
				// CHEAT = brandon's a pussy
				if (controls.CHEAT)
				{
					health += 1;
					trace("User is cheating!");
				}
		
				if (health <= -0.00001 && canDie && !_modifiers.Practice && !ended)
				{
					lives -= 1;
		
					if (_modifiers.FreezeSwitch)
					{
						missCounter = 0;
						if (frozen)
							{
								FlxG.sound.play(Paths.sound('Ice_Shatter', 'shared'), _variables.svolume/100);
								frozen = false;
								freezeIndicator.alpha = 0;
							}
					}
		
					if (lives <= 0)
					{
						boyfriend.stunned = true;
		
						persistentUpdate = false;
						persistentDraw = false;
						paused = true;
			
						vocals.stop();
						FlxG.sound.music.stop();
			
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

						if (gameplayArea == "Endless")
							Highscore.saveEndlessScore(SONG.song.toLowerCase(), songScore);

						speed = 0;
						loops = 0;

						camHUD.angle = 0;
						camNOTES.angle = 0;
						FlxG.camera.angle = 0;
		
						FlxG.game.scaleX = 1;
						FlxG.game.x = 0;
						FlxG.game.scaleY = 1;
						FlxG.game.y = 0;
			
						// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			
						#if desktop
						// Game Over doesn't get his own variable because it's only used here
						DiscordClient.changePresence("Aw man, I died at " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
						#end
					}
					else
					{
						if (lives > 0)
						{
							FlxG.camera.flash(0xFFFF0000, 0.3 * SONG.bpm/100);
							new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
								{
									gf.playAnim('sad', true);
								});
							FlxG.sound.play(Paths.sound('missnote2', 'shared'), _variables.svolume/100);
							health = 1/_modifiers.Lives * lives;
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
						daNote.scrollFactor.set();
						daNote.cameras = [camNOTES];

						if (daNote.y > FlxG.height)
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
							speedNote = 1 + 1 * (_modifiers.NoteSpeed/100);
		
						if (_modifiers.DrunkNotesSwitch)
							noteDrunk = _modifiers.DrunkNotes * 3;
		
						if (_modifiers.AccelNotesSwitch)
							noteAccel += _modifiers.AccelNotes * 0.0001;
		
						daNote.y = ((strumLine.y - (Conductor.songPosition - daNote.strumTime + noteAccel + (_modifiers.DrunkNotes * Math.sin(Conductor.songPosition/300)))) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2) * speedNote));
		
						if (_modifiers.SnakeNotesSwitch)
							daNote.x += (_modifiers.SnakeNotes * 0.025) * Math.sin(Conductor.songPosition/300);
		
						if ((_modifiers.ShortsightedSwitch && daNote.y > FlxG.height - (FlxG.height - strumLine.y) * (_modifiers.Shortsighted/100) - 11 * _modifiers.AccelNotes))
							daNote.alpha = 0;
						else if ((_modifiers.ShortsightedSwitch && daNote.y <= FlxG.height - (FlxG.height - strumLine.y) * (_modifiers.Shortsighted/100) - 11 * _modifiers.AccelNotes))
							daNote.alpha = FlxMath.lerp(daNote.alpha, 1, miscLerp/(_variables.fps/60));
		
						if ((_modifiers.LongsightedSwitch && daNote.y > strumLine.y + (FlxG.height - strumLine.y) * (_modifiers.Longsighted/100) - 11 * _modifiers.AccelNotes))
							daNote.alpha = 1;
						else if ((_modifiers.LongsightedSwitch && daNote.y <= strumLine.y + (FlxG.height - strumLine.y) * (_modifiers.Longsighted/100) - 11 * _modifiers.AccelNotes))
							daNote.alpha = FlxMath.lerp(daNote.alpha, 0, miscLerp/(_variables.fps/60));
		
						if (_modifiers.HyperNotesSwitch)
							{
								daNote.x += 0.25 * FlxG.random.int(Std.int(_modifiers.HyperNotes * -1), Std.int(_modifiers.HyperNotes));
								daNote.y += 0.25 * FlxG.random.int(Std.int(_modifiers.HyperNotes * -1), Std.int(_modifiers.HyperNotes));
							}
		
						// i am so fucking sorry for this if condition
						if (daNote.isSustainNote
							&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
							&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
							swagRect.y /= daNote.scale.y;
							swagRect.height -= swagRect.y;
		
							daNote.clipRect = swagRect;
						}
		
						if (_modifiers.FlippedNotes && !daNote.isSustainNote)
							{
								daNote.flipX = true;
								daNote.flipY = true;
							}
		
						if (!daNote.mustPress && daNote.wasGoodHit)
						{
							if (SONG.song != 'Tutorial')
								camZooming = true;
		
							var altAnim:String = "";
		
							if (SONG.notes[Math.floor(curStep / 16)] != null)
							{
								if (SONG.notes[Math.floor(curStep / 16)].altAnim)
									altAnim = '-alt';
							}
		
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
							
							player2Strums.forEach(function(spr:FlxSprite)
								{
									if (Math.abs(daNote.noteData) == spr.ID)
									{
										spr.animation.play('confirm', true);
										sustain2(spr.ID, daNote);
									}
								});
		
							dad.holdTimer = 0;
		
							if (SONG.needsVoices)
								vocals.volume = _variables.vvolume/100;
		
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
		
						// WIP interpolation shit? Need to fix the pause issue
						// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
		
						if (daNote.y < -daNote.height - 25 * (SONG.speed) - 70 * _modifiers.NoteSpeed - 1.5 * _modifiers.DrunkNotes - 11 * _modifiers.AccelNotes - 128 * Math.abs(_modifiers.Offbeat/100))
						{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
							else
							{
								if (startedCountdown && daNote.mustPress)
								{
									if (_modifiers.HPLossSwitch)
										health -= 0.0475 * _modifiers.HPLoss;
									else
										health -= 0.0475;
			
									if (_modifiers.Perfect) // if perfect
										health = -10;
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
									if (_variables.muteMiss)
										vocals.volume = 0;
									
									songScore -= Math.floor(10 + (_variables.comboP ? 0.3*combo : 0) * MenuModifiers.fakeMP);
		
									if ((daNote.isSustainNote && !daNote.wasGoodHit) || !daNote.isSustainNote)
										{
											updateAccuracy();
											misses ++;
											combo = 0;
										}
		
									if (!frozen && _modifiers.FreezeSwitch)
									{
										missCounter++;
										freezeIndicator.alpha = missCounter / (31 - _modifiers.Freeze);
									}
		
									if (_modifiers.FreezeSwitch && missCounter >= 31 - _modifiers.Freeze)
										freezeBF();
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
							heart.angle = FlxMath.lerp(heart.angle, 30, miscLerp/(_variables.fps/60));
							heart.y = FlxMath.lerp(heart.y, FlxG.height + heart.height + 100, miscLerp/(_variables.fps/60));
							if (heart.y >= FlxG.height + heart.height)
								heart.kill();
						}
					});
		
				if (!inCutscene)
					keyShit();
		
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
						}
					}
			
					var bps:Float = Conductor.bpm/60;
					var spb:Float = 1/bps;
			
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
									} else if (length > 0) {
										strums2[0][0] = false;
										strums2[0][1] = true;
									}
								case 1:
									if (!strums2[1][0])
									{
										strums2[1][1] = true;
									} else if (length > 0) {
										strums2[1][0] = false;
										strums2[1][1] = true;
									}
								case 2:
									if (!strums2[2][0])
									{
										strums2[2][1] = true;
									} else if (length > 0) {
										strums2[2][0] = false;
										strums2[2][1] = true;
									}
								case 3:
									if (!strums2[3][0])
									{
										strums2[3][1] = true;
									} else if (length > 0) {
										strums2[3][0] = false;
										strums2[3][1] = true;
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

					if (SONG.validScore)
						{
							#if !switch
							Highscore.saveScore(SONG.song, songScore, storyDifficulty);
							#end
						}	
				}
		
				canDie = false;
				ended = true;
		
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
		
							if (SONG.validScore)
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
		
								FlxG.sound.play(Paths.sound('Lights_Shut_off', 'shared'), _variables.svolume/100);
							}
		
							FlxTransitionableState.skipNextTransIn = true;
							FlxTransitionableState.skipNextTransOut = true;
							prevCamFollow = camFollow;
							openSubState(new RankingSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

							new FlxTimer().start(0.1, function(tmr:FlxTimer)
								{
									camHUD.alpha -= 1 / 10;
									camNOTES.alpha -= 1 / 10;
								}, 10);
						}
					case "Freeplay":
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
							{
								camHUD.alpha -= 1 / 10;
								camNOTES.alpha -= 1 / 10;
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

							Highscore.saveMarathonScore(campaignScore);
		
							switch (_variables.music)
            				{
    			            	case 'classic':
    			            	    FlxG.sound.playMusic(Paths.music('freakyMenu'), _variables.mvolume/100);
									Conductor.changeBPM(102);
    			            	case 'funky':
    			            	    FlxG.sound.playMusic(Paths.music('funkyMenu'), _variables.mvolume/100);
									Conductor.changeBPM(140);
    			        	}
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

						#if desktop
						detailsText = "Endless: Loop "+ loops;
						DiscordClient.changePresence(detailsText, SONG.song, iconRPC, true);
						#end

						FlxG.sound.music.volume = _variables.mvolume/100;
						vocals.volume = _variables.vvolume/100;

						canPause = true;
						canDie = true;
						ended = false;

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
				}
			}
		
			var endingSong:Bool = false;
		
			var hits:Array<Float> = [];
			var timeShown = 0;
			var currentTimingShown:FlxText = null;
		
private function popUpScore(strumtime:Float):Void
	{
				var noteDiff:Float = strumtime - Conductor.songPosition;
				// boyfriend.playAnim('hey');
				vocals.volume = _variables.vvolume/100;
		
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
		
				//Sweet Math.abs
		
				if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.9)
				{
					daRating = 'shit';
					score = 50;
					shits++;
				}
				else if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.75)
				{
					daRating = 'bad';
					score = 100;
					bads++;
				}
				else if (Math.abs(noteDiff) > Conductor.safeZoneOffset * 0.2)
				{
					daRating = 'good';
					score = 200;
					goods++;
				}
		
				if (daRating == "sick")
					sicks++;
		
				if (noteDiff > Conductor.safeZoneOffset * 0.1)
					daTiming = "early";
				else if (noteDiff < Conductor.safeZoneOffset * -0.1)
					daTiming = "late";
		
				switch (_variables.accuracyType)
				{
					case 'simple':
						totalNotesHit += 1;
					case 'complex':
						if (noteDiff > Conductor.safeZoneOffset * Math.abs(0.1))
							totalNotesHit += 1 - Math.abs(noteDiff/200); //seems like the sweet spot
						else
							totalNotesHit += 1;  //this feels so much better than you think, and saves up code space
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
		
				songScore += Math.floor((score + (_variables.comboP ? 2*combo : 0)) * MenuModifiers.fakeMP);
		
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
		
				if (pixelShitPart2 == '')
					timing.loadGraphic(Paths.image(pixelShitPart1 + daTiming + pixelShitPart2, 'shared'));
				else
					timing.loadGraphic(Paths.image(pixelShitPart1 + daTiming + pixelShitPart2, 'week6'));
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
		
				if (currentTimingShown != null)
					remove(currentTimingShown);
		
				currentTimingShown = new FlxText(0,0,0,"0ms");
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
		
				var seperatedScore:Array<Int> = [];
				
				var comboSplit:Array<String> = (combo + "").split('');
		
				if (comboSplit.length == 2)
					seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!
		
				for(i in 0...comboSplit.length)
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
		
					if ((combo >= 10 || combo == 0) && _variables.comboDisplay)
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
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;	

	var noteHit:Int = 0;
	private function keyShit():Void // I've invested in emma stocks
		{
			// control arrays, order L D R U
			var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
			var pressArray:Array<Bool> = [
				controls.LEFT_P,
				controls.DOWN_P,
				controls.UP_P,
				controls.RIGHT_P
			];
			var releaseArray:Array<Bool> = [
				controls.LEFT_R,
				controls.DOWN_R,
				controls.UP_R,
				controls.RIGHT_R
			];
	 
	 
			// HOLDS, check for sustain notes
			if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && !frozen && !ended)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
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
				else if (possibleNotes.length > 0 && !dontCheck)
				{
					for (coolNote in possibleNotes)
					{
						if (pressArray[coolNote.noteData])
						{
							if (mashViolations != 0)
								mashViolations--;
							scoreTxt.color = FlxColor.WHITE;
							goodNoteHit(coolNote);
						}
					}
				}

				if(dontCheck && possibleNotes.length > 0)
				{
					if (mashViolations > 4)
					{
						trace('mash violations ' + mashViolations);
						scoreTxt.color = FlxColor.RED;
						noteMiss(0);
					}
					else
						mashViolations++;
				}

			}
			
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true)))
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					boyfriend.playAnim('idle');
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

	function noteMiss(direction:Int = 1):Void
		{
		if (!boyfriend.stunned)
		{
			if (_modifiers.HPLossSwitch)
				health -= 0.04 * _modifiers.HPLoss;
			else
				health -= 0.04;

			if (_modifiers.Perfect) // if perfect
				health = -10;

			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}

			misses++;

			if (!frozen && _modifiers.FreezeSwitch)
				{
					missCounter++;
					freezeIndicator.alpha = missCounter / (31 - _modifiers.Freeze);
				}

			songScore -= Math.floor(10 + (_variables.comboP ? 0.3*combo : 0) * MenuModifiers.fakeMP);

			combo = 0;
			updateAccuracy();

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3, 'shared'), FlxG.random.float(0.1, 0.2)*_variables.svolume/100);
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});

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

			if (_modifiers.FreezeSwitch && missCounter >= 31 - _modifiers.Freeze)
				freezeBF();
		}
	}

	function freezeBF():Void
	{
		frozen = true;
		missCounter = 0;
		FlxG.sound.play(Paths.sound('Ice_Appear', 'shared'), _variables.svolume/100);
		boyfriend.playAnim('frozen', true);
		freezeIndicator.alpha = 1;
		new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				missCounter = 0;
				freezeIndicator.alpha = 0;
				FlxG.sound.play(Paths.sound('Ice_Shatter', 'shared'), _variables.svolume/100);
				frozen = false;
				boyfriend.playAnim('idle', true);
					if (_modifiers.FrightSwitch)
					{
						if (_modifiers.Fright >= 50 && _modifiers.Fright < 100)
							boyfriend.playAnim('scared', true);
						else if (_modifiers.Fright >= 100)
							boyfriend.playAnim('worried', true);
					}
			});
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var doNothing:Bool = false;
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit)
				doNothing = true;
		});
		if (!doNothing) {
			Note.setCanMiss(0, true);
			Note.setCanMiss(1, true);
			Note.setCanMiss(2, true);
			Note.setCanMiss(3, true);
		}
		//if (canMiss) {
			if (leftP && Note.canMissLeft)
				noteMiss(0);
			if (downP && Note.canMissDown)
				noteMiss(1);
			if (upP && Note.canMissUp)
				noteMiss(2);
			if (rightP && Note.canMissRight)
				noteMiss(3);
		//}
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
		if (!note.wasGoodHit)
		{
				if (mashing != 0)
					mashing = 0;
				
				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;
		
				if (mashViolations < 0)
					mashViolations = 0;
			
				if (!note.isSustainNote)
				{
					notesHitArray.push(Date.now());
					popUpScore(note.strumTime);
					combo += 1;
				}
	
				if (note.isSustainNote)
					totalNotesHit += 1;
	
				if (note.noteData >= 0)
				{
					if (_modifiers.HPGainSwitch)
						health += 0.023 * _modifiers.HPGain;
					else
						health += 0.023;
				}
				else
				{
					if (_modifiers.HPGainSwitch)
						health += 0.004 * _modifiers.HPGain;
					else
						health += 0.004;
				}
	
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
	
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.animation.play('confirm', true);
					}
				});
	
				note.wasGoodHit = true;
				vocals.volume = _variables.vvolume/100;
	
				if (!note.isSustainNote)
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
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

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
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
			camNOTES.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
			camNOTES.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

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

				if (FlxG.random.bool(10) && fastCarCanDrive)
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

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	var curLight:Int = 0;
}

package;

import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

using StringTools;

class ModifiersState extends MusicBeatState
{

    var ModiWindow:FlxSprite;
    var BG1:FlxSprite;

    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String> = ['Practice', 'Three Lives', 'Perfect', 'Lights Out', 'Blinding', 'HP Loss M', 'HP Loss P', 'HP Gain M', 'HP Gain P', 'No HP Gain', 'Low HP', 'High HP', 'Enigma', 'Lofi', 'Hifi', 'Offbeat', 'L Zones', 'S Zones', 'P Zones', 'Slow Notes', 'Fast Notes', 'Inv Notes', 'Snake Notes', 'Drunk Notes', 'Accel Notes', 'Vnsh Notes', 'Flip Notes', 'Hyper Notes', 'Eel Notes', 'Stretch Up', 'Widen Up', 'Seasick', 'Upside Down', 'Camera Spin', 'Earthquake', 'Paparazzi', 'Sup Love', 'Psn Fright', 'Stagefright', 'ZZZ', 'ZZZZZZZ'];

    var songs:Array<Dynamic> = [ 
        ['Practice'], 
        ['Three Lives'],
        ['Perfect'],
        ['Lights Out'],
        ['Blinding'],
        ['HP Loss M'],
        ['HP Loss P'],
        ['HP Gain M'],
        ['HP Gain P'],
        ['No HP Gain'],
        ['Low HP'],
        ['High HP'],
        ['Enigma'], 
        ['Lofi Music'],
        ['Hifi Music'],
        ['Offbeat'],
        ['L Zones'], 
        ['S Zones'], 
        ['P Zones'],
        ['Slow Notes'],
        ['Fast Notes'],
        ['Inv Notes'],
        ['Snake Notes'],
        ['Drunk Notes'],
        ['Accel Notes'],
        ['Vnsh Notes'],
        ['Flip Notes'],
        ['Hyper Notes'],
        ['Eel Notes'],
        ['Stretch Up'],
        ['Widen Up'],
        ['Seasick'], 
        ['Upside Down'], 
        ['Camera Spin'],
        ['Earthquake'],
        ['Paparazzi'],
        ['Sup Love'],
        ['Psn Fright'],
        ['Stagefright']
    ];
    private var grpSongs:FlxTypedGroup<Alphabet>;
    var selectedSomethin:Bool = false;
    var curSelected:Int = 0;
    var camFollow:FlxObject;

    public static var Practice_Selected:Int = 1; //1 = unactivated, 0 = activated
    public static var FastNotes_Selected:Float = 0; //0 = unactivated, 0.5 = activated
    public static var SlowNotes_Selected:Float = 0; //0 = unactivated, 0.5 = activated
    public static var Perfect_Selected:Int = 1; //0 = unactivated, 1 = activated
    public static var InvNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var HPLossM_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var HPLossP_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var HPGainM_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var HPGainP_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var DrunkNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var SnakeNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var SupLove_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var PsnFright_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var AccelNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var ThreeLives_Selected:Float = 1; //0 = unactivated, 1 = activated
    public static var LightsOut_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Blinding_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var VnshNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var FlipNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Seasick_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var UpsideDown_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var CameraSpin_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Earthquake_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var LowHP_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var HighHP_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var NoHPGain_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Enigma_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var LZones_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var SZones_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var PZones_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var HyperNotes_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Stagefright_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Paparazzi_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Hifi_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Lofi_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var StretchUp_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var WidenUp_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var Offbeat_Selected:Float = 0; //0 = unactivated, 1 = activated
    public static var EelNotes_Selected:Float = 1; //0 = unactivated, 1 = activated


    public static var ScoreRate:Float = 1;
    public static var ScoreMultiplier:Float = 1;
    public static var NoteSpeed:Float = 1; //1 = normal speed, 1.6 = fast speed, 0.6 = slow speed
    public static var HPLoss:Float = 1; //1 = normal speed, 1.5 = fast speed, 0.5 = slow speed
    public static var HPGain:Float = 1; //1 = normal speed, 1.5 = fast speed, 0.5 = slow speed
    public static var Regen:Float = 0; //1 = normal speed, 1.5 = fast speed, 0.5 = slow speed   
    public static var NoteAccel:Float = 0; //1 = normal speed, 1.5 = fast speed, 0.5 = slow speed  
    public static var HPChange:Float = 0;
    public static var ZoneOffset:Float = 1;
    public static var FiChange:Float = 1;


    public static var CheckmarkPractice:Bool = false;
    public static var CheckmarkFastNotes:Bool = false;
    public static var CheckmarkSlowNotes:Bool = false;
    public static var CheckmarkPerfect:Bool = false;
    public static var CheckmarkInvNotes:Bool = false;
    public static var CheckmarkHPLossM:Bool = false;
    public static var CheckmarkHPLossP:Bool = false;
    public static var CheckmarkHPGainM:Bool = false;
    public static var CheckmarkHPGainP:Bool = false;
    public static var CheckmarkSnakeNotes:Bool = false;
    public static var CheckmarkDrunkNotes:Bool = false;
    public static var CheckmarkSupLove:Bool = false;
    public static var CheckmarkPsnFright:Bool = false;
    public static var CheckmarkAccelNotes:Bool = false;
    public static var CheckmarkThreeLives:Bool = false;
    public static var CheckmarkLightsOut:Bool = false;
    public static var CheckmarkBlinding:Bool = false;
    public static var CheckmarkVnshNotes:Bool = false;
    public static var CheckmarkFlipNotes:Bool = false;
    public static var CheckmarkSeasick:Bool = false;
    public static var CheckmarkUpsideDown:Bool = false;
    public static var CheckmarkCameraSpin:Bool = false;
    public static var CheckmarkEarthquake:Bool = false;
    public static var CheckmarkLowHP:Bool = false;
    public static var CheckmarkHighHP:Bool = false;
    public static var CheckmarkNoHPGain:Bool = false;
    public static var CheckmarkEnigma:Bool = false;
    public static var CheckmarkLZones:Bool = false;
    public static var CheckmarkSZones:Bool = false;
    public static var CheckmarkPZones:Bool = false;
    public static var CheckmarkHyperNotes:Bool = false;
    public static var CheckmarkStagefright:Bool = false;
    public static var CheckmarkPaparazzi:Bool = false;
    public static var CheckmarkLofi:Bool = false;
    public static var CheckmarkHifi:Bool = false;
    public static var CheckmarkOffbeat:Bool = false;
    public static var CheckmarkStretchUp:Bool = false;
    public static var CheckmarkWidenUp:Bool = false;
    public static var CheckmarkEelNotes:Bool = false;

    var RateText:FlxText = new FlxText(20, 565, FlxG.width, "SCORE RATE:\n"+ScoreMultiplier+"x", 48);
    var ExplainText:FlxText = new FlxText(20, 132, FlxG.width, " ", 48);

    var Checkmark_Practice:FlxSprite = new FlxSprite(605, 66).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_ThreeLives:FlxSprite = new FlxSprite(605, 226).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Perfect:FlxSprite = new FlxSprite(605, 386).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_LightsOut:FlxSprite = new FlxSprite(605, 546).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Blinding:FlxSprite = new FlxSprite(605, 706).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_HPLossM:FlxSprite = new FlxSprite(605, 886).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_HPLossP:FlxSprite = new FlxSprite(605, 1026).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_HPGainM:FlxSprite = new FlxSprite(605, 1186).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_HPGainP:FlxSprite = new FlxSprite(605, 1346).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_NoHPGain:FlxSprite = new FlxSprite(605, 1506).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_LowHP:FlxSprite = new FlxSprite(605, 1666).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_HighHP:FlxSprite = new FlxSprite(605, 1826).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Enigma:FlxSprite = new FlxSprite(605, 1986).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Lofi:FlxSprite = new FlxSprite(605, 1986).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Hifi:FlxSprite = new FlxSprite(605, 1986).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_LZones:FlxSprite = new FlxSprite(605, 2146).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_SZones:FlxSprite = new FlxSprite(605, 2306).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_PZones:FlxSprite = new FlxSprite(605, 2466).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_SlowNotes:FlxSprite = new FlxSprite(605, 2626).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_FastNotes:FlxSprite = new FlxSprite(605, 2786).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_InvNotes:FlxSprite = new FlxSprite(605, 2946).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_SnakeNotes:FlxSprite = new FlxSprite(605, 3106).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_DrunkNotes:FlxSprite = new FlxSprite(605, 3266).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_AccelNotes:FlxSprite = new FlxSprite(605, 3426).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_VnshNotes:FlxSprite = new FlxSprite(605, 3586).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_FlipNotes:FlxSprite = new FlxSprite(605, 3746).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_HyperNotes:FlxSprite = new FlxSprite(605, 3906).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Seasick:FlxSprite = new FlxSprite(605, 4066).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_UpsideDown:FlxSprite = new FlxSprite(605, 4226).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_CameraSpin:FlxSprite = new FlxSprite(605, 4386).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Earthquake:FlxSprite = new FlxSprite(605, 4546).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Paparazzi:FlxSprite = new FlxSprite(605, 4706).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_SupLove:FlxSprite = new FlxSprite(605, 4886).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_PsnFright:FlxSprite = new FlxSprite(605, 5026).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Stagefright:FlxSprite = new FlxSprite(605, 5186).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_EelNotes:FlxSprite = new FlxSprite(605, 4706).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_Offbeat:FlxSprite = new FlxSprite(605, 4886).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_StretchUp:FlxSprite = new FlxSprite(605, 5026).loadGraphic('assets/images/Checkmark.png');
    var Checkmark_WidenUp:FlxSprite = new FlxSprite(605, 5186).loadGraphic('assets/images/Checkmark.png');

    override function create()
    {

        persistentUpdate = persistentDraw = true;

        if (FlxG.sound.music != null)
        {
            if (!FlxG.sound.music.playing)
                FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, TitleState.Music_Volume/100);
        }

        var BG1 = new FlxSprite(0, -47).loadGraphic('assets/images/Modifiers_BG.png');
        add(BG1);
        BG1.scrollFactor.x = 0;
		BG1.scrollFactor.y = 0.05;

        ModiWindow = new FlxSprite(60, 60).loadGraphic('assets/images/Modifiers_Window.png');
		ModiWindow.setGraphicSize(Std.int(ModiWindow.width * 0.8));
		ModiWindow.updateHitbox();
        ModiWindow.antialiasing = true;
        ModiWindow.scrollFactor.x = 0;
		ModiWindow.scrollFactor.y = 0;
        add(ModiWindow);

        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);
        

		var tex = FlxAtlasFrames.fromSparrow('assets/images/Modifiers.png', 'assets/images/Modifiers.xml');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(580, 30 + (i * 160));
			menuItem.frames = tex;
            menuItem.animation.addByPrefix('Idle', optionShit[i] + " Idle", 24, true);
            menuItem.animation.addByPrefix('Select', optionShit[i] + " Select", 24, true);
			menuItem.animation.play('Idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
            menuItem.antialiasing = true;
            menuItem.scrollFactor.x = 0;
            menuItem.scrollFactor.y = 1;
        }

        grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (160 * i) + 66, songs[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
            songText.x = 740;
            songText.scrollFactor.x = 0;
            songText.scrollFactor.y = 1;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
        }

		add(RateText);
        RateText.scrollFactor.x = 0;
        RateText.scrollFactor.y = 0;
        RateText.setFormat("VCR OSD Mono", 28, FlxColor.WHITE, CENTER);
        RateText.x = -350;
        RateText.setBorderStyle(OUTLINE_FAST, 0xFF000000, 2, 0.5);

        add(ExplainText);
        ExplainText.scrollFactor.x = 0;
        ExplainText.scrollFactor.y = 0;
        ExplainText.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, CENTER);
        ExplainText.x = -355;
        ExplainText.setBorderStyle(OUTLINE_FAST, 0xFF000000, 2, 0.5);

        camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

        FlxG.camera.follow(camFollow, null, 0.06);
        
        changeItem();

        CreateCheckmark();

        PositionCheckmark();

        LoadModifiers();

        UpdateCheckmark();

        UpdateScorerate();

		super.create();
        
    }

    function CreateCheckmark():Void
    {
        add(Checkmark_Practice);
        Checkmark_Practice.scrollFactor.set(0, 1);
        add(Checkmark_FastNotes);
        Checkmark_FastNotes.scrollFactor.set(0, 1);
        add(Checkmark_SlowNotes);
        Checkmark_SlowNotes.scrollFactor.set(0, 1);
        add(Checkmark_Perfect);
        Checkmark_Perfect.scrollFactor.set(0, 1);
        add(Checkmark_InvNotes);
        Checkmark_InvNotes.scrollFactor.set(0, 1);
        add(Checkmark_HPLossM);
        Checkmark_HPLossM.scrollFactor.set(0, 1);
        add(Checkmark_HPLossP);
        Checkmark_HPLossP.scrollFactor.set(0, 1);
        add(Checkmark_HPGainM);
        Checkmark_HPGainM.scrollFactor.set(0, 1);
        add(Checkmark_HPGainP);
        Checkmark_HPGainP.scrollFactor.set(0, 1);
        add(Checkmark_DrunkNotes);
        Checkmark_DrunkNotes.scrollFactor.set(0, 1);
        add(Checkmark_SnakeNotes);
        Checkmark_SnakeNotes.scrollFactor.set(0, 1);
        add(Checkmark_SupLove);
        Checkmark_SupLove.scrollFactor.set(0, 1);
        add(Checkmark_PsnFright);
        Checkmark_PsnFright.scrollFactor.set(0, 1);
        add(Checkmark_AccelNotes);
        Checkmark_AccelNotes.scrollFactor.set(0, 1);
        add(Checkmark_ThreeLives);
        Checkmark_ThreeLives.scrollFactor.set(0, 1);
        add(Checkmark_LightsOut);
        Checkmark_LightsOut.scrollFactor.set(0, 1);
        add(Checkmark_Blinding);
        Checkmark_Blinding.scrollFactor.set(0, 1);
        add(Checkmark_VnshNotes);
        Checkmark_VnshNotes.scrollFactor.set(0, 1);
        add(Checkmark_FlipNotes);
        Checkmark_FlipNotes.scrollFactor.set(0, 1);
        add(Checkmark_Seasick);
        Checkmark_Seasick.scrollFactor.set(0, 1);
        add(Checkmark_UpsideDown);
        Checkmark_UpsideDown.scrollFactor.set(0, 1);
        add(Checkmark_CameraSpin);
        Checkmark_CameraSpin.scrollFactor.set(0, 1);
        add(Checkmark_Earthquake);
        Checkmark_Earthquake.scrollFactor.set(0, 1);
        add(Checkmark_LowHP);
        Checkmark_LowHP.scrollFactor.set(0, 1);
        add(Checkmark_HighHP);
        Checkmark_HighHP.scrollFactor.set(0, 1);
        add(Checkmark_NoHPGain);
        Checkmark_NoHPGain.scrollFactor.set(0, 1);
        add(Checkmark_Enigma);
        Checkmark_Enigma.scrollFactor.set(0, 1);
        add(Checkmark_LZones);
        Checkmark_LZones.scrollFactor.set(0, 1);
        add(Checkmark_SZones);
        Checkmark_SZones.scrollFactor.set(0, 1);
        add(Checkmark_PZones);
        Checkmark_PZones.scrollFactor.set(0, 1);
        add(Checkmark_HyperNotes);
        Checkmark_HyperNotes.scrollFactor.set(0, 1);
        add(Checkmark_Stagefright);
        Checkmark_Stagefright.scrollFactor.set(0, 1);
        add(Checkmark_Paparazzi);
        Checkmark_Paparazzi.scrollFactor.set(0, 1);
        add(Checkmark_Lofi);
        Checkmark_Lofi.scrollFactor.set(0, 1);
        add(Checkmark_Hifi);
        Checkmark_Hifi.scrollFactor.set(0, 1);
        add(Checkmark_StretchUp);
        Checkmark_StretchUp.scrollFactor.set(0, 1);
        add(Checkmark_WidenUp);
        Checkmark_WidenUp.scrollFactor.set(0, 1);
        add(Checkmark_Offbeat);
        Checkmark_Offbeat.scrollFactor.set(0, 1);
        add(Checkmark_EelNotes);
        Checkmark_EelNotes.scrollFactor.set(0, 1);
    }

    function PositionCheckmark():Void //this is a much better method of positioning them
    {
        Checkmark_Practice.y = 66;
        Checkmark_ThreeLives.y = Checkmark_Practice.y + 160;
        Checkmark_Perfect.y = Checkmark_ThreeLives.y+ 160;
        Checkmark_LightsOut.y = Checkmark_Perfect.y+ 160;
        Checkmark_Blinding.y = Checkmark_LightsOut.y+ 160;
        Checkmark_HPLossM.y = Checkmark_Blinding.y+ 160;
        Checkmark_HPLossP.y = Checkmark_HPLossM.y+ 160;
        Checkmark_HPGainM.y = Checkmark_HPLossP.y+ 160;
        Checkmark_HPGainP.y = Checkmark_HPGainM.y+ 160;
        Checkmark_NoHPGain.y = Checkmark_HPGainP.y+ 160;
        Checkmark_LowHP.y = Checkmark_NoHPGain.y+ 160;
        Checkmark_HighHP.y = Checkmark_LowHP.y+ 160;
        Checkmark_Enigma.y = Checkmark_HighHP.y+ 160;
        Checkmark_Lofi.y = Checkmark_Enigma.y+ 160;
        Checkmark_Hifi.y = Checkmark_Lofi.y+ 160;
        Checkmark_Offbeat.y = Checkmark_Hifi.y+ 160;
        Checkmark_LZones.y = Checkmark_Offbeat.y+ 160;
        Checkmark_SZones.y = Checkmark_LZones.y+ 160;
        Checkmark_PZones.y = Checkmark_SZones.y+ 160;
        Checkmark_SlowNotes.y = Checkmark_PZones.y+ 160;
        Checkmark_FastNotes.y = Checkmark_SlowNotes.y+ 160;
        Checkmark_InvNotes.y = Checkmark_FastNotes.y+ 160;
        Checkmark_SnakeNotes.y = Checkmark_InvNotes.y+ 160;
        Checkmark_DrunkNotes.y = Checkmark_SnakeNotes.y+ 160;
        Checkmark_AccelNotes.y = Checkmark_DrunkNotes.y+ 160;
        Checkmark_VnshNotes.y = Checkmark_AccelNotes.y+ 160;
        Checkmark_FlipNotes.y = Checkmark_VnshNotes.y+ 160;
        Checkmark_HyperNotes.y = Checkmark_FlipNotes.y+ 160;
        Checkmark_EelNotes.y = Checkmark_HyperNotes.y+ 160;
        Checkmark_StretchUp.y = Checkmark_EelNotes.y+ 160;
        Checkmark_WidenUp.y = Checkmark_StretchUp.y+ 160;
        Checkmark_Seasick.y = Checkmark_WidenUp.y+ 160;
        Checkmark_UpsideDown.y = Checkmark_Seasick.y+ 160;
        Checkmark_CameraSpin.y = Checkmark_UpsideDown.y+ 160;
        Checkmark_Earthquake.y = Checkmark_CameraSpin.y+ 160;
        Checkmark_Paparazzi.y = Checkmark_Earthquake.y+ 160;
        Checkmark_SupLove.y = Checkmark_Paparazzi.y+ 160;
        Checkmark_PsnFright.y = Checkmark_SupLove.y+ 160;
        Checkmark_Stagefright.y = Checkmark_PsnFright.y+ 160;
    }

    function UpdateScorerate():Void
    {
        ScoreRate = (1+Blinding_Selected+LightsOut_Selected+FastNotes_Selected-SlowNotes_Selected+InvNotes_Selected-HPLossM_Selected+HPLossP_Selected+HPGainM_Selected-HPGainP_Selected+SnakeNotes_Selected+DrunkNotes_Selected-SupLove_Selected+PsnFright_Selected+AccelNotes_Selected+VnshNotes_Selected+FlipNotes_Selected+Seasick_Selected+UpsideDown_Selected+CameraSpin_Selected+Earthquake_Selected+LowHP_Selected-HighHP_Selected+NoHPGain_Selected+Enigma_Selected-LZones_Selected+SZones_Selected+PZones_Selected+HyperNotes_Selected+Stagefright_Selected+Paparazzi_Selected+Offbeat_Selected+StretchUp_Selected+WidenUp_Selected+Hifi_Selected-Lofi_Selected)*Perfect_Selected*ThreeLives_Selected*Practice_Selected*EelNotes_Selected;
        ScoreMultiplier = ScoreRate;

        if (ScoreMultiplier <= 0.1)
            switch (CheckmarkPractice||CheckmarkEelNotes)
            {
                case true:
                    ScoreMultiplier = 0;
                case false:
                    ScoreMultiplier = 0.1;
            }


        RateText.text = "SCORE RATE:\n"+ScoreMultiplier+"x";
    }

    function UpdateCheckmark():Void
    {

        switch (CheckmarkPractice)
                {
                    case true:
                        Checkmark_Practice.visible = true;
                    case false:
                        Checkmark_Practice.visible = false;
                }

                switch (CheckmarkFastNotes)
                {
                    case true:
                        Checkmark_FastNotes.visible = true;
                    case false:
                        Checkmark_FastNotes.visible = false;
                }

                switch (CheckmarkSlowNotes)
                {
                    case true:
                        Checkmark_SlowNotes.visible = true;
                    case false:
                        Checkmark_SlowNotes.visible = false;
                }

                switch (CheckmarkPerfect)
                {
                    case true:
                        Checkmark_Perfect.visible = true;
                    case false:
                        Checkmark_Perfect.visible = false;
                }

                switch (CheckmarkInvNotes)
                {
                    case true:
                        Checkmark_InvNotes.visible = true;
                    case false:
                        Checkmark_InvNotes.visible = false;
                }

                switch (CheckmarkHPLossM)
                {
                    case true:
                        Checkmark_HPLossM.visible = true;
                    case false:
                        Checkmark_HPLossM.visible = false;
                }
                                    
                switch (CheckmarkHPLossP)
                {
                    case true:
                        Checkmark_HPLossP.visible = true;
                    case false:
                        Checkmark_HPLossP.visible = false;
                }

                switch (CheckmarkHPGainM)
                {
                    case true:
                        Checkmark_HPGainM.visible = true;
                    case false:
                        Checkmark_HPGainM.visible = false;
                }
                                    
                switch (CheckmarkHPGainP)
                {
                    case true:
                        Checkmark_HPGainP.visible = true;
                    case false:
                        Checkmark_HPGainP.visible = false;
                }

                switch (CheckmarkDrunkNotes)
                {
                    case true:
                        Checkmark_DrunkNotes.visible = true;
                    case false:
                        Checkmark_DrunkNotes.visible = false;
                }
                switch (CheckmarkSnakeNotes)
                {
                    case true:
                        Checkmark_SnakeNotes.visible = true;
                    case false:
                        Checkmark_SnakeNotes.visible = false;
                }
                switch (CheckmarkSupLove)
                {
                    case true:
                        Checkmark_SupLove.visible = true;
                    case false:
                        Checkmark_SupLove.visible = false;
                }   
                switch (CheckmarkPsnFright)
                {
                    case true:
                        Checkmark_PsnFright.visible = true;
                    case false:
                        Checkmark_PsnFright.visible = false;
                }
                switch (CheckmarkAccelNotes)
                {
                    case true:
                        Checkmark_AccelNotes.visible = true;
                    case false:
                        Checkmark_AccelNotes.visible = false;
                }
                switch (CheckmarkThreeLives)
                {
                    case true:
                        Checkmark_ThreeLives.visible = true;
                    case false:
                        Checkmark_ThreeLives.visible = false;
                }

                switch (CheckmarkLightsOut)
                {
                    case true:
                        Checkmark_LightsOut.visible = true;
                    case false:
                        Checkmark_LightsOut.visible = false;
                }
            
                switch (CheckmarkBlinding)
                {
                    case true:
                        Checkmark_Blinding.visible = true;
                    case false:
                        Checkmark_Blinding.visible = false;
                }

                switch (CheckmarkVnshNotes)
                {
                    case true:
                        Checkmark_VnshNotes.visible = true;
                    case false:
                        Checkmark_VnshNotes.visible = false;
                }
                                         
                switch (CheckmarkSeasick)
                {
                    case true:
                        Checkmark_Seasick.visible = true;
                    case false:
                        Checkmark_Seasick.visible = false;
                }
                switch (CheckmarkUpsideDown)
                {
                    case true:
                        Checkmark_UpsideDown.visible = true;
                    case false:
                        Checkmark_UpsideDown.visible = false;
                }
                                         
                switch (CheckmarkCameraSpin)
                {
                    case true:
                        Checkmark_CameraSpin.visible = true;
                    case false:
                        Checkmark_CameraSpin.visible = false;
                }
                switch (CheckmarkFlipNotes)
                {
                    case true:
                        Checkmark_FlipNotes.visible = true;
                    case false:
                        Checkmark_FlipNotes.visible = false;
                }
                switch (CheckmarkEarthquake)
                {
                    case true:
                        Checkmark_Earthquake.visible = true;
                    case false:
                        Checkmark_Earthquake.visible = false;
                }
                switch (CheckmarkHighHP)
                {
                    case true:
                        Checkmark_HighHP.visible = true;
                    case false:
                        Checkmark_HighHP.visible = false;
                }
                switch (CheckmarkLowHP)
                {
                    case true:
                        Checkmark_LowHP.visible = true;
                    case false:
                        Checkmark_LowHP.visible = false;
                }
                switch (CheckmarkNoHPGain)
                {
                    case true:
                        Checkmark_NoHPGain.visible = true;
                    case false:
                        Checkmark_NoHPGain.visible = false;
                }
                switch (CheckmarkEnigma)
                {
                    case true:
                        Checkmark_Enigma.visible = true;
                    case false:
                        Checkmark_Enigma.visible = false;
                }
                switch (CheckmarkLZones)
                {
                    case true:
                        Checkmark_LZones.visible = true;
                    case false:
                        Checkmark_LZones.visible = false;
                }
                switch (CheckmarkSZones)
                {
                    case true:
                        Checkmark_SZones.visible = true;
                    case false:
                        Checkmark_SZones.visible = false;
                }
                switch (CheckmarkPZones)
                {
                    case true:
                        Checkmark_PZones.visible = true;
                    case false:
                        Checkmark_PZones.visible = false;
                }
                switch (CheckmarkHyperNotes)
                {
                    case true:
                        Checkmark_HyperNotes.visible = true;
                    case false:
                        Checkmark_HyperNotes.visible = false;
                }
                switch (CheckmarkStagefright)
                {
                    case true:
                        Checkmark_Stagefright.visible = true;
                    case false:
                        Checkmark_Stagefright.visible = false;
                }
                switch (CheckmarkPaparazzi)
                {
                    case true:
                        Checkmark_Paparazzi.visible = true;
                    case false:
                        Checkmark_Paparazzi.visible = false;
                }
                switch (CheckmarkHifi)
                {
                    case true:
                        Checkmark_Hifi.visible = true;
                    case false:
                        Checkmark_Hifi.visible = false;
                }
                switch (CheckmarkLofi)
                {
                    case true:
                        Checkmark_Lofi.visible = true;
                    case false:
                        Checkmark_Lofi.visible = false;
                }
                switch (CheckmarkEelNotes)
                {
                    case true:
                        Checkmark_EelNotes.visible = true;
                    case false:
                        Checkmark_EelNotes.visible = false;
                }
                switch (CheckmarkOffbeat)
                {
                    case true:
                        Checkmark_Offbeat.visible = true;
                    case false:
                        Checkmark_Offbeat.visible = false;
                }
                switch (CheckmarkWidenUp)
                {
                    case true:
                        Checkmark_WidenUp.visible = true;
                    case false:
                        Checkmark_WidenUp.visible = false;
                }
                switch (CheckmarkStretchUp)
                {
                    case true:
                        Checkmark_StretchUp.visible = true;
                    case false:
                        Checkmark_StretchUp.visible = false;
                }
    }

    override function update(elapsed:Float)
        {
            if (!selectedSomethin)
                {
                    if (controls.UP_P)
                    {
                        FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                        changeItem(-1);
                    }
        
                    if (controls.DOWN_P)
                    {
                        FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                        changeItem(1);
                    }
                }
            if (controls.BACK)
                {
                    FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    if (PlayState.isStoryMode)
                        FlxG.switchState(new StoryMenuState());
                    else
                        FlxG.switchState(new FreeplayState());
                }
            if (controls.ACCEPT)
            {
                if (optionShit[curSelected] == 'ZZZZZZZ')
                {
                    selectedSomethin = true;
                    FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    new FlxTimer().start(1, function(tmr:FlxTimer)
                        {
                            if (FlxG.sound.music != null)
                              FlxG.sound.music.stop();
                          FlxG.switchState(new PlayState());
                      });
                }
                else if (optionShit[curSelected] == 'ZZZ')
                {
                    FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    ClearModifiers();

                    SaveModifiers();

                    UpdateScorerate();

                    UpdateCheckmark();
                }
                else
                    FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    switch (optionShit[curSelected]) 
					{
                        case 'Practice':

                            switch (Practice_Selected)
                            {
                                case 1:
                                    Practice_Selected = 0;
                                    CheckmarkPractice = true;
                                    CheckmarkPerfect = false;
                                    Perfect_Selected = 1;
                                    CheckmarkHPLossM = false;
                                    HPLossM_Selected = 0;
                                    CheckmarkHPLossP = false;
                                    HPLossP_Selected = 0;
                                    HPLoss = 1;
                                    CheckmarkHPGainM = false;
                                    HPGainM_Selected = 0;
                                    CheckmarkHPGainP = false;
                                    HPGainP_Selected = 0;
                                    HPGain = 1;
                                    PsnFright_Selected = 0;
                                    CheckmarkPsnFright = false;
                                    SupLove_Selected = 0;
                                    CheckmarkSupLove = false;
                                    Regen = 0;
                                    ThreeLives_Selected = 1;
                                    CheckmarkThreeLives = false;
                                    LowHP_Selected = 0;
                                    CheckmarkLowHP = false;
                                    HighHP_Selected = 0;
                                    CheckmarkHighHP = false;
                                    HPChange = 0;
                                    NoHPGain_Selected = 0;
                                    CheckmarkNoHPGain = false;
                                    Enigma_Selected = 0;
                                    CheckmarkEnigma = false;
                                case 0:
                                    Practice_Selected = 1;
                                    CheckmarkPractice = false;
                            }
                        case 'Fast Notes':

                            switch (FastNotes_Selected)
                            {
                                case 0:
                                    FastNotes_Selected = 0.9;
                                    NoteSpeed = 1.7;
                                    CheckmarkFastNotes = true;
                                    CheckmarkSlowNotes = false;
                                    SlowNotes_Selected = 0;
                                case 0.9:
                                    FastNotes_Selected = 0;
                                    NoteSpeed = 1;
                                    CheckmarkFastNotes = false;
                            }
                        case 'Slow Notes':

                            switch (SlowNotes_Selected)
                            {
                                case 0:
                                    SlowNotes_Selected = 0.4;
                                    NoteSpeed = 0.5;
                                    CheckmarkSlowNotes = true;
                                    CheckmarkFastNotes = false;
                                    FastNotes_Selected = 0;
                                case 0.4:
                                    SlowNotes_Selected = 0;
                                    NoteSpeed = 1;
                                    CheckmarkSlowNotes = false;
                            }
                        case 'Perfect':

                            switch (Perfect_Selected)
                            {
                                case 1:
                                    Perfect_Selected = 4;
                                    CheckmarkPerfect = true;
                                    CheckmarkPractice = false;
                                    Practice_Selected = 1;
                                    CheckmarkHPLossM = false;
                                    HPLossM_Selected = 0;
                                    CheckmarkHPLossP = false;
                                    HPLossP_Selected = 0;
                                    HPLoss = 1;
                                    CheckmarkHPGainM = false;
                                    HPGainM_Selected = 0;
                                    CheckmarkHPGainP = false;
                                    HPGainP_Selected = 0;
                                    HPGain = 1;
                                    PsnFright_Selected = 0;
                                    CheckmarkPsnFright = false;
                                    SupLove_Selected = 0;
                                    CheckmarkSupLove = false;
                                    Regen = 0;
                                    LowHP_Selected = 0;
                                    CheckmarkLowHP = false;
                                    HighHP_Selected = 0;
                                    CheckmarkHighHP = false;
                                    Stagefright_Selected = 0;
                                    CheckmarkStagefright = false;
                                case 4:
                                    Perfect_Selected = 1;
                                    CheckmarkPerfect = false;
                            }
                        case 'Inv Notes':

                        switch (InvNotes_Selected)
                        {
                            case 0:
                                InvNotes_Selected = 1.5;
                                CheckmarkInvNotes = true;
                                SnakeNotes_Selected = 0;
                                CheckmarkSnakeNotes = false;
                                VnshNotes_Selected = 0;
                                CheckmarkVnshNotes = false;
                                StretchUp_Selected = 0;
                                CheckmarkStretchUp = false;
                                WidenUp_Selected = 0;
                                CheckmarkWidenUp = false;
                                HyperNotes_Selected = 0;
                                CheckmarkHyperNotes = false;
                            case 1.5:
                                InvNotes_Selected = 0;
                                CheckmarkInvNotes = false;
                        }
                        case 'HP Loss M':

                            switch (HPLossM_Selected)
                            {
                                case 0:
                                    HPLossM_Selected = 0.5;
                                    HPLoss = 0.5;
                                    CheckmarkHPLossM = true;
                                    CheckmarkHPLossP = false;
                                    HPLossP_Selected = 0;
                                    CheckmarkPerfect = false;
                                    Perfect_Selected = 1;
                                    CheckmarkPractice = false;
                                    Practice_Selected = 1;
                                case 0.5:
                                    HPLossM_Selected = 0;
                                    HPLoss = 1;
                                    CheckmarkHPLossM = false;
                            }
                        case 'HP Loss P':

                            switch (HPLossP_Selected)
                            {
                                case 0:
                                    HPLossP_Selected = 0.5;
                                    HPLoss = 2;
                                    CheckmarkHPLossP = true;
                                    CheckmarkHPLossM = false;
                                    HPLossM_Selected = 0;
                                    CheckmarkPerfect = false;
                                    Perfect_Selected = 1;
                                    CheckmarkPractice = false;
                                    Practice_Selected = 1;
                                case 0.5:
                                    HPLossP_Selected = 0;
                                    HPLoss = 1;
                                    CheckmarkHPLossP = false;
                            }
                        case 'HP Gain M':

                            switch (HPGainM_Selected)
                            {
                                case 0:
                                    HPGainM_Selected = 0.5;
                                    HPGain = 0.5;
                                    CheckmarkHPGainM = true;
                                    CheckmarkHPGainP = false;
                                    HPGainP_Selected = 0;
                                    CheckmarkPerfect = false;
                                    Perfect_Selected = 1;
                                    CheckmarkPractice = false;
                                    Practice_Selected = 1;
                                    NoHPGain_Selected = 0;
                                    CheckmarkNoHPGain = false;
                                case 0.5:
                                    HPGainM_Selected = 0;
                                    HPGain = 1;
                                    CheckmarkHPGainM = false;
                            }
                        case 'HP Gain P':

                            switch (HPGainP_Selected)
                            {
                                case 0:
                                    HPGainP_Selected = 0.5;
                                    HPGain = 2;
                                    CheckmarkHPGainP = true;
                                    CheckmarkHPGainM = false;
                                    HPGainM_Selected = 0;
                                    CheckmarkPerfect = false;
                                    Perfect_Selected = 1;
                                    CheckmarkPractice = false;
                                    Practice_Selected = 1;
                                    NoHPGain_Selected = 0;
                                    CheckmarkNoHPGain = false;
                                case 0.5:
                                    HPGainP_Selected = 0;
                                    HPGain = 1;
                                    CheckmarkHPGainP = false;
                                }
                        case 'No HP Gain':

                            switch (NoHPGain_Selected)
                            {
                                case 0:
                                    NoHPGain_Selected = 1.3;
                                    HPGain = 0;
                                    CheckmarkNoHPGain = true;
                                    CheckmarkHPGainM = false;
                                    HPGainM_Selected = 0;
                                    CheckmarkPerfect = false;
                                    HPGainP_Selected = 0;
                                    CheckmarkHPGainP = false;
                                    Perfect_Selected = 1;
                                    CheckmarkPractice = false;
                                    Practice_Selected = 1;
                                case 1.3:
                                    NoHPGain_Selected = 0;
                                    HPGain = 1;
                                    CheckmarkNoHPGain = false;
                                }
                        case 'Snake Notes':

                            switch (SnakeNotes_Selected)
                            {
                                case 0:
                                    SnakeNotes_Selected = 0.7;
                                    CheckmarkSnakeNotes = true;
                                    CheckmarkInvNotes = false;
                                    InvNotes_Selected = 0;
                                case 0.7:
                                    SnakeNotes_Selected = 0;
                                    CheckmarkSnakeNotes = false;
                            }
                        case 'Drunk Notes':

                            switch (DrunkNotes_Selected)
                            {
                                case 0:
                                    DrunkNotes_Selected = 0.7;
                                    CheckmarkDrunkNotes = true;
                                case 0.7:
                                    DrunkNotes_Selected = 0;
                                    CheckmarkDrunkNotes = false;
                            }
                        case 'Sup Love':

                            switch (SupLove_Selected)
                            {
                                case 0:
                                    SupLove_Selected = 0.4;
                                    Regen = 1;
                                    CheckmarkSupLove = true;
                                    PsnFright_Selected = 0;
                                    CheckmarkPsnFright = false;
                                    Perfect_Selected = 1;
                                    CheckmarkPerfect = false;
                                    Practice_Selected = 1;
                                    CheckmarkPractice = false;
                                case 0.4:
                                    SupLove_Selected = 0;
                                    Regen = 0;
                                    CheckmarkSupLove = false;
                            }
                        case 'Psn Fright':
    
                            switch (PsnFright_Selected)
                            {
                                case 0:
                                    PsnFright_Selected = 0.4;
                                    Regen = -1;
                                    CheckmarkPsnFright = true;
                                    SupLove_Selected = 0;
                                    CheckmarkSupLove = false;
                                    Perfect_Selected = 1;
                                    CheckmarkPerfect = false;
                                    Practice_Selected = 1;
                                    CheckmarkPractice = false;
                                case 0.4:
                                    PsnFright_Selected = 0;
                                    Regen = 0;
                                    CheckmarkPsnFright = false;
                            }
                        case 'Accel Notes':
    
                            switch (AccelNotes_Selected)
                            {
                                case 0:
                                    AccelNotes_Selected = 0.6;
                                    CheckmarkAccelNotes = true;
                                case 0.6:
                                    AccelNotes_Selected = 0;
                                    CheckmarkAccelNotes = false;
                            }
                        case 'Three Lives':

                            switch (ThreeLives_Selected)
                            {
                                case 1:
                                    ThreeLives_Selected = 0.5;
                                    CheckmarkThreeLives = true;
                                    Practice_Selected = 1;
                                    CheckmarkPractice = false;
                                case 0.5:
                                    ThreeLives_Selected = 1;
                                    CheckmarkThreeLives = false;
                            }
                        case 'Lights Out':
    
                            switch (LightsOut_Selected)
                            {
                                case 0:
                                    LightsOut_Selected = 0.5;
                                    CheckmarkLightsOut = true;
                                    Blinding_Selected = 0;
                                    CheckmarkBlinding = false;
                                case 0.5:
                                    LightsOut_Selected = 0;
                                    CheckmarkLightsOut = false;
                            }
                        case 'Blinding':

                            switch (Blinding_Selected)
                            {
                                case 0:
                                    Blinding_Selected = 0.5;
                                    CheckmarkBlinding = true;
                                    LightsOut_Selected = 0;
                                    CheckmarkLightsOut = false;
                                case 0.5:
                                    Blinding_Selected = 0;
                                    CheckmarkBlinding = false;
                            }
                        case 'Vnsh Notes':
    
                               switch (VnshNotes_Selected)
                            {
                                case 0:
                                    VnshNotes_Selected = 0.6;
                                    CheckmarkVnshNotes = true;
                                    InvNotes_Selected = 0;
                                    CheckmarkInvNotes = false;
                                case 0.6:
                                    VnshNotes_Selected = 0;
                                    CheckmarkVnshNotes = false;
                            }
                        case 'Flip Notes':

                            switch (FlipNotes_Selected)
                            {
                                case 0:
                                    FlipNotes_Selected = 0.5;
                                    CheckmarkFlipNotes = true;
                                case 0.5:
                                    FlipNotes_Selected = 0;
                                    CheckmarkFlipNotes = false;
                            }
                        case 'Hyper Notes':

                            switch (HyperNotes_Selected)
                            {
                                case 0:
                                    HyperNotes_Selected = 0.7;
                                    CheckmarkHyperNotes = true;
                                    InvNotes_Selected = 0;
                                    CheckmarkInvNotes = false;
                                case 0.7:
                                    HyperNotes_Selected = 0;
                                    CheckmarkHyperNotes = false;
                            }
                        case 'Seasick':

                            switch (Seasick_Selected)
                            {
                                case 0:
                                    Seasick_Selected = 0.4;
                                    CheckmarkSeasick = true;
                                case 0.4:
                                    Seasick_Selected = 0;
                                    CheckmarkSeasick = false;
                            }
                        case 'Upside Down':
        
                               switch (UpsideDown_Selected)
                            {
                                case 0:
                                    UpsideDown_Selected = 0.4;
                                    CheckmarkUpsideDown = true;
                                    CameraSpin_Selected = 0;
                                    CheckmarkCameraSpin = false;
                                case 0.4:
                                    UpsideDown_Selected = 0;
                                    CheckmarkUpsideDown = false;
                            }
                        case 'Camera Spin':
    
                            switch (CameraSpin_Selected)
                            {
                                case 0:
                                    CameraSpin_Selected = 0.4;
                                    CheckmarkCameraSpin = true;
                                    UpsideDown_Selected = 0;
                                    CheckmarkUpsideDown = false;
                                case 0.4:
                                    CameraSpin_Selected = 0;
                                    CheckmarkCameraSpin = false;
                            }
                        case 'Earthquake':
    
                            switch (Earthquake_Selected)
                            {
                                case 0:
                                    Earthquake_Selected = 0.5;
                                    CheckmarkEarthquake = true;
                                    UpsideDown_Selected = 0;
                                    CheckmarkUpsideDown = false;
                                case 0.5:
                                    Earthquake_Selected = 0;
                                    CheckmarkEarthquake = false;
                            }
                        case 'Low HP':
    
                            switch (LowHP_Selected)
                            {
                                case 0:
                                    LowHP_Selected = 0.2;
                                    CheckmarkLowHP = true;
                                    HighHP_Selected = 0;
                                    CheckmarkHighHP = false;
                                    Practice_Selected = 1;
                                    CheckmarkPractice = false;
                                    Perfect_Selected = 1;
                                    CheckmarkPerfect = false;
                                    HPChange = -0.5;
                                case 0.2:
                                    LowHP_Selected = 0;
                                    CheckmarkLowHP = false;
                                    HPChange = 0;
                            }
                        case 'High HP':
    
                            switch (HighHP_Selected)
                            {
                                case 0:
                                    HighHP_Selected = 0.2;
                                    CheckmarkHighHP = true;
                                    LowHP_Selected = 0;
                                    CheckmarkLowHP = false;
                                    Practice_Selected = 1;
                                    CheckmarkPractice = false;
                                    Perfect_Selected = 1;
                                    CheckmarkPerfect = false;
                                    HPChange = 0.5;
                                case 0.2:
                                    HighHP_Selected = 0;
                                    CheckmarkHighHP = false;
                                    HPChange = 0;
                            }
                        case 'Enigma':

                            switch (Enigma_Selected)
                            {
                                case 0:
                                    Enigma_Selected = 0.5;
                                    CheckmarkEnigma = true;
                                    Perfect_Selected = 1;
                                    CheckmarkPerfect = false;
                                    Practice_Selected = 1;
                                    CheckmarkPractice = false;
                                case 0.5:
                                    Enigma_Selected = 0;
                                    CheckmarkEnigma = false;
                            }
                        case 'L Zones':

                            switch (LZones_Selected)
                            {
                                case 0:
                                    LZones_Selected = 0.4;
                                    CheckmarkLZones = true;
                                    SZones_Selected = 0;
                                    CheckmarkSZones = false;
                                    PZones_Selected = 0;
                                    CheckmarkPZones = false;
                                    ZoneOffset = 2;
                                case 0.4:
                                    LZones_Selected = 0;
                                    CheckmarkLZones = false;
                                    ZoneOffset = 1;
                            }
                        case 'S Zones':

                            switch (SZones_Selected)
                            {
                                case 0:
                                    SZones_Selected = 0.4;
                                    CheckmarkSZones = true;
                                    LZones_Selected = 0;
                                    CheckmarkLZones = false;
                                    PZones_Selected = 0;
                                    CheckmarkPZones = false;
                                    ZoneOffset = 0.5;
                                case 0.4:
                                    SZones_Selected = 0;
                                    CheckmarkSZones = false;
                                    ZoneOffset = 1;
                            }
                        case 'P Zones':

                            switch (PZones_Selected)
                            {
                                case 0:
                                    PZones_Selected = 1;
                                    CheckmarkPZones = true;
                                    LZones_Selected = 0;
                                    CheckmarkLZones = false;
                                    SZones_Selected = 0;
                                    CheckmarkSZones = false;
                                    ZoneOffset = 0.1;
                                case 1:
                                    PZones_Selected = 0;
                                    CheckmarkPZones = false;
                                    ZoneOffset = 1;
                            }
                        case 'Stagefright':

                            switch (Stagefright_Selected)
                            {
                                case 0:
                                    Stagefright_Selected = 0.6;
                                    CheckmarkStagefright = true;
                                    Perfect_Selected = 1;
                                    CheckmarkPerfect = false;
                                case 0.6:
                                    Stagefright_Selected = 0;
                                    CheckmarkStagefright = false;
                            }
                        case 'Paparazzi':

                            switch (Paparazzi_Selected)
                            {
                                case 0:
                                    Paparazzi_Selected = 0.2;
                                    CheckmarkPaparazzi = true;
                                case 0.2:
                                    Paparazzi_Selected = 0;
                                    CheckmarkPaparazzi = false;
                            }
                        case 'Lofi':

                            switch (Lofi_Selected)
                            {
                                case 0:
                                    Lofi_Selected = 0.6;
                                    FiChange = 0.8;
                                    CheckmarkLofi = true;
                                    CheckmarkHifi = false;
                                    Hifi_Selected = 0;
                                case 0.6:
                                    Lofi_Selected = 0;
                                    FiChange = 1;
                                    CheckmarkLofi = false;
                            }
                        case 'Hifi':
    
                            switch (Hifi_Selected)
                            {
                                case 0:
                                    Hifi_Selected = 0.6;
                                    FiChange = 1.2;
                                    CheckmarkHifi = true;
                                    CheckmarkLofi = false;
                                    Lofi_Selected = 0;
                                case 0.6:
                                    Hifi_Selected = 0;
                                    FiChange = 1;
                                    CheckmarkHifi = false;
                            }
                        case 'Eel Notes':

                            switch (EelNotes_Selected)
                            {
                                case 1:
                                    EelNotes_Selected = 0;
                                    CheckmarkEelNotes = true;
                                case 0:
                                    EelNotes_Selected = 1;
                                    CheckmarkEelNotes = false;
                            }
                        case 'Offbeat':

                            switch (Offbeat_Selected)
                            {
                                case 0:
                                    Offbeat_Selected = 0.3;
                                    CheckmarkOffbeat = true;
                                case 0.3:
                                    Offbeat_Selected = 0;
                                    CheckmarkOffbeat = false;
                            }
                        case 'Stretch Up':

                            switch (StretchUp_Selected)
                            {
                                case 0:
                                    StretchUp_Selected = 0.1;
                                    CheckmarkStretchUp = true;
                                    InvNotes_Selected = 0;
                                    CheckmarkInvNotes = false;
                                case 0.1:
                                    StretchUp_Selected = 0;
                                    CheckmarkStretchUp = false;
                            }
                        case 'Widen Up':

                            switch (WidenUp_Selected)
                            {
                                case 0:
                                    WidenUp_Selected = 0.1;
                                    CheckmarkWidenUp = true;
                                    InvNotes_Selected = 0;
                                    CheckmarkInvNotes = false;
                                case 0.1:
                                    WidenUp_Selected = 0;
                                    CheckmarkWidenUp = false;
                            }
                    }
                SaveModifiers();

                UpdateScorerate();

                UpdateCheckmark();
            }			
        }

        public static function SaveModifiers():Void
        {
            FlxG.save.data.Practice_Selected = Practice_Selected;
            FlxG.save.data.FastNotes_Selected = FastNotes_Selected;
            FlxG.save.data.SlowNotes_Selected = SlowNotes_Selected;
            FlxG.save.data.Perfect_Selected = Perfect_Selected;
            FlxG.save.data.InvNotes_Selected = InvNotes_Selected;
            FlxG.save.data.HPLossM_Selected = HPLossM_Selected;
            FlxG.save.data.HPLossP_Selected = HPLossP_Selected;
            FlxG.save.data.HPGainM_Selected = HPGainM_Selected;
            FlxG.save.data.HPGainP_Selected = HPGainP_Selected;
            FlxG.save.data.SnakeNotes_Selected = SnakeNotes_Selected;
            FlxG.save.data.DrunkNotes_Selected = DrunkNotes_Selected;
            FlxG.save.data.SupLove_Selected = SupLove_Selected;
            FlxG.save.data.PsnFright_Selected = PsnFright_Selected;
            FlxG.save.data.AccelNotes_Selected = AccelNotes_Selected;
            FlxG.save.data.ThreeLives_Selected = ThreeLives_Selected;
            FlxG.save.data.LightsOut_Selected = LightsOut_Selected;
            FlxG.save.data.Blinding_Selected = Blinding_Selected;
            FlxG.save.data.VnshNotes_Selected = VnshNotes_Selected;
            FlxG.save.data.FlipNotes_Selected = FlipNotes_Selected;
            FlxG.save.data.Seasick_Selected = Seasick_Selected;
            FlxG.save.data.UpsideDown_Selected = UpsideDown_Selected;
            FlxG.save.data.CameraSpin_Selected = CameraSpin_Selected;
            FlxG.save.data.Earthquake_Selected = Earthquake_Selected;
            FlxG.save.data.LowHP_Selected = LowHP_Selected;
            FlxG.save.data.HighHP_Selected = HighHP_Selected;
            FlxG.save.data.HyperNotes_Selected = HyperNotes_Selected;
            FlxG.save.data.Enigma_Selected = Enigma_Selected;
            FlxG.save.data.NoHPGain_Selected = NoHPGain_Selected;
            FlxG.save.data.LZones_Selected = LZones_Selected;
            FlxG.save.data.SZones_Selected = SZones_Selected;
            FlxG.save.data.PZones_Selected = PZones_Selected;
            FlxG.save.data.Stagefright_Selected = Stagefright_Selected;
            FlxG.save.data.Paparazzi_Selected = Paparazzi_Selected;
            FlxG.save.data.Lofi_Selected = Lofi_Selected;
            FlxG.save.data.Hifi_Selected = Hifi_Selected;
            FlxG.save.data.EelNotes_Selected = EelNotes_Selected;
            FlxG.save.data.Offbeat_Selected = Offbeat_Selected;
            FlxG.save.data.StretchUp_Selected = StretchUp_Selected;
            FlxG.save.data.WidenUp_Selected = WidenUp_Selected;

            FlxG.save.flush();
        }

        function LoadModifiers():Void
            {
                if (FlxG.save.data.Practice_Selected != null)
                    Practice_Selected = FlxG.save.data.Practice_Selected;
                if (FlxG.save.data.FastNotes_Selected != null)
                    FastNotes_Selected = FlxG.save.data.FastNotes_Selected;
                if (FlxG.save.data.SlowNotes_Selected != null)
                    SlowNotes_Selected = FlxG.save.data.SlowNotes_Selected;
                if (FlxG.save.data.Perfect_Selected != null)
                    Perfect_Selected = FlxG.save.data.Perfect_Selected;
                if (FlxG.save.data.InvNotes_Selected != null)
                    InvNotes_Selected = FlxG.save.data.InvNotes_Selected;
                if (FlxG.save.data.HPLossM_Selected != null)
                    HPLossM_Selected = FlxG.save.data.HPLossM_Selected;
                if (FlxG.save.data.HPLossP_Selected != null)
                    HPLossP_Selected = FlxG.save.data.HPLossP_Selected;
                if (FlxG.save.data.HPGainM_Selected != null)
                    HPGainM_Selected = FlxG.save.data.HPGainM_Selected;
                if (FlxG.save.data.HPGainP_Selected != null)
                    HPGainP_Selected = FlxG.save.data.HPGainP_Selected;
                if (FlxG.save.data.SnakeNotes_Selected != null)
                    SnakeNotes_Selected = FlxG.save.data.SnakeNotes_Selected;
                if (FlxG.save.data.DrunkNotes_Selected != null)
                    DrunkNotes_Selected = FlxG.save.data.DrunkNotes_Selected;
                if (FlxG.save.data.SupLove_Selected != null)
                    SupLove_Selected = FlxG.save.data.SupLove_Selected;
                if (FlxG.save.data.PsnFright_Selected != null)
                    PsnFright_Selected = FlxG.save.data.PsnFright_Selected;
                if (FlxG.save.data.AccelNotes_Selected != null)
                    AccelNotes_Selected = FlxG.save.data.AccelNotes_Selected;
                if (FlxG.save.data.ThreeLives_Selected != null)
                    ThreeLives_Selected = FlxG.save.data.ThreeLives_Selected;
                if (FlxG.save.data.LightsOut_Selected != null)
                    LightsOut_Selected = FlxG.save.data.LightsOut_Selected;
                if (FlxG.save.data.Blinding_Selected != null)
                    Blinding_Selected = FlxG.save.data.Blinding_Selected;
                if (FlxG.save.data.VnshNotes_Selected != null)
                    VnshNotes_Selected = FlxG.save.data.VnshNotes_Selected;
                if (FlxG.save.data.FlipNotes_Selected != null)
                    FlipNotes_Selected = FlxG.save.data.FlipNotes_Selected;
                if (FlxG.save.data.Seasick_Selected != null)
                    Seasick_Selected = FlxG.save.data.Seasick_Selected;
                if (FlxG.save.data.UpsideDown_Selected != null)
                    UpsideDown_Selected = FlxG.save.data.UpsideDown_Selected;
                if (FlxG.save.data.CameraSpin_Selected != null)
                    CameraSpin_Selected = FlxG.save.data.CameraSpin_Selected;
                if (FlxG.save.data.Earthquake_Selected != null)
                    Earthquake_Selected = FlxG.save.data.Earthquake_Selected;
                if (FlxG.save.data.HighHP_Selected != null)
                    HighHP_Selected = FlxG.save.data.HighHP_Selected;
                if (FlxG.save.data.LowHP_Selected != null)
                    LowHP_Selected = FlxG.save.data.LowHP_Selected;
                if (FlxG.save.data.NoHPGain_Selected != null)
                    NoHPGain_Selected = FlxG.save.data.NoHPGain_Selected;
                if (FlxG.save.data.Enigma_Selected != null)
                    Enigma_Selected = FlxG.save.data.Enigma_Selected;
                if (FlxG.save.data.HyperNotes_Selected != null)
                    HyperNotes_Selected = FlxG.save.data.HyperNotes_Selected;
                if (FlxG.save.data.LZones_Selected != null)
                    LZones_Selected = FlxG.save.data.LZones_Selected;
                if (FlxG.save.data.SZones_Selected != null)
                    SZones_Selected = FlxG.save.data.SZones_Selected;
                if (FlxG.save.data.PZones_Selected != null)
                    PZones_Selected = FlxG.save.data.PZones_Selected;
                if (FlxG.save.data.Stagefright_Selected != null)
                    Stagefright_Selected = FlxG.save.data.Stagefright_Selected;
                if (FlxG.save.data.Paparazzi_Selected != null)
                    Paparazzi_Selected = FlxG.save.data.Paparazzi_Selected;
                if (FlxG.save.data.Hifi_Selected != null)
                    Hifi_Selected = FlxG.save.data.Hifi_Selected;
                if (FlxG.save.data.Lofi_Selected != null)
                    Lofi_Selected = FlxG.save.data.Lofi_Selected;
                if (FlxG.save.data.EelNotes_Selected != null)
                    EelNotes_Selected = FlxG.save.data.EelNotes_Selected;
                if (FlxG.save.data.Offbeat_Selected != null)
                    Offbeat_Selected = FlxG.save.data.Offbeat_Selected;
                if (FlxG.save.data.StretchUp_Selected != null)
                    StretchUp_Selected = FlxG.save.data.StretchUp_Selected;
                if (FlxG.save.data.WidenUp_Selected != null)
                    WidenUp_Selected = FlxG.save.data.WidenUp_Selected;

                switch (Practice_Selected)
                {
                    case 0:
                        CheckmarkPractice = true;
                    case 1:
                        CheckmarkPractice = false;
                }

                switch (FastNotes_Selected)
                {
                    case 0.9:
                        CheckmarkFastNotes = true;
                        NoteSpeed = 1.7;
                    case 0:
                        CheckmarkFastNotes = false;
                }

                switch (SlowNotes_Selected)
                {
                    case 0.4:
                        CheckmarkSlowNotes = true;
                        NoteSpeed = 0.5;
                    case 0:
                        CheckmarkSlowNotes = false;
                }

                switch (Perfect_Selected)
                {
                    case 4:
                        CheckmarkPerfect = true;
                    case 1:
                        CheckmarkPerfect = false;
                }

                switch (InvNotes_Selected)
                {
                    case 1.5:
                        CheckmarkInvNotes = true;
                    case 0:
                        CheckmarkInvNotes = false;
                }

                switch (HPLossM_Selected)
                {
                    case 0.5:
                        CheckmarkHPLossM = true;
                        HPLoss = 0.5;
                    case 0:
                        CheckmarkHPLossM = false;
                }
                                    
                switch (HPLossP_Selected)
                {
                    case 0.5:
                        CheckmarkHPLossP = true;
                        HPLoss = 2;
                    case 0:
                        CheckmarkHPLossP = false;
                }

                switch (HPGainM_Selected)
                {
                    case 0.5:
                        CheckmarkHPGainM = true;
                        HPGain = 0.5;
                    case 0:
                        CheckmarkHPGainM = false;
                }
                                    
                switch (HPGainP_Selected)
                {
                    case 0.5:
                        CheckmarkHPGainP = true;
                        HPGain = 2;
                    case 0:
                        CheckmarkHPGainP = false;
                }

                switch (NoHPGain_Selected)
                {
                    case 1.3:
                        CheckmarkNoHPGain = true;
                        HPGain = 0;
                    case 0:
                        CheckmarkNoHPGain = false;
                }

                switch (DrunkNotes_Selected)
                {
                    case 0.7:
                        CheckmarkDrunkNotes = true;
                    case 0:
                        CheckmarkDrunkNotes = false;
                }
                switch (SnakeNotes_Selected)
                {
                    case 0.7:
                        CheckmarkSnakeNotes = true;
                    case 0:
                        CheckmarkSnakeNotes = false;
                }
                switch (SupLove_Selected)
                {
                    case 0.4:
                        CheckmarkSupLove = true;
                        Regen = 1;
                    case 0:
                        CheckmarkSupLove = false;
                }   
                switch (PsnFright_Selected)
                {
                    case 0.4:
                        CheckmarkPsnFright = true;
                        Regen = -1;
                    case 0:
                        CheckmarkPsnFright = false;
                }
                switch (AccelNotes_Selected)
                {
                    case 0.6:
                        CheckmarkAccelNotes = true;
                    case 0:
                        CheckmarkAccelNotes = false;
                }
                switch (ThreeLives_Selected)
                {
                    case 0.5:
                        CheckmarkThreeLives = true;
                    case 1:
                        CheckmarkThreeLives = false;
                }

                switch (LightsOut_Selected)
                {
                    case 0.5:
                        CheckmarkLightsOut = true;
                    case 0:
                        CheckmarkLightsOut = false;
                }
            
                switch (Blinding_Selected)
                {
                    case 0.5:
                        CheckmarkBlinding = true;
                    case 0:
                        CheckmarkBlinding = false;
                }

                switch (VnshNotes_Selected)
                {
                    case 0.6:
                        CheckmarkVnshNotes = true;
                    case 0:
                        CheckmarkVnshNotes = false;
                }
                                         
                switch (Seasick_Selected)
                {
                    case 0.4:
                        CheckmarkSeasick = true;
                    case 0:
                        CheckmarkSeasick = false;
                }
                switch (UpsideDown_Selected)
                {
                    case 0.4:
                        CheckmarkUpsideDown = true;
                    case 0:
                        CheckmarkUpsideDown = false;
                }
                                         
                switch (CameraSpin_Selected)
                {
                    case 0.4:
                        CheckmarkCameraSpin = true;
                    case 0:
                        CheckmarkCameraSpin = false;
                }
                switch (FlipNotes_Selected)
                {
                    case 0.5:
                        CheckmarkFlipNotes = true;
                    case 0:
                        CheckmarkFlipNotes = false;
                }
                switch (Earthquake_Selected)
                {
                    case 0.5:
                        CheckmarkEarthquake = true;
                    case 0:
                        CheckmarkEarthquake = false;
                }
                switch (LowHP_Selected)
                {
                    case 0.2:
                        CheckmarkLowHP = true;
                        HPChange = -0.5;
                    case 0:
                        CheckmarkLowHP = false;
                }
                switch (HighHP_Selected)
                {
                    case 0.2:
                        CheckmarkHighHP = true;
                        HPChange = 0.5;
                    case 0:
                        CheckmarkHighHP = false;
                }
                switch (Enigma_Selected)
                {
                    case 0.5:
                        CheckmarkEnigma = true;
                    case 0:
                        CheckmarkEnigma = false;
                }
                switch (HyperNotes_Selected)
                {
                    case 0.7:
                        CheckmarkHyperNotes = true;
                    case 0:
                        CheckmarkHyperNotes = false;
                }
                switch (LZones_Selected)
                {
                    case 0.4:
                        CheckmarkLZones = true;
                        ZoneOffset = 2;
                    case 0:
                        CheckmarkLZones = false;
                }
                switch (SZones_Selected)
                {
                    case 0.4:
                        CheckmarkSZones = true;
                        ZoneOffset = 0.5;
                    case 0:
                        CheckmarkSZones = false;
                }
                switch (PZones_Selected)
                {
                    case 1:
                        CheckmarkPZones = true;
                        ZoneOffset = 0.1;
                    case 0:
                        CheckmarkPZones = false;
                }
                switch (Stagefright_Selected)
                {
                    case 0.6:
                        CheckmarkStagefright = true;
                    case 0:
                        CheckmarkStagefright = false;
                }
                switch (Paparazzi_Selected)
                {
                    case 0.2:
                        CheckmarkPaparazzi = true;
                    case 0:
                        CheckmarkPaparazzi = false;
                }
                switch (Lofi_Selected)
                {
                    case 0.6:
                        CheckmarkLofi = true;
                        FiChange = 0.8;
                    case 0:
                        CheckmarkLofi = false;
                }

                switch (Hifi_Selected)
                {
                    case 0.6:
                        CheckmarkHifi = true;
                        FiChange = 1.2;
                    case 0:
                        CheckmarkHifi = false;
                }
                switch (EelNotes_Selected)
                {
                    case 0:
                        CheckmarkEelNotes = true;
                    case 1:
                        CheckmarkEelNotes = false;
                }
                switch (Offbeat_Selected)
                {
                    case 0.3:
                        CheckmarkOffbeat = true;
                    case 0:
                        CheckmarkOffbeat = false;
                }
                switch (StretchUp_Selected)
                {
                    case 0.1:
                        CheckmarkStretchUp = true;
                    case 0:
                        CheckmarkStretchUp = false;
                }
                switch (WidenUp_Selected)
                {
                    case 0.1:
                        CheckmarkWidenUp = true;
                    case 0:
                        CheckmarkWidenUp = false;
                }
            }

        public static function ClearModifiers():Void
        {
            Practice_Selected = 1;
            CheckmarkPractice = false;
            FastNotes_Selected = 0;
            NoteSpeed = 1;
            CheckmarkFastNotes = false;
            SlowNotes_Selected = 0;
            CheckmarkSlowNotes = false;
            Perfect_Selected = 1;
            CheckmarkPerfect = false;
            InvNotes_Selected = 0;
            CheckmarkInvNotes = false;
            HPLossP_Selected = 0;
            HPLoss = 1;
            CheckmarkHPLossP = false;
            HPLossM_Selected = 0;
            CheckmarkHPLossM = false;
            NoHPGain_Selected = 0;
            HPGain = 1;
            CheckmarkNoHPGain = false;
            HPGainP_Selected = 0;
            CheckmarkHPGainP = false;
            HPGainM_Selected = 0;
            CheckmarkHPGainM = false;
            SnakeNotes_Selected = 0;
            CheckmarkSnakeNotes = false;
            DrunkNotes_Selected = 0;
            CheckmarkDrunkNotes = false;
            SupLove_Selected = 0;
            Regen = 0;
            CheckmarkSupLove = false;
            PsnFright_Selected = 0;
            CheckmarkPsnFright = false;
            AccelNotes_Selected = 0;
            CheckmarkAccelNotes = false;
            ThreeLives_Selected = 1;
            CheckmarkThreeLives = false;
            LightsOut_Selected = 0;
            CheckmarkLightsOut = false;
            Blinding_Selected = 0;
            CheckmarkBlinding = false;
            VnshNotes_Selected = 0;
            CheckmarkVnshNotes = false;
            FlipNotes_Selected = 0;
            CheckmarkFlipNotes = false;
            HyperNotes_Selected = 0;
            CheckmarkHyperNotes = false;
            Seasick_Selected = 0;
            CheckmarkSeasick = false;
            UpsideDown_Selected = 0;
            CheckmarkUpsideDown = false;
            CameraSpin_Selected = 0;
            CheckmarkCameraSpin = false;
            Earthquake_Selected = 0;
            CheckmarkEarthquake = false;
            LowHP_Selected = 0;
            CheckmarkLowHP = false;
            HPChange = 0;
            HighHP_Selected = 0;
            CheckmarkHighHP = false;
            Enigma_Selected = 0;
            CheckmarkEnigma = false;
            LZones_Selected = 0;
            CheckmarkLZones = false;
            ZoneOffset = 1;
            SZones_Selected = 0;
            CheckmarkSZones = false;
            PZones_Selected = 0;
            CheckmarkPZones = false;
            Stagefright_Selected = 0;
            CheckmarkStagefright = false;
            Paparazzi_Selected = 0;
            CheckmarkPaparazzi = false;
            Hifi_Selected = 0;
            FiChange = 1;
            CheckmarkHifi = false;
            Lofi_Selected = 0;
            CheckmarkLofi = false;
            EelNotes_Selected = 1;
            CheckmarkEelNotes = false;
            Offbeat_Selected = 0;
            CheckmarkOffbeat = false;
            StretchUp_Selected = 0;
            CheckmarkStretchUp = false;
            WidenUp_Selected = 0;
            CheckmarkWidenUp = false;
        }

        function changeItem(huh:Int = 0)
            {
                curSelected += huh;
        
                if (curSelected >= menuItems.length)
                    curSelected = 0;
                if (curSelected < 0)
                    curSelected = menuItems.length - 1;

                switch (optionShit[curSelected]) 
                {
                    case 'Practice':
                        ExplainText.text = "PRACTICE MODE\n\n\n"
                        +"PRACTICE YOUR SONGS\n"
                        +"IN ANY DIFFICULTY\n"
                        +"AND ANY MODIFIER.\n"
                        +"YOUR HEALTH WON'T\n"
                        +"DECREASE IN THE\n"
                        +"PROCESS.\n\n"
                        +"SCORE RATE DROPS TO\n"
                        +"0x!";
                    case 'Fast Notes':
                        ExplainText.text = "FAST NOTES\n\n\n"
                        +"NOTES WILL GO\n"
                        +"FASTER THAN THEY\n"
                        +"USUALLY DO.\n"
                        +"WATCH OUT FOR THEM.\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.9x!";
                    case 'Slow Notes':
                        ExplainText.text = "SLOW NOTES\n\n\n"
                        +"NOTES WILL GO\n"
                        +"SLOWER THAN THEY\n"
                        +"USUALLY DO.\n"
                        +"YOUR REACTION TIME\n"
                        +"SHOULD BE BETTER.\n"
                        +"\n\n"
                        +"SCORE RATE LOWERS BY\n"
                        +"0.4x!";
                    case 'Perfect':
                        ExplainText.text = "PERFECT\n\n\n"
                        +"IT SEEMS AS IF\n"
                        +"NOTES BECAME WAY\n"
                        +"MORE DANGEROUS.\n"
                        +"MISS ONLY ONCE AND\n"
                        +"YOU LOSE.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"4x THE CURRENT RATE!";
                    case 'Inv Notes':
                        ExplainText.text = "INVISIBLE NOTES\n\n\n"
                        +"IN THIS ONE THE\n"
                        +"NOTES BECOME FULL ON\n"
                        +"INVISIBLE.\n"
                        +"MEMORY IS REQUIRED\n"
                        +"FOR THIS.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"1.5x!";
                    case 'HP Loss M':
                        ExplainText.text = "HP LOSS MINUS\n\n\n"
                        +"WHEN YOU MISS A NOTE,\n"
                        +"YOUR HP WILL\n"
                        +"DECREASE SLOWER.\n"
                        +"YOU'LL BE ABLE\n"
                        +"TO SPAM MORE.\n"
                        +"\n\n"
                        +"SCORE RATE LOWERS BY\n"
                        +"0.5x!";
                    case 'HP Loss P':
                        ExplainText.text = "HP LOSS PLUS\n\n\n"
                        +"WHEN YOU MISS A NOTE,\n"
                        +"YOUR HP WILL\n"
                        +"DECREASE FASTER.\n"
                        +"BE WARY OF THIS.\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.5x!";
                    case 'HP Gain M':
                        ExplainText.text = "HP GAIN MINUS\n\n\n"
                        +"WHEN YOU PRESS A NOTE,\n"
                        +"YOUR HP WILL\n"
                        +"INCREASE SLOWER.\n"
                        +"YOU'LL HAVE TO\n"
                        +"BE MORE\n"
                        +"ACCURATE.\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.5x!";
                    case 'HP Gain P':
                        ExplainText.text = "HP GAIN PLUS\n\n\n"
                        +"WHEN YOU PRESS A NOTE,\n"
                        +"YOUR HP WILL\n"
                        +"INCREASE FASTER.\n"
                        +"THIS WON'T WORRY\n"
                        +"YOU MUCH.\n"
                        +"\n\n"
                        +"SCORE RATE LOWERS BY\n"
                        +"0.5x!";
                    case 'Snake Notes':
                        ExplainText.text = "SNAKE NOTES\n\n\n"
                        +"NOTES WILL GO LIKE\n"
                        +"SNAKES, GOING\n"
                        +"SIDEWAYS AT ALL\n"
                        +"TIMES. DON'T LET\n"
                        +"THAT WORRY YOU.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.7x!";
                    case 'Drunk Notes':
                        ExplainText.text = "DRUNK NOTES\n\n\n"
                        +"NOTES DON'T SEEM,\n"
                        +"TO BE ABLE TO THINK\n"
                        +"STRAIGHT AND GO\n"
                        +"FASTER AND SLOWER.\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.7x!";
                    case 'ZZZZZZZ':
                        ExplainText.text = "CONTINUE\n\n\n"
                        +"START YOUR OWN\n"
                        +"BEEP BATTLE\n"
                        +"ADVENTURE.\n"
                        +"\n"
                        +"\n"
                        +"\n\n"
                        +"\n"
                        +"";
                    case 'ZZZ':
                            ExplainText.text = "CLEAR\n\n\n"
                            +"CLEAR ALL YOUR\n"
                            +"MODIFIER COMBOS\n"
                            +"BACK TO NOTHING.\n"
                            +"\n"
                            +"\n"
                            +"\n\n"
                            +"\n"
                            +"";
                    case 'Sup Love':
                        ExplainText.text = "SUPPORTIVE LOVE\n\n\n"
                        +"THEIR LOVE FOR EACH\n"
                        +"OTHER IS MOTIVATING\n"
                        +"BOYFRIEND. HE WILL\n"
                        +"REAIN HEALTH\n"
                        +"GRADUALLY.\n"
                        +"\n\n"
                        +"SCORE RATE LOWERS BY\n"
                        +"0.4x!";
                    case 'Psn Fright':
                        ExplainText.text = "POISON FRIGHT\n\n\n"
                        +"BOYFRIEND IS AFRAID\n"
                        +"OF THE ENEMY HE'S\n"
                        +"FACING. HE WILL\n"
                        +"LOSE HEALTH\n"
                        +"GRADUALLY.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.4x!";
                    case 'Accel Notes':
                        ExplainText.text = "ACCELERATING NOTES\n\n\n"
                        +"NOTES START TO\n"
                        +"ACCELERATE AS IF\n"
                        +"THEY WERE RACE\n"
                        +"CARS. WATCH OUT\n"
                        +"FOR THEM.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.6x!";
                    case 'Three Lives':
                        ExplainText.text = "THREE LIVES\n\n\n"
                        +"ENEMIES GIVE\n"
                        +"BOYFRIEND TWO\n"
                        +"EXTRA CHANCES IN\n"
                        +"BATTLE. USE THEM\n"
                        +"WISELY.\n"
                        +"\n\n"
                        +"SCORE RATE HALVES\n"
                        +"WHEN ACTIVE!";
                    case 'Lights Out':
                        ExplainText.text = "LIGHTS OUT\n\n\n"
                        +"IT SEEMS THAT THE\n"
                        +"LIGHTS HAVE\n"
                        +"TURNED OFF. IT'S\n"
                        +"EXTREMELY DARK\n"
                        +"IN THERE.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.5x!";
                    case 'Blinding':
                        ExplainText.text = "BLINDING\n\n\n"
                        +"STROBE LIGHTS\n"
                        +"SEEM TO TAKE AN\n"
                        +"EXTRA KICK TO THEM.\n"
                        +"IT'S EXTREMELY\n"
                        +"BRIGHT IN THERE.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.5x!";
                    case 'Vnsh Notes':
                        ExplainText.text = "VANISHING NOTES\n\n\n"
                        +"THE NOTES WANT TO\n"
                        +"PEACE OUT SO HARD\n"
                        +"THAT THEY START\n"
                        +"DISAPPEARING. PAY\n"
                        +"ATTENTION.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.6x!";
                    case 'Flip Notes':
                        ExplainText.text = "FLIPPED NOTES\n\n\n"
                        +"NOTES SEEM TO\n"
                        +"BE FLIPPED ON\n"
                        +"THEIR OWN HEADS.\n"
                        +"DON'T GET REALLY\n"
                        +"CONFUSED.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.5x!";
                    case 'Seasick':
                        ExplainText.text = "SEASICK\n\n\n"
                        +"EVERYONE IS\n"
                        +"SUDDENLY ON SOME\n"
                        +"KIND OF A SHIP.\n"
                        +"THE CAMERA WILL\n"
                        +"SWING LIKE A SHIP.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.4x!";
                    case 'Upside Down':
                        ExplainText.text = "UPSIDE DOWN\n\n\n"
                        +"EVERYTHING IS\n"
                        +"TURNED ON ITS OWN\n"
                        +"HEAD, LITERALLY.\n"
                        +"\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.4x!";
                    case 'Camera Spin':
                        ExplainText.text = "CAMERA SPIN\n\n\n"
                        +"IT FEELS LIKE A\n"
                        +"WASHING MACHINE IN\n"
                        +"THERE. THE CAMERA\n"
                        +"WILL SPIN\n"
                        +"INFINITELY.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.4x!";
                    case 'Earthquake':
                        ExplainText.text = "EARTHQUAKE\n\n\n"
                        +"ARE YOU IN TOKYO\n"
                        +"OR SOMETHING?\n"
                        +"BECAUSE THERE IS\n"
                        +"AN EARTHQUAKE\n"
                        +"HAPPENING.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.5x!";
                    case 'Low HP':
                        ExplainText.text = "LOW HP\n\n\n"
                        +"THIS WEEK YOU\n"
                        +"DIDN'T PREPARE\n"
                        +"YOURSELF WITH SOME\n"
                        +"FOOD AND THUS YOUR\n"
                        +"HP IS LOW.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.2x!";
                    case 'High HP':
                        ExplainText.text = "HIGH HP\n\n\n"
                        +"TODAY YOU SEEM TO\n"
                        +"BE WELL FED,\n"
                        +"AND THUS YOUR\n"
                        +"HP IS HIGH.\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE LOWERS BY\n"
                        +"0.2x!";
                    case 'Hyper Notes':
                        ExplainText.text = "HYPER NOTES\n\n\n"
                        +"DID THE NOTES\n"
                        +"CONSUME SUGAR OR\n"
                        +"SOMETHING? BECAUSE\n"
                        +"THEY ARE GOING\n"
                        +"CRAZY!\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.7x!";
                    case 'No HP Gain':
                        ExplainText.text = "NO HP GAIN\n\n\n"
                        +"UH OH! YOU\n"
                        +"SEEM TO BE,\n"
                        +"CLOGGED TODAY. YOU\n"
                        +"CAN'T REGAIN HP IF\n"
                        +"YOU MISS.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"1.3x!";
                    case 'Enigma':
                        ExplainText.text = "ENIGMA\n\n\n"
                        +"DO YOU NEED\n"
                        +"GLASSES TODAY? THEN\n"
                        +"TOO BAD. YOU CAN'T\n"
                        +"SEE YOUR HEALTH!\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.5x!";
                    case 'L Zones':
                        ExplainText.text = "LEANER ZONES\n\n\n"
                        +"EVERYONE SEEMS TO BE\n"
                        +"CHILL TODAY, SO\n"
                        +"YOU CAN HIT NOTES\n"
                        +"FROM LONGER\n"
                        +"DISTANCES.\n"
                        +"\n\n"
                        +"SCORE RATE LOWERS BY\n"
                        +"0.4x!";
                    case 'S Zones':
                        ExplainText.text = "STRICTER ZONES\n\n\n"
                        +"EVERYONE EXPECTS\n"
                        +"A LITTLE BUT MORE\n"
                        +"FROM YOU, SO YOU\n"
                        +"GOTTA HIT NOTES FROM\n"
                        +"SHORTER DISTANCES.\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.4x!";
                    case 'P Zones':
                        ExplainText.text = "PERFECT ZONES\n\n\n"
                        +"EVERYONE IS EXPECTING\n"
                        +"PERFECTION FROM YOU.\n"
                        +"HIT NOTES AS\n"
                        +"PERFECTLY AS YOU CAN.\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"1x!";
                    case 'Stagefright':
                        ExplainText.text = "STAGEFRIGHT\n\n\n"
                        +"OH NO! I THINK\n"
                        +"YOU SUFFER FROM\n"
                        +"STAGEFRIGHT! DON'T\n"
                        +"MISS TOO MUCH TO\n"
                        +"NOT BE EMBARRASSED!\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.6x!";
                    case 'Paparazzi':
                        ExplainText.text = "PAPARAZZI\n\n\n"
                        +"OOOOOOH! YOU ARE\n"
                        +"POPULAR AROUND THE\n"
                        +"WORLD! EVERYONE WANTS\n"
                        +"TO TAKE PICTURES!\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.2x!";
                    case 'Lofi':
                        ExplainText.text = "LOFI MUSIC\n\n\n"
                        +"IT'S VIBIN' TIME.\n"
                        +"WITH SLOWER MUSIC,\n"
                        +"YOU CAN ENJOY THE\n"
                        +"FRESH TUNES LIKE\n"
                        +"THEY WERE FROM 80S\n"
                        +"\n\n"
                        +"SCORE RATE LOWERS BY\n"
                        +"0.6x!";
                    case 'Hifi':
                        ExplainText.text = "HIFI MUSIC\n\n\n"
                        +"OH HO. YOU NEED TO\n"
                        +"EXERCISE! THANK GOD\n"
                        +"THIS SPEEDY MUSIC\n"
                        +"WILL HELP YOU!\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.6x!";
                    case 'Eel Notes':
                        ExplainText.text = "EEL NOTES\n\n\n"
                        +"WOAH! THEY ARE\n"
                        +"BARKING EELS.\n"
                        +"NO ELECTRICITY, BUT\n"
                        +"THEY ARE LONG\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE DROPS TO\n"
                        +"0x!";
                    case 'Offbeat':
                        ExplainText.text = "OFFBEAT\n\n\n"
                        +"ARE THE SPEAKERS\n"
                        +"BROKEN OR THE PROPLE\n"
                        +"THEMSELVES? THIS\n"
                        +"IS NOT GOOD!\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.3x!";
                    case 'Stretch Up':
                        ExplainText.text = "STRETCH UP\n\n\n"
                        +"STRETCHED NOTES.\n"
                        +"THAT'S IT.\n"
                        +"WHAT A FUNNY.\n"
                        +"HAHAHA.\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.1x!";
                    case 'Widen Up':
                        ExplainText.text = "WIDEN UP\n\n\n"
                        +"THICC NOTES.\n"
                        +"THAT'S IT.\n"
                        +"WHAT A FUNNY.\n"
                        +"HAHAHA.\n"
                        +"\n"
                        +"\n\n"
                        +"SCORE RATE RISES BY\n"
                        +"0.1x!";
                }
        
                menuItems.forEach(function(spr:FlxSprite)
                {
                    spr.animation.play('Idle');
        
                    if (spr.ID == curSelected)
                    {
                        spr.animation.play('Select');  
                        camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
                    }
        
                    spr.updateHitbox();
                });
            }
}
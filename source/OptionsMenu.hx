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

class OptionsMenu extends MusicBeatState
{

    var menuItems:FlxTypedGroup<FlxSprite>;
    var optionShit:Array<String> = ['Practice', 'Practice', 'Practice', 'Practice', 'Practice'];

    var songs:Array<Dynamic> = [ 
        ['Music Volume'], 
        ['Sound Volume'],
        ['Vocal Volume'],
		['Note Offset'],
        ['Modifiers Menu']
    ];

    private var grpSongs:FlxTypedGroup<Alphabet>;
    var selectedSomethin:Bool = false;
    var curSelected:Int = 0;
    var camFollow:FlxObject;

	public static var NoteOffset:Int = 1;
    public static var ModifierSwitch:Int = 1;

    var MusicVolume_Text:FlxText = new FlxText(20, 69, FlxG.width, TitleState.Music_Volume+"%", 48);
    var SoundVolume_Text:FlxText = new FlxText(20, 229, FlxG.width, TitleState.Sound_Volume+"%", 48);
    var VocalsVolume_Text:FlxText = new FlxText(20, 389, FlxG.width, TitleState.Vocals_Volume+"%", 48);
    var NoteOffset_Text:FlxText = new FlxText(20, 549, FlxG.width, NoteOffset+" ms", 48);
    var ModifierSwitch_Text:FlxText = new FlxText(20, 709, FlxG.width, "ON", 48);

    override function create()
    {
        persistentUpdate = persistentDraw = true;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		menuBG.scrollFactor.x = 0;
		menuBG.scrollFactor.y = 0.1;
		add(menuBG);

        var Arrow:FlxSprite = new FlxSprite(30, 320).loadGraphic('assets/images/OptionsArrow.png');
        Arrow.scrollFactor.x = 0;
		Arrow.scrollFactor.y = 0;
        add(Arrow);

        if (FlxG.sound.music != null)
        {
            if (!FlxG.sound.music.playing)
                FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, TitleState.Music_Volume/100);
        }

        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);
        
		var tex = FlxAtlasFrames.fromSparrow('assets/images/Modifiers.png', 'assets/images/Modifiers.xml');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-800, 30 + (i * 160));
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
            songText.x = 130;
            songText.scrollFactor.x = 0;
            songText.scrollFactor.y = 1;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
        }

        camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

        FlxG.camera.follow(camFollow, null, 0.06);
        
        changeItem();

        createResults();

        switch (ModifierSwitch)
        {
            case 0:
                ModifierSwitch_Text.text = "OFF";
            case 1:
                ModifierSwitch_Text.text = "ON";
        }

		super.create();
        
    }

    function createResults():Void
    {
        add(MusicVolume_Text);
        MusicVolume_Text.scrollFactor.x = 0;
        MusicVolume_Text.scrollFactor.y = 1;
        MusicVolume_Text.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER);
        MusicVolume_Text.x = 320;
        MusicVolume_Text.setBorderStyle(OUTLINE_FAST, 0xFF000000, 5, 0.5);

        add(SoundVolume_Text);
        SoundVolume_Text.scrollFactor.x = 0;
        SoundVolume_Text.scrollFactor.y = 1;
        SoundVolume_Text.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER);
        SoundVolume_Text.x = 320;
        SoundVolume_Text.setBorderStyle(OUTLINE_FAST, 0xFF000000, 5, 0.5);

        add(VocalsVolume_Text);
        VocalsVolume_Text.scrollFactor.x = 0;
        VocalsVolume_Text.scrollFactor.y = 1;
        VocalsVolume_Text.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER);
        VocalsVolume_Text.x = 320;
        VocalsVolume_Text.setBorderStyle(OUTLINE_FAST, 0xFF000000, 5, 0.5);

        add(NoteOffset_Text);
        NoteOffset_Text.scrollFactor.x = 0;
        NoteOffset_Text.scrollFactor.y = 1;
        NoteOffset_Text.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER);
        NoteOffset_Text.x = 320;
        NoteOffset_Text.setBorderStyle(OUTLINE_FAST, 0xFF000000, 5, 0.5);

        add(ModifierSwitch_Text);
        ModifierSwitch_Text.scrollFactor.x = 0;
        ModifierSwitch_Text.scrollFactor.y = 1;
        ModifierSwitch_Text.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER);
        ModifierSwitch_Text.x = 320;
        ModifierSwitch_Text.setBorderStyle(OUTLINE_FAST, 0xFF000000, 5, 0.5);
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
			
				if (controls.LEFT)
                    {
                        changeStuff(-1);
						SaveSound();
                    }
        
                    if (controls.RIGHT)
                    {
                        changeStuff(1);
						SaveSound();
                    }

            if (controls.BACK)
                {
                    FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    FlxG.switchState(new MainMenuState());
                }	
                
            if (controls.ACCEPT)
                {
                    FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);

                    if (curSelected == 4)
                    {
                        switch (ModifierSwitch)
                        {
                            case 1:
                                ModifierSwitch = 0;
                                ModifiersState.ClearModifiers();
                                ModifiersState.SaveModifiers();
                                ModifierSwitch_Text.text = "OFF";
                            case 0:
                                ModifierSwitch = 1;
                                ModifierSwitch_Text.text = "ON";
                        }
                    }
                }
        }

    function changeItem(huh:Int = 0)
        {
            curSelected += huh;
        
            if (curSelected >= menuItems.length)
                curSelected = 0;
            if (curSelected < 0)
                curSelected = menuItems.length - 1;
    
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

	function changeStuff(Change:Int = 0)
		{
			switch (curSelected)
			{
				case 0:
					TitleState.Music_Volume += Change;
					if (TitleState.Music_Volume > 100)
						TitleState.Music_Volume = 100;
					if (TitleState.Music_Volume < 0)
						TitleState.Music_Volume = 0;
					FlxG.sound.music.volume = TitleState.Music_Volume/100;
                    FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
                    MusicVolume_Text.text = TitleState.Music_Volume+"%";
				case 1:
					TitleState.Sound_Volume += Change;
					if (TitleState.Sound_Volume > 100)
						TitleState.Sound_Volume = 100;
					if (TitleState.Sound_Volume < 0)
						TitleState.Sound_Volume = 0;
                    SoundVolume_Text.text = TitleState.Sound_Volume+"%";
                    FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
				case 2:
					TitleState.Vocals_Volume += Change;
					if (TitleState.Vocals_Volume > 100)
						TitleState.Vocals_Volume = 100;
					if (TitleState.Vocals_Volume < 0)
						TitleState.Vocals_Volume = 0;
                    VocalsVolume_Text.text = TitleState.Vocals_Volume+"%";
                    FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
				case 3:
					NoteOffset += Change;
					if (NoteOffset > 150)
						NoteOffset = 150;
					if (NoteOffset < -150)
						NoteOffset = -150;
                    NoteOffset_Text.text = NoteOffset+" ms";
                    FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, TitleState.Sound_Volume/100);
			}
		}
	
	function SaveSound():Void
	{
		FlxG.save.data.Music_Volume = TitleState.Music_Volume;
        FlxG.save.data.Sound_Volume = TitleState.Sound_Volume;
		FlxG.save.data.Vocals_Volume = TitleState.Vocals_Volume;
		FlxG.save.data.NoteOffset = NoteOffset;

        FlxG.save.flush();
	}
}
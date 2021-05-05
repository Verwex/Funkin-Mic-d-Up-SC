package;
import openfl.display.FPS;
import lime.utils.Assets;
import haxe.Json;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import flixel.FlxG;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.BitmapFilter;

typedef Variables =
{
    var resolution:Float;
    var fullscreen:Bool;
    var fps:Int;
    var mvolume:Int;
    var svolume:Int;
    var vvolume:Int;
    var scoreDisplay:Bool;
    var missesDisplay:Bool;
    var accuracyDisplay:Bool;
    var noteOffset:Int;
    var spamPrevention:Bool;
    var firstTime:Bool;
    var accuracyType:String;
    var ratingDisplay:Bool;
    var timingDisplay:Bool;
    var comboDisplay:Bool;
    var iconZoom:Float;
    var cameraZoom:Float;
    var cameraSpeed:Float;
    var filter:String;
    var brightness:Int;
    var gamma:Float;
    var muteMiss:Bool;
    var scroll:String;
    var songPosition:Bool;
    var nps:Bool;
    var fpsCounter:Bool;
    var comboP:Bool;
    var memory:Bool;
    var cutscene:Bool;
    var music:String;
    var watermark:Bool;
    var rainbow:Bool;
    var lateD:Bool;
    var sickX:Float;
    var sickY:Float;
}

class MainVariables
{
    public static var _variables:Variables;

    public static var filters:Array<BitmapFilter> = [];
    public static var matrix:Array<Float>;

    public static function Save():Void
    {
        File.saveContent(('config.json'), Json.stringify(_variables));
    }

    public static function Load():Void
    {

        if (!FileSystem.exists('config.json'))
        {
            _variables = {
                resolution: 1,
                fullscreen: false,
                fps: 60,
                mvolume: 100,
                svolume: 100,
                vvolume: 100,
                scoreDisplay: true,
                missesDisplay: true,
                accuracyDisplay: true,
                noteOffset: 0,
                spamPrevention: false,
                firstTime: true,
                accuracyType: 'complex',
                ratingDisplay: true,
                timingDisplay: true,
                comboDisplay: true,
                iconZoom: 1,
                cameraZoom: 1,
                cameraSpeed: 1,
                filter: 'none',
                brightness: 0,
                gamma: 1,
                muteMiss: true,
                fpsCounter: true,
                songPosition: true,
                nps: true,
                comboP: true,
                memory: true,
                cutscene: true,
                music: "classic",
                watermark: true,
                rainbow: false,
                lateD: false,
                sickX: 650,
                sickY: 320,
                //up to do in week 7 update
                scroll: 'up'
            };
            
            Save();
        }
        else
        {
            var data:String = File.getContent(('config.json'));
            _variables = Json.parse(data);
        }

        FlxG.resizeWindow(Math.round(FlxG.width*_variables.resolution), Math.round(FlxG.height*_variables.resolution));
        FlxG.fullscreen = _variables.fullscreen;
        FlxG.drawFramerate = _variables.fps;
        FlxG.updateFramerate = _variables.fps;
        Main.toggleFPS(_variables.fpsCounter);
        Main.toggleMem(_variables.memory);
        Main.watermark.visible = _variables.watermark;

        UpdateColors();
    }

    public static function UpdateColors():Void
    {
        filters = [];
        
        switch (_variables.filter)
        {
            case 'none':
                matrix = [
                    1 * _variables.gamma, 0, 0, 0, _variables.brightness,
                    0, 1 * _variables.gamma, 0, 0, _variables.brightness,
                    0, 0, 1 * _variables.gamma, 0, _variables.brightness,
                    0, 0, 0, 1, 0,
                ];
            case 'tritanopia':
                matrix = [
                    0.20 * _variables.gamma, 0.99 * _variables.gamma, -.19 * _variables.gamma, 0, _variables.brightness,
                    0.16 * _variables.gamma, 0.79 * _variables.gamma, 0.04 * _variables.gamma, 0, _variables.brightness,
                    0.01 * _variables.gamma, -.01 * _variables.gamma,    1 * _variables.gamma, 0, _variables.brightness,
                       0,    0,    0, 1, 0,
                ];
            case 'protanopia':
                matrix = [
                    0.20 * _variables.gamma, 0.99 * _variables.gamma, -.19 * _variables.gamma, 0, _variables.brightness,
                    0.16 * _variables.gamma, 0.79 * _variables.gamma, 0.04 * _variables.gamma, 0, _variables.brightness,
                    0.01 * _variables.gamma, -.01 * _variables.gamma,    1 * _variables.gamma, 0, _variables.brightness,
                       0,    0,    0, 1, 0,
                ];
            case 'deutranopia':
                matrix = [
                    0.43 * _variables.gamma, 0.72 * _variables.gamma, -.15 * _variables.gamma, 0, _variables.brightness,
                    0.34 * _variables.gamma, 0.57 * _variables.gamma, 0.09 * _variables.gamma, 0, _variables.brightness,
                    -.02 * _variables.gamma, 0.03 * _variables.gamma,    1 * _variables.gamma, 0, _variables.brightness,
                       0,    0,    0, 1, 0,
                ];
            case 'virtual boy':
                matrix = [
                    0.9 * _variables.gamma, 0, 0, 0, _variables.brightness,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 1, 0,
                ];
            case 'gameboy':
                matrix = [
                    0, 0, 0, 0, 0,
                    0, 1.5 * _variables.gamma, 0, 0, _variables.brightness,
                    0, 0, 0, 0, 0,
                    0, 0, 0, 1, 0,
                ];
            case 'downer':
                matrix = [
                    0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0,
                    0, 0, 1.5 * _variables.gamma, 0, _variables.brightness,
                    0, 0, 0, 1, 0,
                ];
            case 'grayscale':
                matrix = [
                    .3 * _variables.gamma, .3 * _variables.gamma, .3 * _variables.gamma, 0,  _variables.brightness,
                    .3 * _variables.gamma, .3 * _variables.gamma, .3 * _variables.gamma, 0, _variables.brightness,
                    .3 * _variables.gamma, .3 * _variables.gamma, .3 * _variables.gamma, 0, _variables.brightness,
                    0, 0, 0, 1, 0,
                ];
        }

        filters.push(new ColorMatrixFilter(matrix));
        FlxG.game.filtersEnabled = true;
        FlxG.game.setFilters(filters);
    }
}
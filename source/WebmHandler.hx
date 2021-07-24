package;

import flixel.FlxG;
import openfl.display.Sprite;
import haxe.io.Bytes;
import haxe.io.BytesData;
import openfl.utils.ByteArray;
import sys.io.File;
#if desktop
import webm.*;
#end

class WebmHandler
{
	#if desktop
	public var webm:WebmPlayer;
	public var vidPath:String = "";
	public var io:WebmIo;
	public var initialized:Bool = false;

	public function new()
	{
	}

	public function source(?vPath:String):Void
	{
		if (vPath != null && vPath.length > 0)
		{
			vidPath = vPath;
		}
	}

	public function makePlayer():Void
	{
		io = new WebmByteArray(ByteArray.fromBytes(File.getBytes(vidPath)));
		webm = new WebmPlayer();
		webm.fuck(io, false);
		webm.addEventListener(WebmEvent.PLAY, function(e)
		{
			onPlay();
		});
		webm.addEventListener(WebmEvent.COMPLETE, function(e)
		{
			onEnd();
		});
		webm.addEventListener(WebmEvent.STOP, function(e)
		{
			onStop();
		});
		webm.addEventListener(WebmEvent.RESTART, function(e)
		{
			onRestart();
		});
		webm.visible = false;
		initialized = true;
	}

	public function updatePlayer():Void
	{
		io = new WebmIoFile(vidPath);
		webm.fuck(io, false);
	}

	public function play():Void
	{
		if (initialized)
		{
			webm.play();
		}
	}

	public function stop():Void
	{
		if (initialized)
		{
			webm.stop();
		}
	}

	public function restart():Void
	{
		if (initialized)
		{
			webm.restart();
		}
	}

	public function update(elapsed:Float)
	{
		webm.x = GlobalVideo.calc(0);
		webm.y = GlobalVideo.calc(1);
		webm.width = GlobalVideo.calc(2);
		webm.height = GlobalVideo.calc(3);
	}

	public var stopped:Bool = false;
	public var restarted:Bool = false;
	public var played:Bool = false;
	public var ended:Bool = false;
	public var paused:Bool = false;

	public function pause():Void
	{
		webm.changePlaying(false);
		paused = true;
	}

	public function resume():Void
	{
		webm.changePlaying(true);
		paused = false;
	}

	public function togglePause():Void
	{
		if (paused)
		{
			resume();
		}
		else
		{
			pause();
		}
	}

	public function clearPause():Void
	{
		paused = false;
		webm.removePause();
	}

	public function onStop():Void
	{
		stopped = true;
	}

	public function onRestart():Void
	{
		restarted = true;
	}

	public function onPlay():Void
	{
		played = true;
	}

	public function onEnd():Void
	{
		trace("IT ENDED!");
		ended = true;
	}

	public function alpha():Void
	{
		webm.alpha = GlobalVideo.daAlpha1;
	}

	public function unalpha():Void
	{
		webm.alpha = GlobalVideo.daAlpha2;
	}

	public function hide():Void
	{
		webm.visible = false;
	}

	public function show():Void
	{
		webm.visible = true;
	}
	#else
	public var webm:Sprite;

	public function new()
	{
		trace("THIS IS ANDROID! or some shit...");
	}
	#end
}

class WebmByteArray extends webm.WebmIo
{
	var data:ByteArray;

	public function new(data:ByteArray)
	{
		super();

		this.data = data;
		create();
	}

	override function read(count:Int):BytesData
	{
		var out:ByteArray = new ByteArray();
		data.readBytes(out, 0, count);
		out.position = 0;
		var bytes:Bytes = Bytes.alloc(out.length);
		while (out.bytesAvailable > 0)
		{
			var position = out.position;
			bytes.set(position, out.readByte());
		}
		return bytes.getData();
	}

	override function seek(offset:Float, whence:Int):Int
	{
		switch (whence)
		{
			case 0:
				data.position = Std.int(offset);
			case 1:
				data.position = Std.int(data.position + offset);
			case 2:
				data.position = Std.int(data.length + offset);
		}
		return 0;
	}

	override function tell():Float
	{
		return data.position;
	}
}
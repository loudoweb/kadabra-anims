package kadabra.animations;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.FrameLabel;
import openfl.display.MovieClip;
import openfl.display.PixelSnapping;
import openfl.display.Scene;
import openfl.display.Timeline;
import openfl.utils.AssetType;
using StringTools;

/**
 * Create an animation with sequence of png
 * FOR OPENFL
 * @author Ludovic Bas
 */
class SimpleTimeline extends Timeline
{
	var clip:MovieClip;
	var frames:Array<BitmapData>;
	var bitmap:Bitmap;
	
	public function new(prefix:String, frameRate:Int = 12) 
	{
		super();
		
		//short hack
		var extension = prefix.substring(prefix.indexOf(".png"));
		prefix = prefix.substring(0, prefix.indexOf(extension));
		
		frames = [];
		this.frameRate = frameRate;
		var list:Array<String> = Assets.list(AssetType.IMAGE);
		for (asset in list)
		{
			if (asset.startsWith(prefix))
			{
				frames.push(Assets.getBitmapData(asset));
			}
		}
		
		scenes = [ new Scene("", [ new FrameLabel("start", 1), new FrameLabel("end", frames.length) ], frames.length) ];
        //scripts = [ new FrameScript(function(mc) mc.stop(), 100) ];
		
		bitmap = new Bitmap(frames[0], PixelSnapping.ALWAYS, true);
	}
	
	override public function attachMovieClip(movieClip:MovieClip):Void
    {
        clip = movieClip;
		clip.addChild(bitmap);
    }
	
	override public function enterFrame(frame:Int):Void 
	{
		bitmap.bitmapData = frames[frame - 1];
	}
	
}
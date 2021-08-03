package kadabra.animations;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Bounce;
import motion.easing.Elastic;
import motion.easing.Linear;
import motion.easing.Quad;

enum EPreset {
	CLIC;
	FADEIN;
	FADEIN_X;
	FADEIN_Y;
	FADEOUT;
	FADEOUT_X;
	FADEOUT_Y;
	BOUNCE;
	FLASH;
	RUBBERBAND;
	SWING;
	TADA;
	BACKIN;
	BACKOUT;
	LIGHTSPEEDIN_X;
	LIGHTSPEEDIN_Y;
	FLIPIN_X;
	FLIPIN_Y;
	FLIPOUT_X;
	FLIPOUT_Y;
	SHAKE;
	SPREADOUT;
	BREATHE;
	BREATHE_ALPHA;
}
/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class Presets 
{
	/**
	 * If you want Presets handles the center pivot for you, set this variable to true.
	 * Useful for all presets that scales. TODO implement everywhere.
	 */
	public static var HANDLE_CENTER_PIVOT:Bool = false;

	/**
	 * Loop animation for buttons, sprites
	 */
	public static function breathe<T> (target:T, duration:Float = 2.5, scale:Float = 1.15):T
	{
		Actuate.tween(target, duration, {scaleX:  scale, scaleY: scale}).ease(Quad.easeInOut);
		Actuate.tween(target, duration / 2, {scaleX:  1, scaleY: 1}, false).ease(Quad.easeInOut).delay(duration);
		Actuate.timer(duration / 4).delay(duration + duration / 2).onComplete(() -> breathe(target));
		return target;
	}
	
	/**
	 * Loop animation for buttons, sprites
	 */
	public static function breatheAlpha<T> (target:T, duration:Float = 2.5, alphaMin:Float = 0):T
	{
		Actuate.apply(target, {alpha: alphaMin});
		Actuate.tween(target, duration, {alpha:  1}).ease(Quad.easeInOut);
		Actuate.tween(target, duration / 2, {alpha: alphaMin}, false).ease(Quad.easeInOut).delay(duration);
		Actuate.timer(duration / 4).delay(duration + duration / 2).onComplete(() -> breatheAlpha(target));
		return target;
	}
	
	/**
	 * Exit
	 */
	public static function spreadOut<T> (target:T, duration:Float = 0.75):T
	{
		if (!HANDLE_CENTER_PIVOT)
			Actuate.tween(target, duration, {alpha:  0, scaleX: 1.75, scaleY: 1.75});
		else{
			var _x:Float = Reflect.getProperty(target, "x");
			var _y:Float = Reflect.getProperty(target, "y");
			var _w:Float = Reflect.getProperty(target, "width");
			var _h:Float = Reflect.getProperty(target, "height");
			Actuate.tween(target, duration, {alpha:  0, scaleX: 1.75, scaleY: 1.75, x: _x - .375 * _w  , y: _y - .375 * _h});
		}
		return target;
	}
	
	/**
	 * Generic animation for a clic on a button
	 */
	public static function clic<T> (target:T, duration:Float = 0.25, scale:Float = 0.9):T
	{
		Actuate.tween(target, duration, {scaleX:  scale, scaleY: scale}).onComplete(() -> Actuate.apply(target, {scaleX: 1, scaleY:1} ));
		return target;
	}
	
	/**
	 * entrance
	 */
	public static function fadeIn<T> (target:T, duration:Float = 1.0):T
	{
		var alpha:Float = Reflect.getProperty(target, "alpha");
		Actuate.apply(target, {alpha: 0});
		Actuate.tween(target, duration, {alpha:  alpha});
		return target;
	}
	
	/**
	 * entrance
	 */
	public static function fadeInX<T> (target:T, duration:Float = 1.0, translation:Int = 100):T
	{
		var current:Float = Reflect.getProperty(target, "x");
		var alpha:Float = Reflect.getProperty(target, "alpha");
		Actuate.apply(target, {x: current + translation, alpha:0});
		Actuate.tween(target, duration, {x:  current, alpha: alpha});
		return target;
	}
	
	/**
	 * entrance
	 */
	public static function fadeInY<T> (target:T, duration:Float = 1.0, translation:Int = 100):T
	{
		var current:Float = Reflect.getProperty(target, "y");
		var alpha:Float = Reflect.getProperty(target, "alpha");
		Actuate.apply(target, {y: current - translation, alpha: 0});
		Actuate.tween(target, duration, {y:  current, alpha: alpha});
		return target;
	}
	
	/**
	 * exit
	 */
	public static function fadeOut<T> (target:T, duration:Float = 1.0):T
	{
		Actuate.tween(target, duration, {alpha:  0});
		return target;
	}
	
	/**
	 * exit
	 */
	public static function fadeOutX<T> (target:T, duration:Float = 1.0, translation:Int = 100):T
	{
		var current:Float = Reflect.getProperty(target, "x");
		Actuate.tween(target, duration, {x:  current + translation, alpha: 0});
		return target;
	}
	
	/**
	 * exit
	 */
	public static function fadeOutY<T> (target:T, duration:Float = 1.0, translation:Int = 100):T
	{
		var current:Float = Reflect.getProperty(target, "y");
		Actuate.tween(target, duration, {y:  current + translation, alpha: 0});
		return target;
	}
	
	/**
	 * For camera or game asset
	 */
	public static function shake<T> (target:T, duration:Float = 1.0, translation:Int = 42, axes:Int = 3, fps:Int = 60, ?currentX:Float, ?currentY:Float):T
	{
		currentX = currentX != null ? currentX : Reflect.getProperty(target, "x");
		currentY = currentY != null ? currentY : Reflect.getProperty(target, "y");
		if(axes == 3 || axes == 1)
			Actuate.apply(target, {x: currentX +  Math.floor(Math.random() * (1 + translation * 2)) -translation});
		if(axes == 3 || axes == 2)
			Actuate.apply(target, {y: currentY +  Math.floor(Math.random() * (1 + translation * 2)) -translation});
		duration -= 1 / fps;

		if(duration > 0)
			Actuate.timer(1 / fps).onComplete(shake, [target, duration, translation, axes, fps, currentX, currentY]) ;
		else
			Actuate.apply(target, {x: currentX, y: currentY});
		return target;
	}
	
	/**
	 * get attention
	 * adapted from css https://animate.style
	 */
	public static function bounce<T> (target:T, duration:Float = 1.0, translation:Int = 42):T
	{
		var current = Reflect.getProperty(target, "y");
		Actuate.tween(target, duration / 2, {y: current - translation});
		Actuate.tween(target, duration / 2, {y: current}, false).delay(duration / 2).ease(Bounce.easeOut);
		return target;
	}
	
	/**
	 * get attention
	 * adapted from css https://animate.style
	 */
	public static function flash<T> (target:T, duration:Float = 1.0):T
	{
		var current = Reflect.getProperty(target, "alpha");
		Actuate.tween(target, duration * .25, {alpha: 0}).autoVisible(false).ease(Quad.easeInOut);
		Actuate.tween(target, duration * .25, {alpha: 1}, false).autoVisible(false).ease(Quad.easeInOut).delay( duration * .25);
		Actuate.tween(target, duration * .25, {alpha: 0}, false).autoVisible(false).ease(Quad.easeInOut).delay( duration * .5);
		Actuate.tween(target, duration * .25, {alpha: 1}, false).autoVisible(false).ease(Quad.easeInOut).delay( duration * .75);
		return target;
	}
	/**
	 * get attention
	 * adapted from css https://animate.style
	 */
	public static function rubberband<T> (target:T, duration: Float = 1.0):T
	{
		Actuate.tween(target, duration * .3, {scaleX: 1.25, scaleY:0.75});
		Actuate.tween(target, duration * .1, {scaleX: .75, scaleY:1.25}, false).delay( duration * .3);
		Actuate.tween(target, duration * .1, {scaleX: 1.15, scaleY:.85}, false).delay( duration * .4);
		Actuate.tween(target, duration * .15, {scaleX: .95, scaleY:1.05}, false).delay( duration * .5);
		Actuate.tween(target, duration * .1, {scaleX: 1.05, scaleY:.95}, false).delay( duration * .65);
		Actuate.tween(target, duration * .25, {scaleX: 1, scaleY:1}, false).delay( duration * .75);
		return target;
	}
	
	/**
	 * get attention
	 * adapted from css https://animate.style
	 */
	public static function swing<T> (target:T, duration: Float = 1.0):T
	{
		Actuate.tween(target, duration * .2, {rotation: 15}).smartRotation();
		Actuate.tween(target, duration * .2, {rotation: -10}, false).smartRotation().delay( duration * .2);
		Actuate.tween(target, duration * .2, {rotation: 5}, false).smartRotation().delay( duration * .4);
		Actuate.tween(target, duration * .2, {rotation: -5}, false).smartRotation().delay( duration * .6);
		Actuate.tween(target, duration * .2, {rotation: 0}, false).smartRotation().delay( duration * .8);
		return target;
	}
	
	/**
	 * get attention
	 * adapted from css https://animate.style
	 */
	public static function tada<T> (target:T, duration: Float = 1.0):T
	{
		Actuate.tween(target, duration * .1, {scaleX: .9, scaleY: .9, rotation: -3}).smartRotation();
		Actuate.tween(target, duration * .1, {scaleX: 1.1, scaleY: 1.1, rotation: 3}, false).smartRotation().delay( duration * .2);
		Actuate.tween(target, duration * .1, {rotation: -3}, false).smartRotation().delay( duration * .3);
		Actuate.tween(target, duration * .1, {rotation: 3}, false).smartRotation().delay( duration * .4);
		Actuate.tween(target, duration * .1, {rotation: -3}, false).smartRotation().delay( duration * .5);
		Actuate.tween(target, duration * .1, {rotation: 3}, false).smartRotation().delay( duration * .6);
		Actuate.tween(target, duration * .1, {rotation: -3}, false).smartRotation().delay( duration * .7);
		Actuate.tween(target, duration * .1, {rotation: 3}, false).smartRotation().delay( duration * .8);
		Actuate.tween(target, duration * .1, {scaleX: 1, scaleY: 1, rotation: 0}, false).smartRotation().delay( duration * .9);
		return target;
	}
	
	/**
	 * entrance
	 * adapted from css https://animate.style
	 */
	public static function backIn<T> (target:T, duration: Float = 1.0, translation:Int = 100):T
	{
		var current = Reflect.getProperty(target, "y");
		Actuate.apply(target, {alpha: 0, scaleX: .7, scaleY: .7, y: current + translation}).autoVisible(false);
		Actuate.tween(target, duration * .8, {alpha: 0.8, y: current});
		Actuate.tween(target, duration * .2, {scaleX: 1, scaleY: 1, alpha: 1}, false).delay( duration * .8);
		return target;
	}
	
	/**
	 * exit
	 * adapted from css https://animate.style
	 */
	public static function backOut<T> (target:T, duration: Float = 1.0, translation:Int = 100):T
	{
		var current = Reflect.getProperty(target, "y");
		Actuate.tween(target, duration * .2, {alpha: .8, scaleX: .8, scaleY: .7});
		Actuate.tween(target, duration * .8, {y: current + translation, alpha: 0}, false).delay( duration * .2);
		return target;
	}
	
	#if openfl
	/**
	 * Entrance
	 * Openfl only because it uses matrix
	 * adapted from css https://animate.style
	 */
	public static function lightSpeedInX (target:openfl.display.DisplayObject, duration: Float = 1.0, translation:Int = 100):openfl.display.DisplayObject
	{
		var current:Float = target.x;
		var alpha:Float = target.alpha;
		target.x = current + translation;
		target.alpha = 0;
		var matrix = new openfl.geom.Matrix();
		matrix.concat(target.transform.matrix);
		
		Actuate.tween(target, duration, {alpha: 1});
		Actuate.tween(matrix, duration, {tx:  current}).onUpdate(updateMatrix, [target, matrix]);
		Actuate.tween(matrix, duration * .6, {c:  20 * Math.PI / 180}, false).onUpdate(updateMatrix, [target, matrix]);
		Actuate.tween(matrix, duration * .2, {c:  -5 * Math.PI / 180}, false).delay(duration * .6).onUpdate(updateMatrix, [target, matrix]);
		Actuate.tween(matrix, duration * .2, {c:  0}, false).delay(duration * .8).onUpdate(updateMatrix, [target, matrix]);
		return target;
	}
	/**
	 * Entrance
	 * Openfl only because it uses matrix
	 * adapted from css https://animate.style
	 */
	public static function lightSpeedInY (target:openfl.display.DisplayObject, duration: Float = 1.0, translation:Int = 100):openfl.display.DisplayObject
	{
		var current:Float = target.y;
		var alpha:Float = target.alpha;
		target.y = current + translation;
		target.alpha = 0;
		var matrix = new openfl.geom.Matrix();
		matrix.concat(target.transform.matrix);
		
		Actuate.tween(target, duration, {alpha: 1});
		Actuate.tween(matrix, duration, {ty:  current}).onUpdate(updateMatrix, [target, matrix]);
		Actuate.tween(matrix, duration * .6, {b:  20 * Math.PI / 180}, false).onUpdate(updateMatrix, [target, matrix]);
		Actuate.tween(matrix, duration * .2, {b:  -5 * Math.PI / 180}, false).delay(duration * .6).onUpdate(updateMatrix, [target, matrix]);
		Actuate.tween(matrix, duration * .2, {b:  0}, false).delay(duration * .8).onUpdate(updateMatrix, [target, matrix]);
		return target;
	}
	
	static function updateMatrix(target:openfl.display.DisplayObject, matrix:openfl.geom.Matrix):Void
	{
		target.transform.matrix = matrix;
	}
	#end
	
	/**
	 * Entrance
	 */
	public static function flipInX<T> (target:T, duration: Float = 1.0):T
	{
		var current = Reflect.getProperty(target, "alpha");
		Actuate.apply(target, {alpha: 0, scaleX: -1});
		Actuate.tween(target, duration, {alpha: current, scaleX: 1}).ease(Elastic.easeOut);
		return target;
	}
	
	/**
	 * Entrance
	 */
	public static function flipInY<T> (target:T, duration: Float = 1.0):T
	{
		var current = Reflect.getProperty(target, "alpha");
		Actuate.apply(target, {alpha: 0, scaleY: -1});
		Actuate.tween(target, duration, {alpha: current, scaleY: 1}).ease(Elastic.easeOut);
		return target;
	}
	
	/**
	 * Entrance
	 */
	public static function flipOutX<T> (target:T, duration: Float = 1.0):T
	{
		Actuate.tween(target, duration, {alpha: 0, scaleX: -1}).ease(Elastic.easeIn);
		return target;
	}
	
	/**
	 * Entrance
	 */
	public static function flipOutY<T> (target:T, duration: Float = 1.0):T
	{
		Actuate.tween(target, duration, {alpha: 0, scaleY: -1}).ease(Elastic.easeIn);
		return target;
	}
	
	/**
	 * wip
	 * for game asset
	 */
	public static function hit<T> (target:T, duration:Float = 1.0, rotation:Int = 10):T
	{
		var current:Float = Reflect.getProperty(target, "rotation");
		Actuate.tween(target, duration *.25, {rotation:  rotation}).ease(Linear.easeNone);
		Actuate.tween(target, duration *.25, {rotation:  -rotation}, false).ease(Linear.easeNone).delay(duration *.25);
		Actuate.tween(target, duration *.25, {rotation:  rotation/2}, false).ease(Linear.easeNone).delay(duration *5);
		Actuate.tween(target, duration *.25, {rotation:  0}, false).ease(Linear.easeNone).delay(duration *.75);
		return target;
	}
	
	/**
	 * Just a way to call a preset from a string
	 */
	public static function callPresetByName<T>(target:T, preset:String):Void
	{
		try{
			var p = Type.createEnum(EPreset, preset.toUpperCase());
			callPreset(target, p);
		}catch (e)
		{
			trace('preset $preset doesn\'t exist');
		}
	}
	
	public static function callPresetByIndex<T>(target:T, preset:Int):Void
	{
		var p = Type.createEnumIndex(EPreset, preset);
		callPreset(target, p);
	}
	
	public static function callPreset<T>(target:T, preset:EPreset):Void
	{
		switch (preset) 
		{
			case BREATHE:
				breathe(target);
			case BREATHE_ALPHA:
				breatheAlpha(target);
			case SPREADOUT:
				spreadOut(target);
			case CLIC:
				clic(target);
			case FADEIN:
				fadeIn(target);
			case FADEIN_X:
				fadeInX(target);
			case FADEIN_Y:
				fadeInY(target);
			case FADEOUT:
				fadeOut(target);
			case FADEOUT_X:
				fadeOutX(target);
			case FADEOUT_Y:
				fadeOutY(target);
			case SHAKE:
				shake(target);
			case BOUNCE:
				bounce(target);
			case FLASH:
				flash(target);
			case RUBBERBAND:
				rubberband(target);
			case SWING:
				swing(target);
			case TADA:
				tada(target);
			case BACKIN:
				backIn(target);
			case BACKOUT:
				backOut(target);
			#if openfl
			case LIGHTSPEEDIN_X:
				lightSpeedInX(cast (target, openfl.display.DisplayObject));
			case LIGHTSPEEDIN_Y:
				lightSpeedInY(cast (target, openfl.display.DisplayObject));
			#end
			case FLIPIN_X:
				flipInX(target);
			case FLIPIN_Y:
				flipInY(target);
			case FLIPOUT_X:
				flipOutX(target);
			case FLIPOUT_Y:
				flipOutY(target);
				
		}
	}
	
}
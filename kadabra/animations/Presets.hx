package kadabra.animations;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Bounce;
import motion.easing.Linear;
import motion.easing.Quad;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class Presets 
{

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
	
	public static function spread<T> (target:T, duration:Float = 0.75):T
	{
		Actuate.tween(target, duration, {alpha:  0, scaleX: 1.75, scaleY: 1.75});
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
	
	public static function appear<T> (target:T, duration:Float = 1.0):T
	{
		var alpha:Float = Reflect.getProperty(target, "alpha");
		Actuate.apply(target, {alpha: 0});
		Actuate.tween(target, duration, {alpha:  alpha});
		return target;
	}
	
	public static function appearX<T> (target:T, duration:Float = 1.0, translation:Int = 100):T
	{
		var current:Float = Reflect.getProperty(target, "x");
		var alpha:Float = Reflect.getProperty(target, "alpha");
		Actuate.apply(target, {x: current + translation, alpha:0});
		Actuate.tween(target, duration, {x:  current, alpha: alpha});
		return target;
	}
	
	public static function appearY<T> (target:T, duration:Float = 1.0, translation:Int = 100):T
	{
		var current:Float = Reflect.getProperty(target, "y");
		var alpha:Float = Reflect.getProperty(target, "alpha");
		Actuate.apply(target, {y: current - translation, alpha: 0});
		Actuate.tween(target, duration, {y:  current, alpha: alpha});
		return target;
	}
	
	public static function shake<T> (target:T, duration:Float = 1.0, translation:Int = 100, axes:Int = 3, fps:Int = 60, ?currentX:Float, ?currentY:Float):T
	{
		currentX = currentX != null ? currentX : Reflect.getProperty(target, "x");
		currentY = currentY != null ? currentY : Reflect.getProperty(target, "y");
		if(axes == 3 || axes == 1)
			Actuate.apply(target, {x: currentX +  Math.floor(Math.random() * (1 + translation * 2)) -translation});
		if(axes == 3 || axes == 2)
			Actuate.apply(target, {y: currentY +  Math.floor(Math.random() * (1 + translation * 2)) -translation});
		duration -= 1 / fps;
		trace(duration);
		if(duration > 0)
			Actuate.timer(1 / fps).onComplete(shake, [target, duration, translation, axes, fps, currentX, currentY]) ;
		else
			Actuate.apply(target, {x: currentX, y: currentY});
		return target;
	}
	
	//wip
	public static function hit<T> (target:T, duration:Float = 1.0, rotation:Int = 10):T
	{
		var current:Float = Reflect.getProperty(target, "rotation");
		Actuate.tween(target, duration/4, {rotation:  rotation}).ease(Linear.easeNone);
		Actuate.tween(target, duration/4, {rotation:  -rotation}, false).ease(Linear.easeNone).delay(duration/4);
		Actuate.tween(target, duration/4, {rotation:  rotation/2}, false).ease(Linear.easeNone).delay(duration/2);
		Actuate.tween(target, duration/4, {rotation:  0}, false).ease(Linear.easeNone).delay(duration/4 * 3);
		return target;
	}
	
}
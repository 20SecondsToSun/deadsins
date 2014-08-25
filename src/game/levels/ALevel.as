package game.levels {	

	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.physics.box2d.Box2D;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import game.controllers.MobileInput;
	import org.osflash.signals.Signal;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	import game.controllers.Assets;
	/**
	 * @author Aymeric
	 */
	public class ALevel extends StarlingState
	{
		public var lvlEnded		:Signal;		
		public var restartLevel	:Signal;
		
		protected var box2D     :Box2D;	
		protected var assets:AssetManager;
		protected var _mobileInput:MobileInput;
		
		
		
		
		
		private var _timeoutID	:uint;
		
		protected var _level	:MovieClip;		
	
		
		public var touch		:Touch;
		
		protected var killcount :int;
		protected var enemyArray:Vector.<Enemy>;
		
		
		
		
		public function ALevel(level:MovieClip = null)
		{			
			super();
			_level 		 = level;
			
			lvlEnded	 = new Signal();
			restartLevel = new Signal();
			
			// Useful for not forgetting to import object from the Level Editor
			_mobileInput = new MobileInput();
			_mobileInput.initialize();				
			_mobileInput.touch.add(touchHandler);
			
		}		
		
		protected function touchHandler(phase:String):void 
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();	
			
			var box2D:Box2D = new Box2D("box2D");
			//box2D.visible = true;
			add(box2D);			
			
			loadAssets();			
		}		
		
		private function loadAssets():void 
		{
			assets = new AssetManager();
			assets.verbose = true;
			assets.enqueue(Assets);
			
			assets.loadQueue(function(ratio:Number):void
				{
					//trace("Loading assets, progress:", ratio);
					
					if (ratio == 1.0)
						// add game elements
						inititalizeLevel();
				});
		}
		
		protected function inititalizeLevel():void 
		{
		
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		
		
		public function createHero(_x:Number, _y:Number):void
		{
			
			
		}		
		
		protected function nextlevel():void	
		{
			_timeoutID = setTimeout(function():void {

			lvlEnded.dispatch();
			
			}, 2000);
		}
		protected function levelCreation():void	{
			
		}			
		
		protected function _changeLevel(contact:b2Contact):void {
		
		}

		private function handleGroundClick(e:MouseEvent):void 
		{
			trace("OK");
		}

		private function heroHurt():void {
			//_ce.sound.playSound("Hurt");
		}
		
		private function heroAttack():void {
			//_ce.sound.playSound("Kill");
		}

		private function coinTouched(contact:b2Contact):void 
		{
			trace('coin touched by an object');
		}

	}
}

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
		}		
		
		override public function initialize():void
		{
			super.initialize();	
			
			var box2D:Box2D = new Box2D("box2D");
			box2D.visible = true;
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
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//private var touchLine;
		private var _interval_max:Number = 0.1;
		
		private var _interval:Number = 0;
		private var _preTimeStamp:Number = 0;
		
		protected var touchPoint1:b2Vec2;
		protected var touchPoint2:b2Vec2;
		
		protected var mouseTrace:Shape = new Shape();
		
		private var touchPointArray:Vector.<b2Vec2>;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		protected function onTouch(event:TouchEvent):void 
		{
			touch = event.getTouch(stage);
			
			if (!touch) return;
			
			 trace(touch.phase);
			
			
			if(touch.phase == TouchPhase.BEGAN)
			{
				_interval = 0;
				_preTimeStamp = touch.timestamp;
				touchPoint1 = new b2Vec2( touch.globalX, touch.globalY);			
				touchPoint2 = null;	
				
				
				touchPointArray = new Vector.<b2Vec2>();
				touchPointArray.push(touchPoint1);
			}
			else if (touch.phase == TouchPhase.MOVED)
			{
				
				if ( touch.timestamp - _preTimeStamp > _interval_max)
				{					
					touchPoint1 = new b2Vec2( touch.globalX, touch.globalY);			
					touchPoint2 = new b2Vec2( touch.previousGlobalX, touch.previousGlobalY);	
					_preTimeStamp = touch.timestamp;
					
					touchPointArray = new Vector.<b2Vec2>();
					touchPointArray.push(touchPoint1);
					touchPointArray.push(touchPoint2);
					//trace("HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					
				}
				else
				{				
					touchPoint2 = new b2Vec2( touch.previousGlobalX, touch.previousGlobalY);	// new b2Vec2( touch.globalX, touch.globalY);	
					
					
					//touchPoint2 = new b2Vec2( touch.previousGlobalX, touch.previousGlobalY);
				//	trace("HERE---------------====================");
				}
				
				touchPointArray.push(new b2Vec2( touch.globalX, touch.globalY));
				
				if (touchPointArray.length > 5)
				{
					touchPointArray.splice(0, 1);
				}
				
				mouseTrace.graphics.clear();
				
				for (var i:int = 0; i < touchPointArray.length-1 ; i++) 				
				{					
					mouseTrace.graphics.lineStyle(4, 0xff0000);
					mouseTrace.graphics.moveTo( touchPointArray[i].x, touchPointArray[i].y );					
					mouseTrace.graphics.lineTo( touchPointArray[i + 1].x, touchPointArray[i + 1].y );					
				}
				
				///mouseTrace.graphics.moveTo( touchPointArray[0].x, touchPointArray[0].y );
				///mouseTrace.graphics.cubicCurveTo();
				
				trace(touchPointArray.length);
				
				//touchPoint1 = new b2Vec2( touch.globalX, touch.globalY);			
				//touchPoint2 = new b2Vec2( touch.previousGlobalX, touch.previousGlobalY);	
					
				
				
				
			//mouseTrace.graphics.curveTo( 500, 100, 500, 300 );
			//mouseTrace.graphics.curveTo( 500, 500, 700, 650 );
				//trace(touchPoint1.x - touchPoint2.x);
//				_inProcess = true;
				//_dx = touch.globalX - touch.previousGlobalX;
				//_dy = touch.globalY - touch.previousGlobalY;
				//_interval = t.timestamp - _preTimeStamp;
				//_preTimeStamp = t.timestamp;
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				touchPoint1 = null;
				touchPoint2 = null;		
				mouseTrace.graphics.clear();
				/*if(Math.abs(_dx) > _point_max || Math.abs(_dy) > _point_max && _interval < _interval_max)
				{
					validate = true;
				}*/
//				_inProcess = false;
			}
			else
			{
				mouseTrace.graphics.clear();
			}
			//return validate;
			
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

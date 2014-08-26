package game.levels {	

	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.physics.box2d.Box2D;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import game.controllers.Assets;
	import game.controllers.MobileInput;
	import game.heroes.Zombie;
	import org.osflash.signals.Signal;
	import starling.display.Shape;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.view.starlingview.AnimationSequence;
	/**
	 * @author Aymeric
	 */
	public class ALevel extends StarlingState
	{
		public var lvlEnded		:Signal;		
		public var restartLevel	:Signal;
		
		public var box2D        :Box2D;	
		protected var assets    :AssetManager;	
		
		private var _timeoutID	:uint;
		
		protected var _level	:MovieClip;		
		public var touch		:Touch;
		
		
		//private var touchLine;
		private var _interval_max:Number = 0.1;
		
		private var _interval:Number = 0;
		private var _preTimeStamp:Number = 0;
		
		protected var touchPoint1:b2Vec2;
		protected var touchPoint2:b2Vec2;
		
		protected var mouseTrace:Shape;
		
		private var touchPointArray:Vector.<b2Vec2>;
		
		
		protected var _deathToFinish:int = 1;
		protected var _deathCount:int = 0;		
		protected var killedZombieVector:Vector.<Zombie> = new Vector.<Zombie>();
		
		
		
		public function ALevel(level:MovieClip = null)
		{			
			super();
			_level 		 = level;
			
			lvlEnded	 = new Signal();
			restartLevel = new Signal();			
		}	
		
		override public function initialize():void
		{
			super.initialize();	
			
			inititalizeBox2d();	
			
			loadAssets();
			
			inititalizeTouchHandler();					
		}
		
		private function inititalizeBox2d():void 
		{
			box2D = new Box2D("box2D");
			//box2D.visible = true;
			add(box2D);			
		}
		
		private function inititalizeTouchHandler():void 
		{
			mouseTrace = new Shape();
			addChild(mouseTrace);
			(_ce as StarlingCitrusEngine).starling.stage.addEventListener(TouchEvent.TOUCH, onTouchHandler);	
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
		
		protected function onTouchHandler(event:TouchEvent):void 
		{
			touch = event.getTouch(stage);		
			
			if (!touch) return;
			
			
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
				}
				else
				{				
					touchPoint2 = new b2Vec2( touch.previousGlobalX, touch.previousGlobalY);						
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
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				touchPoint1 = null;
				touchPoint2 = null;		
				mouseTrace.graphics.clear();
			}
			else
			{
				mouseTrace.graphics.clear();
			}
			
			if (touch.phase == TouchPhase.MOVED)
			{
				var __scaleBox2d:Number = box2D.scale;
				var vec1:b2Vec2 = new b2Vec2(touchPoint1.x / __scaleBox2d, touchPoint1.y / __scaleBox2d);
				var vec2:b2Vec2 = new b2Vec2(touchPoint2.x / __scaleBox2d, touchPoint2.y / __scaleBox2d);
				
				box2D.world.RayCast(intersection, vec1, vec2);
			}
		}		
			
		protected function inititalizeLevel():void 
		{
			
		}
		
		public function intersection(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):void
		{
			
		}
		
		
		protected function nextlevel():void	
		{
			
			_timeoutID = setTimeout(function():void {

			lvlEnded.dispatch();
			
			}, 2000);
		}					
		
		protected function _changeLevel(contact:b2Contact):void {
		
		}
	}
}

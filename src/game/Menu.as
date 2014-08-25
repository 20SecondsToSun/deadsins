package game 
{
	import aze.motion.eaze;
	import citrus.core.starling.StarlingState;
	import org.osflash.signals.Signal;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Menu extends StarlingState
	{
		private var _maskDuringLoading:Quad;
		private var _startButton:Quad;
		private var touch:Touch;
		
		public var startGame:Signal;
		
		public function Menu() 
		{
			super();
			
			startGame = new Signal();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_maskDuringLoading = new Quad(stage.stageWidth, stage.stageHeight, 0xffff00);
			_maskDuringLoading.name = "phone";
			_maskDuringLoading.alpha = 0.3;
			addChild(_maskDuringLoading);
			
			_startButton = new Quad(200, 100, 0xff0000);
			_startButton.x = 0.5 * (stage.stageWidth - _startButton.width);
			_startButton.y = 200;
			_startButton.name = "start";			
			addChild(_startButton);			
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);			
		}
		
		private function onTouch(event:TouchEvent):void 
		{		
			touch = event.getTouch(stage);
			
			if (touch && touch.phase == TouchPhase.BEGAN)
			{
				if (touch.target.name == "start")
				{
					this.removeEventListener(TouchEvent.TOUCH, onTouch);	
					
					eaze(this).to(0.5, { alpha:0 } ).onComplete(function():void 
					{
						startGame.dispatch();
					});			
			
				}
				
				trace("touch", touch.target.name);
			}
		}
		
	}

}
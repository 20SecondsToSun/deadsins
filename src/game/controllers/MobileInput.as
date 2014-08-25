package game.controllers 
{

	import citrus.core.CitrusEngine;
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.input.Input;
	import org.osflash.signals.Signal;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;


	/**
	 * @author beartooth
	 */
	public class MobileInput extends Input {
		
		private var _screenTouched:Boolean = false;
		public var touch:Signal;

		public function MobileInput() {
			super();
			
			touch = new Signal(String);
		}
			
		override public function destroy():void {
			
			(_ce as StarlingCitrusEngine).starling.stage.removeEventListener(TouchEvent.TOUCH, _touchEvent);
			
			super.destroy();
		}

		override public function set enabled(value:Boolean):void {
			
			super.enabled = value;

			_ce = CitrusEngine.getInstance();

			if (enabled)
				(_ce as StarlingCitrusEngine).starling.stage.addEventListener(TouchEvent.TOUCH, _touchEvent);
			else
				(_ce as StarlingCitrusEngine).starling.stage.removeEventListener(TouchEvent.TOUCH, _touchEvent);
		}

		override public function initialize():void {
			
			super.initialize();

			_ce = CitrusEngine.getInstance();

			(_ce as StarlingCitrusEngine).starling.stage.addEventListener(TouchEvent.TOUCH, _touchEvent);
		}

		private function _touchEvent(tEvt:TouchEvent):void {
						
			var touchStart:Touch = tEvt.getTouch((_ce as StarlingCitrusEngine).starling.stage, TouchPhase.BEGAN);
			var touchEnd:Touch = tEvt.getTouch((_ce as StarlingCitrusEngine).starling.stage, TouchPhase.ENDED);
			var touchMoved:Touch = tEvt.getTouch((_ce as StarlingCitrusEngine).starling.stage, TouchPhase.MOVED);
			
			

			if (touchStart)
			{
				_screenTouched = true;
				touch.dispatch(TouchPhase.BEGAN);	
			}
			
			if (touchMoved)
			{
				_screenTouched = true;
				touch.dispatch(TouchPhase.MOVED);	
			}
			
			if (touchEnd)
			{
				_screenTouched = false;
				touch.dispatch(TouchPhase.ENDED);	
			}
				
				
			
			
				
				
				
		}

		public function get screenTouched():Boolean {
			return _screenTouched;
		}
	}
}

package game.controllers 
{
	import citrus.core.starling.StarlingState;
	import game.Menu;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class NavigationManager 
	{
		//private var menu:Menu;
		public var onLevelChanged:Signal;
		public var onStartGame:Signal;
		public var onMenuCall:Signal;
		
		private var currentIndex:int = 0;
		public var currentLevel:Object;
		
		private var _Level:Class;
		private var _Menu:Class;
		public var levels:Array;
		
		public function NavigationManager(_Level:Class, _Menu:Class ) 
		{			
			this._Level = _Level;
			this._Menu = _Menu;
			
			currentIndex = 0;
			
			onMenuCall = new Signal(_Menu);
			onLevelChanged = new Signal(_Level);
		}
		
		public function start():void
		{
			currentLevel = new _Menu();
			currentLevel.startGame.add(startGameHandler);
			onMenuCall.dispatch(currentLevel);				
		}
		
		private function startGameHandler():void 
		{
			if (currentLevel is _Menu)
			{
				currentLevel.startGame.remove(startGameHandler);
			}
			
			currentLevel = _Level(new levels[currentIndex]);
			currentLevel.lvlEnded.add(_onLevelEnded);
			onLevelChanged.dispatch(currentLevel);
			//currentLevel.lvlEnded.add(_onLevelEnded);
		}
		
		public function nextLevel():void {

			if (currentIndex < levels.length - 1) {
				++currentIndex;
			}

			gotoLevel();
		}

		public function prevLevel():void {

			if (currentIndex > 0) {
				--currentIndex;
			}

			gotoLevel();
		}
		
		
		public function gotoLevel():void 
		{
			if (currentLevel != null)
				currentLevel.lvlEnded.remove(_onLevelEnded);
				
			currentLevel = _Level(new levels[currentIndex]);
			currentLevel.lvlEnded.add(_onLevelEnded);
			onLevelChanged.dispatch(currentLevel);	
		}
		
		private function _onLevelEnded():void 
		{
			nextLevel();
			trace("LEVEL ENDED");
		}
		
	}

}
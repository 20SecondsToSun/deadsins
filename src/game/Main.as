package game {	
	
	import citrus.core.starling.StarlingCitrusEngine;
	import flash.display.Stage3D;
	import flash.geom.Rectangle;
	import game.levels.ALevel;
	import game.levels.Level1;
	import game.levels.Level2;
	import game.levels.Level3;
	import game.controllers.NavigationManager;
	import starling.core.Starling;


	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#ffffff")]
	
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine {
		
		private var navigation:NavigationManager;
		
		public function Main() {
			
			Starling.multitouchEnabled = false; // useful on mobile devices
            Starling.handleLostContext = false; // deactivate on mobile devices (to save memory)  	
			//gameData = new MyGameData();			
			setUpStarling(true);
		}
		
		override public function setUpStarling(debugMode:Boolean = false, antiAliasing:uint = 1, viewPort:Rectangle = null, stage3D:Stage3D = null):void {
			
			super.setUpStarling(debugMode, antiAliasing, viewPort, stage3D);		
			
			sound.addSound("Hurt", {sound:"sounds/hurt.mp3"});
			sound.addSound("Kill", { sound:"sounds/kill.mp3" } );
		
			navigation = new NavigationManager(ALevel, Menu);			
			navigation.levels = [Level1, Level2, Level3];
			navigation.onMenuCall.add(onMenuCallHandler);
			navigation.onLevelChanged.add(onLevelChangedHandler);
		}		
		
		override public function handleStarlingReady():void
		{	
			navigation.start();			
		}
		
		private function onLevelChangedHandler(lvl:ALevel):void 
		{
			state = lvl;			
		}
		
		private function onMenuCallHandler(menu:Menu):void 
		{
			state = menu;
		}
	}
}

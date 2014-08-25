package game.controllers 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author castor troy
	 */
	public class Logger extends Sprite
	{
		private var txtFormat:TextFormat;
		private var txt:TextField ;
		public function Logger() 
		{
			txtFormat = new TextFormat();
			txt = new TextField();
			txt.mouseEnabled = false;
			txt.autoSize = "left";
			
			txt.text = "_test";
			
			
			txtFormat.size = 50;
			txt.setTextFormat(txtFormat);			
	
			addChild(txt);
		}
		public function log(_msg:String):void
		{
			txt.text = _msg;
			txt.setTextFormat(txtFormat);		
		}
		
	}

}
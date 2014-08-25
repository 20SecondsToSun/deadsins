
package citrus.view {
	import citrus.view.ICitrusArt;
	public interface ICitrusArt 
	{
		
		function get updateArtEnabled():Boolean;
		function set updateArtEnabled(val:Boolean):void;
		function update(stateView:ACitrusView):void;
		
	}

}
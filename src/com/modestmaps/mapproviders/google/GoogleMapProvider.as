package com.modestmaps.mapproviders.google
{
	import com.modestmaps.core.Coordinate;
	import com.modestmaps.mapproviders.AbstractMapProvider;
	import com.modestmaps.mapproviders.IMapProvider;
	
	/**
	 * @author darren
	 * $Id$
	 */
	public class GoogleMapProvider 
		extends AbstractMapProvider
		implements IMapProvider
	{
	    public function GoogleMapProvider(minZoom:int=MIN_ZOOM, maxZoom:int=MAX_ZOOM)
        {
            super(minZoom, maxZoom);
        }
        
		public function toString():String
		{
			return "YAHOO_OVERLAY";
		}
		
		public function getTileUrls(coord:Coordinate):Array
		{
			//http://mt1.google.com/vt/lyrs=m@110&hl=pl&x=4574&y=2697&z=13
			return [ "http://mt1.google.com/vt/lyrs=m@110&hl=pl&lang=ru_RU" + getZoomString(sourceCoordinate(coord)) ];	
			//return [ "https://khms1.google.com/kh/v=134" + getZoomString(sourceCoordinate(coord)) ];	
				
	       // return [ "http://us.maps3.yimg.com/aerial.maps.yimg.com/img?md=200608221700&v=2.0&t=h" + getZoomString(sourceCoordinate(coord)) ];
		}
		
		private function getZoomString( coord:Coordinate ):String
		{		
	        var row:Number = ( Math.pow( 2, coord.zoom ) / 2 ) - coord.row - 1;
			//return "&x=1239&y=640&z=11";
			return "&x=" + coord.column + "&y=" + coord.row + "&z="+ coord.zoom;// + ( 15 - coord.zoom ); 
			//return "/" + coord.column + "/" + row + "/" + ( 18 - coord.zoom )+".png"; 
		}	
		
		/*private function getZoomString( coord:Coordinate ):String
		{		
	        var row:Number = ( Math.pow( 2, coord.zoom ) /2 ) - coord.row - 1;	
			return "&x=" + coord.column + "&y=" + row + "&z=" + ( 18 - coord.zoom ); 
		}	*/
	
	}
}
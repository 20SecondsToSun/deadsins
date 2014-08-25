package com.modestmaps.mapproviders.yandex
{
	import com.modestmaps.core.Coordinate;
	import com.modestmaps.mapproviders.AbstractMapProvider;
	import com.modestmaps.mapproviders.IMapProvider;
	
	/**
	 * @author darren
	 * $Id$
	 */
	public class YandexMapProvider extends AbstractMapProvider implements IMapProvider
	{
		public function YandexMapProvider(minZoom:int = MIN_ZOOM, maxZoom:int = MAX_ZOOM)
		{
			super(minZoom, maxZoom);
		}
		
		public function toString():String
		{
			return "YANDEX_OVERLAY";
		}
		
		public function getTileUrls(coord:Coordinate):Array
		{
			return ["http://vec03.maps.yandex.net/tiles?l=map&v=2.45.0&lang=ru_RU" + getZoomString(sourceCoordinate(coord))];
		}
		
		private function getZoomString(coord:Coordinate):String
		{
			return "&x=" + coord.column + "&y=" + coord.row + "&z=" + coord.zoom;
		}
	}
}
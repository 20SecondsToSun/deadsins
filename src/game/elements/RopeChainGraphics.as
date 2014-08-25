package game.elements {

	import Box2D.Dynamics.b2Body;
	import flash.display.BlendMode;
	import starling.display.graphicsEx.ShapeEx;
	import starling.display.Quad;

	import citrus.math.MathUtils;

	import starling.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author Aymeric
	 */
	public class RopeChainGraphics extends Sprite {

		private var _numChain:uint;
		private var _vecSprites:Vector.<Sprite>;
		private var _width:uint;
		private var _height:uint;
		
		private var rope:ShapeEx;

		public function RopeChainGraphics() {
			
			rope = new ShapeEx();
			//shape.blendMode = BlendMode.ADD;
			addChild(rope);
			rope.graphics.lineStyle(4);
			
			var controlPoints:Array = [new Point(0, 50), new Point(10, 100), new Point(0, 150), new Point(-10, 200)];
			
			
			rope.graphics.naturalCubicSplineTo(controlPoints, false, 100);
	
		}

		public function init(numChain:uint, width:uint, height:uint):void {

			_numChain = numChain;
			_width = width;
			_height = height;

			_vecSprites = new Vector.<Sprite>();
			var sprite:Sprite;

			for (var i:uint = 0; i < _numChain; ++i) {

				sprite = new Sprite();
				
				var fq:Quad = new Quad(_width, _height, 0xFFFFFF);
				sprite.addChild(fq);
				
				//addChild(sprite);
				_vecSprites.push(sprite);
			}
			trace("init");
		}
		public function update(vecBodyChain:Vector.<b2Body>, box2DScale:Number, last:b2Body):void 
		{
		

			var i:uint = 0;			
			var controlPoints:Array = [];
			//trace(" len ", vecBodyChain.length);
			
			for (var j:int = 0; j <vecBodyChain.length ; j++) 
			{
				var _x:Number = vecBodyChain[j].GetPosition().x * box2DScale - this.parent.x - _width * 0.5;
				var _y:Number = vecBodyChain[j].GetPosition().y * box2DScale - this.parent.y - _height * 0.5;
				//trace(_x, _y)
				
				controlPoints.push(new Point(_x, _y));
				
			}
			
			_x = last.GetPosition().x * box2DScale - this.parent.x - _width * 0.5;
			_y = last.GetPosition().y * box2DScale - this.parent.y - _height * 0.5;
			
			//controlPoints.push(new Point(_x, _y));
			
			
			rope.graphics.clear();
			rope.graphics.lineStyle(6, 0x592D00);			
			rope.graphics.naturalCubicSplineTo(controlPoints, false, 100);
			
			
		
		}
	}
}

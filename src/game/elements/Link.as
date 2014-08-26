package game.elements 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import citrus.objects.Box2DPhysicsObject;
	import flash.geom.Point;
	/**
	 * ...
	 * @author metalcorehero
	 */
	public class Link extends Box2DPhysicsObject
	{
		private var attach:Point;
		private var polygonShape:b2PolygonShape;
		private var chainLength:Number;
		
		public function Link(name:String, params:Object = null)
		{
			super(name, params);
			
			attach = params.position;
			chainLength = params.chainLength;
			super.addPhysics();
		}
		
		override protected function defineBody():void
		{
			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set(attach.x / _box2D.scale, attach.y/ _box2D.scale);
			_bodyDef.type = b2Body.b2_dynamicBody;
		}
		
		override protected function createBody():void
		{
			super.createBody();
		}
		
		override protected function createShape():void
		{
			polygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(2 / _box2D.scale, chainLength / _box2D.scale);
		}
		
		override protected function defineFixture():void
		{	
			_fixtureDef = new b2FixtureDef();
			_fixtureDef.density = 1;
			_fixtureDef.friction = 1;
			_fixtureDef.restitution = 0.0005;
			_fixtureDef.shape = polygonShape;			
		}
	
		
		override protected function defineJoint():void
		{
		
		}
		
	}

}
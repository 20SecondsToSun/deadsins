package game.elements
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class Cargo extends Box2DPhysicsObject
	{
		private var fixtureDefCargo:b2FixtureDef;
		private var _shapeCargo:b2CircleShape;
	
		public var onBeginContact:Signal;
		public var onEndContact:Signal;
		
		public function Cargo(name:String, params:Object = null)
		{
			_beginContactCallEnabled = true;
			_endContactCallEnabled = true;
			
			
			super(name, params);
			
			if(params.radius)
			_radius = params.radius;
			
			onBeginContact = new Signal(b2Contact);
			onEndContact = new Signal(b2Contact);		
		}	
		
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.type =  b2Body.b2_dynamicBody;	
		}
		
		
		override protected function defineFixture():void
		{	
			//super.defineFixture();
			_fixtureDef = new b2FixtureDef();
			_fixtureDef.shape = _shape;
		
			with (_fixtureDef) 
			{
				density = 1/70;
				friction = 1;
				restitution = 0.1;
				
				shape = _shape;
				filter.categoryBits = PhysicsCollisionCategories.Get("Level");
				filter.maskBits = PhysicsCollisionCategories.GetAll();						
			}		
		}			
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			onBeginContact.dispatch(contact);
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			onEndContact.dispatch(contact);
		}	
	}
}
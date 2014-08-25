package game.elements
{
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	
	/**
	 * @author beartooth
	 */
	public class RopeChain extends Box2DPhysicsObject
	{
		public var cargo:Box2DPhysicsObject;
		
		public var numChain:uint = 10;
		public var widthChain:uint = 8;
		public var heightChain:uint = 35;
		public var attach:Point = new Point(275, 0);
		//public var distance:uint = 15;
		
		public var onBeginContact:Signal;
		public var onEndContact:Signal;
		private var mainJoint:b2Joint;
		
		private var links:Number = 10; // Math.floor(Math.random() * 10) + 2;            
		private var chainLength:Number = 130 / links;
		
		private var bodyDefCeil:b2BodyDef;
		private var bodyDefCargo:b2BodyDef;
		private var _vecBodyDefChain:Vector.<b2BodyDef>;
		
		private var _bodyCeil:b2Body;
		private var _bodyCargo:b2Body;
		private var _vecBodyChain:Vector.<b2Body>;
		
		private var _shapeChain:b2PolygonShape;
		private var _shapeCeil:b2PolygonShape;
		private var _shapeCargo:b2PolygonShape;
		
		private var fixtureDefChain:b2FixtureDef;
		private var fixtureDefCargo:b2FixtureDef;
		private var fixtureDefCeil:b2FixtureDef;
		
		private var cargoJoint:b2Joint;
		private var _vecRevoluteJointDef:Vector.<b2RevoluteJointDef>;
		
		private var steelBall:b2Body;
		
		public function RopeChain(name:String, params:Object = null)
		{
			updateCallEnabled = true;
			_beginContactCallEnabled = true;
			_endContactCallEnabled = true;
			
			onBeginContact = new Signal(b2Contact);
			onEndContact = new Signal(b2Contact);
			
			if (params.x)
				attach = new Point(params.x, params.y);
			//hangTo = params.hangTo;
			
			if (params.cargo)
				cargo = params.cargo;
			
			if (params.view)
			{
				view = params.view;
					//(view as RopeChainGraphics).init(links, widthChain, heightChain);			
			}
			
			super(name, params);
			
			create();
		}
		
		public function create():void
		{
			// number of links forming the rope
			var links:Number = 10;// Math.floor(Math.random() * 10) + 2;
			// according to the number of links, I am setting the length of a single chain piace
			var chainLength:Number = 180 / links;
			// creation of a new world
			
			// ceiling polygon shape
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			
			var worldScale:Number = _box2D.scale;
			
			var world:b2World = _box2D.world;
			
			polygonShape.SetAsBox(320 / worldScale, 10 / worldScale);
			// ceiling fixture;
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1000;
			fixtureDef.friction = 1;
			fixtureDef.restitution = 0.5;
			fixtureDef.shape = polygonShape;
			// ceiling body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(320 / worldScale, 0);
			// ceiling creation;
			var wall:b2Body = world.CreateBody(bodyDef);
			wall.CreateFixture(fixtureDef);
			// link polygon shape
			polygonShape.SetAsBox(2 / worldScale, chainLength / worldScale);
			// link fixture;
			fixtureDef.density = 1;
			fixtureDef.shape = polygonShape;
			// link body
			bodyDef.type = b2Body.b2_dynamicBody;
			// link creation
			for (var i:Number = 0; i <= links; i++)
			{
				bodyDef.position.Set(320 / worldScale, (chainLength + 2 * chainLength * i) / worldScale);
				if (i == 0)
				{
					var link:b2Body = world.CreateBody(bodyDef);
					link.CreateFixture(fixtureDef);
					revoluteJoint(wall, link, new b2Vec2(0, 0), new b2Vec2(0, -chainLength / worldScale));
				}
				else
				{
					var newLink:b2Body = world.CreateBody(bodyDef);
					newLink.CreateFixture(fixtureDef);
					revoluteJoint(link, newLink, new b2Vec2(0, chainLength / worldScale), new b2Vec2(0, -chainLength / worldScale));
					link = newLink;
				}
			}
			// attaching the ball at the end of the rope
			var circleShape:b2CircleShape = new b2CircleShape(3);
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1/70;
			steelBall = world.CreateBody(bodyDef);
			steelBall.CreateFixture(fixtureDef);
			revoluteJoint(link, steelBall, new b2Vec2(0, chainLength / worldScale), new b2Vec2(0, 0));
		
		}
		
		private function revoluteJoint(bodyA:b2Body, bodyB:b2Body, anchorA:b2Vec2, anchorB:b2Vec2):b2Joint
		{
			var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			revoluteJointDef.localAnchorA.Set(anchorA.x, anchorA.y);
			revoluteJointDef.localAnchorB.Set(anchorB.x, anchorB.y);
			revoluteJointDef.bodyA = bodyA;
			revoluteJointDef.bodyB = bodyB;
			return _box2D.world.CreateJoint(revoluteJointDef);
		}
	
	
	   override public function addPhysics():void
	   {
	   super.addPhysics();
	   }
	   
	   
	   public function impulse():void
	   {
			//cargo.body.ApplyImpulse(new b2Vec2(-5 + Math.random() * 10, -15), cargo.body.GetWorldCenter());
			steelBall.ApplyImpulse(new b2Vec2(-5 + Math.random() * 10, -15), steelBall.GetWorldCenter());
	   }
	   
	   
	/*
	   override public function update(timeDelta:Number):void
	   {
	   super.update(timeDelta);
	
	   //if (view)
	   //	(view as RopeChainGraphics).update(_vecBodyChain, _box2D.scale);
	
	   }
	
	   override protected function defineBody():void
	   {
	   // ceiling body
	   bodyDefCeil = new b2BodyDef();
	   bodyDefCeil.position.Set(attach.x / _box2D.scale, 0);
	   bodyDefCeil.type = b2Body.b2_staticBody;
	
	   // chain
	   _vecBodyDefChain = new Vector.<b2BodyDef>();
	   var bodyDefChain:b2BodyDef;
	   for (var i:uint = 0; i < links; ++i)
	   {
	   bodyDefChain = new b2BodyDef();
	   bodyDefChain.type = b2Body.b2_dynamicBody;
	   bodyDefChain.position.Set(attach.x / _box2D.scale, (chainLength + 2* chainLength * i) / _box2D.scale);
	   //bodyDefChain.angle = _rotation;
	   _vecBodyDefChain.push(bodyDefChain);
	   }
	
	   bodyDefCargo = new b2BodyDef();
	   bodyDefCargo.position.Set(attach.x / _box2D.scale,(chainLength + 2 * chainLength * (links - 1)) / _box2D.scale);
	   bodyDefCargo.type = b2Body.b2_dynamicBody;
	
	   //cargo.body.SetPosition(new b2Vec2(attach.x / _box2D.scale, (chainLength + 2* chainLength * (links-1)) / _box2D.scale));
	   }
	
	   override protected function createBody():void
	   {
	   _bodyCeil = _box2D.world.CreateBody(bodyDefCeil);
	
	   _vecBodyChain = new Vector.<b2Body>();
	   for each (var bodyDefChain:b2BodyDef in _vecBodyDefChain)
	   {
	   var bodyChain:b2Body = _box2D.world.CreateBody(bodyDefChain);
	   _vecBodyChain.push(bodyChain);
	   }
	
	   _bodyCargo = _box2D.world.CreateBody(bodyDefCargo);
	   }
	
	   override protected function createShape():void
	   {
	   _shapeChain = new b2PolygonShape();
	   b2PolygonShape(_shapeChain).SetAsBox(widthChain / _box2D.scale, chainLength / _box2D.scale);
	
	   _shapeCeil = new b2PolygonShape();
	   b2PolygonShape(_shapeCeil).SetAsBox(0, heightChain / _box2D.scale);
	
	   _shapeCargo = new b2PolygonShape();
	   b2PolygonShape(_shapeCargo).SetAsBox(50/ _box2D.scale, 50 / _box2D.scale);
	   }
	
	   override protected function defineFixture():void
	   {
	   fixtureDefChain = new b2FixtureDef();
	   with (fixtureDefChain)
	   {
	   density = 1;
	   friction = 1;
	   restitution = 0.5;
	   shape = _shapeChain;
	   filter.categoryBits = PhysicsCollisionCategories.Get("Level");
	   filter.maskBits = PhysicsCollisionCategories.GetAll();
	   density = 1;
	   }
	
	   fixtureDefCeil = new b2FixtureDef();
	   with (fixtureDefCeil)
	   {
	   density = 1;
	   friction = 1;
	   restitution = 0.5;
	   shape = _shapeCeil;
	   filter.categoryBits = PhysicsCollisionCategories.Get("Level");
	   filter.maskBits = PhysicsCollisionCategories.GetAll();
	   density = 1;
	   }
	
	   fixtureDefCargo= new b2FixtureDef();
	   with (fixtureDefCargo)
	   {
	   density = 1;
	   friction = 1;
	   restitution = 0.5;
	   shape = _shapeCargo;
	   filter.categoryBits = PhysicsCollisionCategories.Get("Level");
	   filter.maskBits = PhysicsCollisionCategories.GetAll();
	   density = 1;
	   }
	
	
	   }
	
	   override protected function createFixture():void
	   {
	   for (var j:int = 0; j < _vecBodyChain.length; j++)
	   _vecBodyChain[j].CreateFixture(fixtureDefChain);
	
	   _bodyCeil.CreateFixture(fixtureDefCeil);
	
	   _bodyCargo.CreateFixture(fixtureDefCargo);
	
	   }
	
	   override protected function defineJoint():void
	   {
	   revoluteJoint(_bodyCeil, _vecBodyChain[0], new b2Vec2(0, 0), new b2Vec2(0, -chainLength / _box2D.scale));
	
	   for (var i:int = 1; i < links; i++)
	   revoluteJoint(_vecBodyChain[i - 1], _vecBodyChain[i], new b2Vec2(0, chainLength / _box2D.scale), new b2Vec2(0, -chainLength / _box2D.scale));
	
	   cargoJoint = revoluteJoint(_vecBodyChain[links - 1], _bodyCargo, new b2Vec2(0, chainLength / _box2D.scale), new b2Vec2(0, 0));
	
	   }
	
	
	
	   public function sliceRope():void
	   {
	   //_box2D.world.DestroyJoint(cargoJoint);
	   impulse();
	   }
	
	   public function impulse():void
	   {
	   cargo.body.ApplyImpulse(new b2Vec2(-5 + Math.random() * 10, -15), cargo.body.GetWorldCenter());
	   }
	
	   override public function handleBeginContact(contact:b2Contact):void
	   {
	   onBeginContact.dispatch(contact);
	   }
	
	   override public function handleEndContact(contact:b2Contact):void
	   {
	   onEndContact.dispatch(contact);
	   }
	 */
	}
}

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
		
		private var links:Number = 10;
		private var allLength:Number;
		
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
				(view as RopeChainGraphics).init(links, widthChain, heightChain);			
			}
			if (params.links)			
				links = params.links;
				
			if (params.allLength)			
				allLength = params.allLength;
				
			
			super(name, params);
		
			create();
		}
		
		public function create():void
		{
			_vecBodyChain = new Vector.<b2Body>();
			// number of links forming the rope
			 // Math.floor(Math.random() * 10) + 2;
			// according to the number of links, I am setting the length of a single chain piace
			var chainLength:Number = allLength / links;
			// creation of a new world
			
			// ceiling polygon shape
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			
			var worldScale:Number = _box2D.scale;
			
			var world:b2World = _box2D.world;
			
			polygonShape.SetAsBox(10 / worldScale, 10 / worldScale);
			// ceiling fixture;
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 100000;
			fixtureDef.friction = 1;
			fixtureDef.restitution = 0.0005;
			fixtureDef.shape = polygonShape;
			// ceiling body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(attach.x / worldScale, -10/ worldScale);
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
			
			
			
			bodyDef.position.Set(320 / worldScale, chainLength  / worldScale);
			
			
			
			/*
			var link:b2Body = world.CreateBody(bodyDef);
		
			_vecBodyChain.push(link);
			link.CreateFixture(fixtureDef);
			
			revoluteJoint(wall, link, new b2Vec2(0, 0), new b2Vec2(0, -chainLength / worldScale));*/
			
			var __link:Link = new Link("link", { position:new Point(attach.x, -10), chainLength:chainLength } );
			
			
				
			var link:b2Body = __link.body;
			_vecBodyChain.push(link);
			revoluteJoint(wall, link, new b2Vec2(0, 0), new b2Vec2(0, -chainLength / worldScale));
			
			

			for (var i:Number = 0; i <= links; i++)
			{
				//bodyDef.position.Set(attach.x / worldScale, (chainLength + 2 * chainLength * i) / worldScale);
				
				//var newLink:b2Body = world.CreateBody(bodyDef);
				//_vecBodyChain.push(newLink);				
				//newLink.CreateFixture(fixtureDef);
				var __newLink:Link = new Link("link", { position:new Point(attach.x, chainLength + 2 * chainLength * i), chainLength:chainLength } );
				var newLink:b2Body = __newLink.body;
				_vecBodyChain.push(newLink);					
				revoluteJoint(link, newLink, new b2Vec2(0, chainLength / worldScale), new b2Vec2(0, -chainLength / worldScale));
				link = newLink;				
			}	
			cargo.body.SetPosition(new b2Vec2(attach.x / worldScale, (chainLength + 2 * chainLength * links ) / worldScale));			
			cargoJoint = revoluteJoint(link, cargo.body, new b2Vec2(0, (chainLength) / worldScale), new b2Vec2(0, 0));
		
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
			//cargo.body.ApplyImpulse(new b2Vec2(0, 0), cargo.body.GetWorldCenter());
			//cargo.body.ApplyImpulse(new b2Vec2(-1 + Math.random() * 10, -2), cargo.body.GetWorldCenter());
			//steelBall.ApplyImpulse(new b2Vec2(-5 + Math.random() * 10, -15), steelBall.GetWorldCenter());
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (view)
				(view as RopeChainGraphics).update(_vecBodyChain, _box2D.scale, cargo.body);
		
		}
		
		override protected function defineBody():void
		{
		
		}
		
		override protected function createBody():void
		{
		}
		
		override protected function createShape():void
		{
		}
		
		override protected function defineFixture():void
		{		
		}
		
		override protected function createFixture():void
		{
		
		}
		
		override protected function defineJoint():void
		{
		
		}
		
		public function sliceRope():void
		{
			_box2D.world.DestroyJoint(cargoJoint);
			//impulse();
		}
		
		
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			onBeginContact.dispatch(contact);
		}
		
		override public function handleEndContact(contact:b2Contact):void
		{
			onEndContact.dispatch(contact);
		}
		
		override public function destroy():void
		{
			//_box2D.world.DestroyBody(_body);
			trace("name---------------",name);
			//REMOVE ALL LINKS!!!!!!");
			//super.destroy();
		}
	}
}

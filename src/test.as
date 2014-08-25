package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	public class test extends Sprite {
		private var worldScale:Number=30;
		private var world:b2World;
		// this is the ball which I'll join at the end of the chain/rope
		private var steelBall:b2Body;
		public function test() {
			// number of links forming the rope
			var links:Number = 15;// Math.floor(Math.random() * 10) + 2;
			// according to the number of links, I am setting the length of a single chain piace
			var chainLength:Number=180/links;
			// creation of a new world
			world=new b2World(new b2Vec2(0,10),true);
			debugDraw();
			// ceiling polygon shape
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(320/worldScale,10/worldScale);
			// ceiling fixture;
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density=1;
			fixtureDef.friction=1;
			fixtureDef.restitution=0.5;
			fixtureDef.shape=polygonShape;
			// ceiling body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(320/worldScale,0);
			// ceiling creation;
			var wall:b2Body=world.CreateBody(bodyDef);
			wall.CreateFixture(fixtureDef);
			// link polygon shape
			polygonShape.SetAsBox(2/worldScale,chainLength/worldScale);
			// link fixture;
			fixtureDef.density=1;
			fixtureDef.shape=polygonShape;
			// link body
			bodyDef.type=b2Body.b2_dynamicBody;
			// link creation
			for (var i:Number=0; i<=links; i++) {
				bodyDef.position.Set(320/worldScale,(chainLength+2*chainLength*i)/worldScale);
				if (i==0) {
					var link:b2Body=world.CreateBody(bodyDef);
					link.CreateFixture(fixtureDef);
					revoluteJoint(wall,link,new b2Vec2(0,0),new b2Vec2(0,-chainLength/worldScale));
				}
				else {
					var newLink:b2Body=world.CreateBody(bodyDef);
					newLink.CreateFixture(fixtureDef);
					revoluteJoint(link,newLink,new b2Vec2(0,chainLength/worldScale),new b2Vec2(0,-chainLength/worldScale));
					link=newLink;
				}
			}
			// attaching the ball at the end of the rope
			var circleShape:b2CircleShape = new b2CircleShape(1);
			fixtureDef.density=1/10;
			fixtureDef.shape=circleShape;
			steelBall=world.CreateBody(bodyDef);
			steelBall.CreateFixture(fixtureDef);
			revoluteJoint(link,steelBall,new b2Vec2(0,chainLength/worldScale),new b2Vec2(0,0));
			addEventListener(Event.ENTER_FRAME,update);
			stage.addEventListener(MouseEvent.CLICK,sphereImpulse);
		}
		// this is the core of the script: despite the official docs which suggest to use Initialize,
		// use this method instead
		private function revoluteJoint(bodyA:b2Body,bodyB:b2Body,anchorA:b2Vec2,anchorB:b2Vec2):void {
			var revoluteJointDef:b2RevoluteJointDef=new b2RevoluteJointDef();
			revoluteJointDef.localAnchorA.Set(anchorA.x,anchorA.y);
			revoluteJointDef.localAnchorB.Set(anchorB.x,anchorB.y);
			revoluteJointDef.bodyA=bodyA;
			revoluteJointDef.bodyB=bodyB;
			world.CreateJoint(revoluteJointDef);
		}
		private function debugDraw():void {
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		private function sphereImpulse(e:MouseEvent):void {
			// just apply an impulse to the sphere
			steelBall.ApplyImpulse(new b2Vec2(-50+Math.random()*100,-150),steelBall.GetWorldCenter());
		}
		private function update(e:Event):void {
			world.Step(1/30,10,10);
			world.ClearForces();
			world.DrawDebugData();
		}
	}
}
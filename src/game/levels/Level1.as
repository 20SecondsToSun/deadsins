package game.levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.view.starlingview.AnimationSequence;
	import game.elements.RopeChain;
	import game.elements.RopeChainGraphics;
	import game.heroes.Zombie;
	import game.levels.ALevel;
	import starling.display.Quad;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import game.elements.Cargo;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class Level1 extends ALevel
	{
		private var zombie:Zombie;
		private var ropeChain:RopeChain;
		private var cargo:Cargo;
		
		public function Level1()
		{
			super();
		}
		
		override protected function inititalizeLevel():void
		{
			var bg:CitrusSprite = new CitrusSprite("bg", {x: 0, y: 0, width: 320, height: 480});
			bg.view = assets.getTexture("BgLayer1");
			add(bg);
			
			for (var i:int = 0; i < 21; i++)
			{
				var tileTex:Texture = assets.getTexture("stone_tile");
				var tile:CitrusSprite = new CitrusSprite("bg", {x: tileTex.width * i, y: stage.stageHeight - tileTex.height});
				tile.view = tileTex;
				tile.width = tileTex.width * 0.5;
				add(tile);
			}
			
			add(new Platform("left", {x: 0 - 20, y: stage.stageHeight * 0.5, height: stage.stageHeight, width: 20}));
			add(new Platform("right", {x: stage.stageWidth + 20, y: stage.stageHeight * 0.5, height: stage.stageHeight, width: 20}));
			add(new Platform("bottom", {x: stage.stageWidth * 0.5, y: stage.stageHeight - tileTex.height * 0.5, width: stage.stageWidth, height: tileTex.height}));
			
			zombie = new Zombie("hero", {x: stage.stageWidth * 0.5, y: stage.stageHeight - 135, width: 60, height: 135});
			zombie.view = new AnimationSequence(assets.getTextureAtlas("Hero"), ["walk", "die", "duck", "idle", "jump", "hurt"], "idle");
			zombie.setAnimState("idle");
			add(zombie);
			
			cargo = new Cargo("cargo", {x: stage.stageWidth * 0.5 - 200, y: 250, radius: 2.5, view: assets.getTexture("shar")})
			cargo.touchable = true;
			//cargo.view = fq;			
			cargo.onBeginContact.add(collisionDetectHandler);
			//cargo.body.SetType(2);	
			add(cargo);
			
			//var gr:RopeChainGraphics = new RopeChainGraphics();
			
			var ropeGraphics:RopeChainGraphics = new RopeChainGraphics();
			ropeChain = new RopeChain("ropeChain", {y: 10, x: stage.stageWidth * 0.5, registration: "topLeft", cargo: cargo, view: ropeGraphics, links: 10, allLength: 120});
			ropeChain.touchable = true;
			ropeChain.onBeginContact.add(contactHandler);
			add(ropeChain);
		
		}
		
		private function contactHandler(contact:b2Contact):void
		{
			trace("contact", contact.GetFixtureA().GetBody());
		}
		
		override protected function onTouchHandler(event:TouchEvent):void
		{
			super.onTouchHandler(event);
			
			if (!touch)
				return;
			
			if (ropeChain && touch.phase == TouchPhase.BEGAN)
				ropeChain.impulse();
				
			if (touch.phase == TouchPhase.MOVED)
			{
				var __scaleBox2d:Number = box2D.scale;
				var vec1:b2Vec2 = new b2Vec2(touchPoint1.x / __scaleBox2d, touchPoint1.y / __scaleBox2d);
				var vec2:b2Vec2 = new b2Vec2(touchPoint2.x / __scaleBox2d, touchPoint2.y / __scaleBox2d);
				
				box2D.world.RayCast(intersection, vec1, vec2);
			}
		}
		
		private function intersection(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):void
		{
			var body:b2Body = fixture.GetBody();
			
			if (body.GetUserData().name && body.GetUserData().name == "link")			
				ropeChain.sliceRope();			
		}
		private var kill:Boolean = false;
		private function collisionDetectHandler(contact:b2Contact):void
		{
			var maybeZombie:* = Box2DUtils.CollisionGetOther(RopeChain(getObjectByName("ropeChain")), contact);
			
			if (maybeZombie is Zombie && !kill)
			{
				
				_ce.sound.playSound("Kill");				
				zombie.setAnimState("die");					
		
				kill = true;

			}
		}
		override public function update(timeDelta:Number):void
		{
			if (kill) zombie.body.SetActive(false);

			_realState.update(timeDelta);			
		}
	
	}
}
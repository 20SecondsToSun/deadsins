package game.levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.view.starlingview.AnimationSequence;
	import flash.geom.Point;

	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	
	import game.elements.Cargo;
	import game.elements.RopeChain;
	import game.elements.RopeChainGraphics;
	import game.heroes.Zombie;
	import game.levels.ALevel;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class Level2 extends ALevel
	{
		private var zombie:Zombie;
		private var ropeChain:RopeChain;
		private var cargo:Cargo;
		
		public function Level2()
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
			zombie.setAnimState("walk");
			add(zombie);
			
			cargo = new Cargo("cargo", {x: stage.stageWidth * 0.5 - 200, y: 250, radius: 2.5, view: assets.getTexture("shar")})
			cargo.touchable = true;
			cargo.onBeginContact.add(collisionDetectHandler);
			add(cargo);
			
			var ropeGraphics:RopeChainGraphics = new RopeChainGraphics();
			ropeChain = new RopeChain("ropeChain", {y: 10, x: stage.stageWidth * 0.5, registration: "topLeft", cargo: cargo, view: ropeGraphics, links: 10, allLength: 120});
			ropeChain.touchable = true;
			add(ropeChain);
		}
		
		override public function intersection(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):void
		{
			var body:b2Body = fixture.GetBody();
			
			if (body.GetUserData().name && body.GetUserData().name == "link")
				ropeChain.sliceRope();
		}
		
		private function collisionDetectHandler(contact:b2Contact):void
		{
			var maybeZombie:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(Cargo(getObjectByName("cargo")), contact);
			
			if (maybeZombie is Zombie && (maybeZombie as Zombie).needToKill == false)
			{
				var normalPoint:Point = new Point(contact.GetManifold().m_localPoint.x, contact.GetManifold().m_localPoint.y);
				var collisionAngle:Number = new MathVector(normalPoint.x, normalPoint.y).angle * 180 / Math.PI;
				//if (collisionAngle > 0)				
				{
					_ce.sound.playSound("Kill");
					(maybeZombie as Zombie).setAnimState("die");
					(maybeZombie as Zombie).needToKill = true;
					killedZombieVector.push(maybeZombie as Zombie);
				}
			}			
			//trace("---------------------------->  ",maybeZombie)
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			checkForKilledZombieToSetInactive();
			
			checkForEndLevel();
		}
		
		private function checkForKilledZombieToSetInactive():void
		{
			for (var i:int = 0; i < killedZombieVector.length; i++)
			{
				if (killedZombieVector[i].needToKill)
				{
					killedZombieVector[i].body.SetActive(false);
					killedZombieVector.splice(i, 1);
					_deathCount++;
				}
			}
		}
		
		private function checkForEndLevel():void
		{
			if (_deathCount >= _deathToFinish)
				nextlevel();
		}
	
	}

}
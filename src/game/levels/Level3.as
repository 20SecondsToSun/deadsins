package game.levels
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import flash.geom.Point;
	import game.elements.TempBlock;
	import starling.display.DisplayObject;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import game.elements.Cargo;
	import game.elements.RopeChain;
	import game.elements.RopeChainGraphics;
	import game.heroes.Zombie;
	import game.levels.ALevel;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.view.starlingview.AnimationSequence;
	
	/**
	 * ...
	 * @author castor troy
	 */
	public class Level3 extends ALevel
	{
		private var cargo:Cargo;
		private var zombie:Zombie;
		private var ropeChain:RopeChain;
		
		private var tempBlocksVec:Vector.<TempBlock> = new Vector.<TempBlock>();
		private var zombie1:Zombie;
		
		public function Level3()
		{
			
			super();
			_deathToFinish = 2;
		}
		
		override protected function inititalizeLevel():void
		{
			var bg:CitrusSprite = new CitrusSprite("bg", {x: 0, y: 0, width: 320, height: 480});
			bg.view = assets.getTexture("BgLayer1");
			add(bg);
			
				
			for (var i:int = 0; i < 21; i++)
			{
				var tileTex:Texture = assets.getTexture("stone_tile");
				var tile:CitrusSprite = new CitrusSprite("bg", {x: tileTex.width * i, y: stage.stageHeight - tileTex.height*0.5});
				tile.view = tileTex;
				tile.width = tileTex.width * 0.5;				
				add(tile);
			}
			
			
			for ( i = 0; i < 8; i++)
			{
				tileTex = assets.getTexture("stone_tile");
				tile = new CitrusSprite("bg", {x: tileTex.width * i, y: stage.stageHeight - tileTex.height*1.5});
				tile.view = tileTex;
				tile.width = tileTex.width * 0.5;				
				add(tile);
			}
			for (i = 0; i < 8; i++)
			{
				tileTex = assets.getTexture("stone_tile");
				tile = new CitrusSprite("bg", {x: tileTex.width * i + 12.5*tileTex.width, y: stage.stageHeight - tileTex.height*1.5});
				tile.view = tileTex;
				tile.width = tileTex.width * 0.5;				
				add(tile);
			}
			
			
			add(new Platform("left", {x: 0 - 20, y: stage.stageHeight * 0.5, height: stage.stageHeight, width: 20}));
			add(new Platform("right", {x: stage.stageWidth + 20, y: stage.stageHeight * 0.5, height: stage.stageHeight, width: 20}));
			
			add(new Platform("bottom1", { x: stage.stageWidth * 0.5, y: stage.stageHeight, width: stage.stageWidth, height: tileTex.height } ));
			var __width:Number = tileTex.width * 8;
			add(new Platform("bottom2", { x:__width * 0.5, y: stage.stageHeight - tileTex.height , width:  __width, height: tileTex.height } ));
			add(new Platform("bottom3", { x:stage.stageWidth - __width * 0.5, y: stage.stageHeight - tileTex.height , width:  __width, height: tileTex.height } ));
			
			var __width2:Number = stage.stageWidth - 2 * tileTex.width * 8 - 2;
			//add(new Platform("bottom4", { x: __width+__width2*0.5+1 , y: stage.stageHeight - tileTex.height , width:  __width2, height: tileTex.height } ));
			
			var tempBlock:TempBlock = new TempBlock("temp",  { view: assets.getTexture("stone_wide") } );
			tempBlock.touchable = true;
			tempBlock.width = __width2;
			tempBlock.height = tileTex.height;
			tempBlock.x = __width + __width2 * 0.5 + 1;
			tempBlock.y = stage.stageHeight - tempBlock.height - 20;
			tempBlocksVec.push(tempBlock);
			add(tempBlock);
			
			
			
			
			zombie = new Zombie("hero", {x: 10, y: stage.stageHeight - 135, width: 60, height: 135});
			zombie.view = new AnimationSequence(assets.getTextureAtlas("Hero"), ["walk", "die", "duck", "idle", "jump", "hurt"], "idle");
			zombie.setAnimState("walk");
			add(zombie);
			
			zombie1 = new Zombie("hero1", {x: 900, y: stage.stageHeight - 135, width: 60, height: 135});
			zombie1.view = new AnimationSequence(assets.getTextureAtlas("Hero"), ["walk", "die", "duck", "idle", "jump", "hurt"], "idle");
			zombie1.setAnimState("walk");
			zombie1.turnAround();
			add(zombie1);
			
			
			cargo = new Cargo("cargo", {x: stage.stageWidth * 0.5 - 200, y: 250, width:__width2, height:tileTex.height+50, view: assets.getTexture("stone_TEMP")})
			cargo.touchable = true;
			cargo.onBeginContact.add(collisionDetectHandler);
			add(cargo);
			
			var ropeGraphics:RopeChainGraphics = new RopeChainGraphics();
			ropeChain = new RopeChain("ropeChain", {y: 10, x: stage.stageWidth * 0.5, registration: "topLeft", cargo: cargo, view: ropeGraphics, links: 10, allLength: 120});
			ropeChain.touchable = true;
			add(ropeChain);
		}
		
		override protected function onTouchHandler(event:TouchEvent):void 
		{
			super.onTouchHandler(event);			
			
			checkRemovableBlocks(event);
		}
		
		private function checkRemovableBlocks(event:TouchEvent):void 
		{
			if(touch && touch.phase == TouchPhase.BEGAN)
			{
				var art:DisplayObject = (event.target as DisplayObject).parent;
				if (art && view.getObjectFromArt(art) is TempBlock)
				{
					(view.getObjectFromArt(art) as TempBlock).kill = true;
				}		
			}
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
				if (collisionAngle>0)
				{	_ce.sound.playSound("Kill");
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
					//trace("------------------_deathCount---------->  ",_deathCount)
				}
			}
		}
		
		private function checkForEndLevel():void 
		{
			if (_deathCount >= _deathToFinish)
				nextlevel();
				
			//trace("------------------_deathToFinish---------->  ",_deathToFinish)
		}
		
		
	
	}

}
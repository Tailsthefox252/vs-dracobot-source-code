package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	// var notWeek6:Bool;
	var box:FlxSprite;

	var PlsDestroy:FlxTypedGroup<Dynamic> = new FlxTypedGroup<Dynamic>();

	// Funny monkey movie and garfeldi
	var curCharacter:String = '';
	var curEmotion:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var dialogueLine:Int;

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var spiritPortrait:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitMid:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	// var blackScreen:FlxSprite; //J: can't just blank out the screen lol
	var whiteScreen:FlxSprite;

	var pauseInput:Bool = false;
	var curSong:Int = 1;
	var hasDialog = false;

	var spiritSpoke = false;
	var dracoGlitch = false;
	var iconP2:HealthIcon;
	var SkipText = new FlxSprite(FlxG.width * 0.85, FlxG.height * 0.035);
	var SkipTextHighlight = new FlxSprite(FlxG.width * 0.85, FlxG.height * 0.035);
	var TheBottomFuck = 0;
	//var TattletailHorny:FlxRect = new FlxRect(SkipTextHighlight.x, SkipTextHighlight.y, SkipTextHighlight.width, SkipTextHighlight.height);

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		SkipText.frames = Paths.getSparrowAtlas('funny monkey movie');
		SkipTextHighlight.frames = Paths.getSparrowAtlas('woa cool');
		//SkipTextHighlight.clipRect = TattletailHorny;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'power on':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				curSong = 1;
				trace("J: shit might be funky here");
			case 'scan':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				curSong = 2;
				trace("J: shit might be funky here");
			case 'error 404':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				curSong = 3;
				trace("J: shit might be funky here");
			case 'solder':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				curSong = 4;
				trace("J: shit might be funky here");
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		// J: FlxSprite(x, y).makeGraphic(Std.int(window width * 1.3), Std.int(window height * 1.3), hex code);
		// J: therefore, a just black screen should be:
		// blackScreen = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 1.5), Std.int(FlxG.height* 1.5), 0xFF000000);
		// J: should be in the exact center when loaded, then made larger extending beyond the camera, and black
		whiteScreen = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 1.5), Std.int(FlxG.height * 1.5), 0xFFFFFFFF);
		whiteScreen.scrollFactor.set();
		whiteScreen.alpha = 1;
		whiteScreen.visible = false;
		add(whiteScreen);
		add(SkipText);
		add(SkipTextHighlight);

		// blackScreen.alpha = 1;
		// add(blackScreen);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		if (StoryMenuState.curWeek == 6)
		{
			new FlxTimer().start(0.83, function(tmr:FlxTimer)
			{
				bgFade.alpha += (1 / 5) * 0.7;
				if (bgFade.alpha > 0.7)
					bgFade.alpha = 0.7;
			}, 5);
		}

		box = new FlxSprite(-20, 45);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				curSong = 0;
				hasDialog = true;
				trace("J: has dialogue but being funky with week dia so working on this now");
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				curSong = 0;
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad'); // J: note: THIS DIALOGUE BOX MATTERS!!!!! THIS HAS THE SENPAI THAT IS REALLY MAD AND SHIZ
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24,
					false); // J: AND WILL NOT GO AWAY IF YOU DO PORTRAITLEFT.VISIBLE = FALSE
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				curSong = 0; // J: all set to 0 so week 7's shiz doesn't mess with week 6
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

			case 'power on':
				hasDialog = true;
				// trace("we have dialogue :]");

				// box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel', 'week6');
				// box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				// box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

				box.loadGraphic(Paths.image('agg'));
			case 'scan':
				hasDialog = true;
				// trace("we have dialogue :]");

				// box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel', 'week6');
				// box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				// box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

				box.loadGraphic(Paths.image('agg'));
			case 'error 404':
				hasDialog = true;
				// trace("we have dialogue :]");

				// box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel', 'week6');
				// box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				// box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

				box.loadGraphic(Paths.image('agg'));
			case 'solder':
				hasDialog = true;
				// trace("we have dialogue :]");

				// box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel', 'week6');
				// box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				// box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

				box.loadGraphic(Paths.image('agg'));
		}

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;

		if (StoryMenuState.curWeek == 6)
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait', 'week6');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;

			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait', 'week6');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;

			box.animation.play('normalOpen');
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			box.updateHitbox();
			add(box);

			box.screenCenter(X);
			portraitLeft.screenCenter(X);

			handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox', 'week6'));
			add(handSelect);

			if (!talkingRight)
			{
				// box.flipX = true;
			}

			dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
			dropText.font = 'Pixel Arial 11 Bold';
			dropText.color = 0xFFD89494;
			add(dropText);

			swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
			swagDialogue.font = 'Pixel Arial 11 Bold';
			swagDialogue.color = 0xFF3F2021;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
			add(swagDialogue);

			dialogue = new Alphabet(0, 80, "", false, true);
			// dialogue.x = 90;
			// add(dialogue);
		}
		if (hasDialog && StoryMenuState.curWeek > 6)
		{ // J: THESE SHOULD BE THE ONLY TIMES THIS VARIABLE IS CALLED -- WEEK 7+ MIGHT HAVE DIALOGUE
			switch (StoryMenuState.curWeek) // J: IDK IF THEY WILL OR NOT BUT THIS IS FOR THE NEXT GUY AND I APOLOGIZE IF MY CODE IS TOTAL SHITE
			{
				case 7: // J: week dia
					trace("running thru week 7 stuffs!");
					portraitLeft = new FlxSprite(196,
						184).loadGraphic(Paths.image('portraits/dracobot')); // J: *this does* in fact go to the same spot, just still can't find it
					// trace(portraitLeft.x);
					// portraitLeft.frames = Paths.getSparrowAtlas('portraits/dracobot', 'week7'); //J: thinking that this only applies with a .xml?
					portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.125));
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set(); // J: thinking about this now, what the *fuck* is daPixelZoom?
					add(portraitLeft);
					// trace(portraitLeft.x);
					portraitLeft.visible = false;
					// J: *this does* in fact go to the same spot, just still can't find it
					// trace(portraitLeft.x);
					// portraitLeft.frames = Paths.getSparrowAtlas('portraits/dracobot', 'week7'); //J: thinking that this only applies with a .xml?

					portraitRight = new FlxSprite(768, 230).loadGraphic(Paths.image('portraits/biff'));
					// portraitRight.frames = Paths.getSparrowAtlas('portraits/biff');
					portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.15));
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set();
					add(portraitRight);
					portraitRight.visible = false;

					portraitMid = new FlxSprite(512, 230).loadGraphic(Paths.image('portraits/giff'));
					// portraitMid.frames = Paths.getSparrowAtlas('weeb/bfPortrait', 'week6');
					// portraitMid.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
					portraitMid.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.15));
					portraitMid.updateHitbox();
					portraitMid.scrollFactor.set();
					add(portraitMid);
					portraitMid.visible = false;

					spiritPortrait = new FlxSprite(280, 130).loadGraphic(Paths.image('portraits/spirit'));
					// portraitMid.frames = Paths.getSparrowAtlas('weeb/bfPortrait', 'week6');
					// portraitMid.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
					spiritPortrait.setGraphicSize(Std.int(spiritPortrait.width * 4.2));
					spiritPortrait.updateHitbox();
					spiritPortrait.scrollFactor.set();
					add(spiritPortrait);
					spiritPortrait.visible = false;

					box.animation.play('normalOpen');
					box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
					box.updateHitbox();
					add(box);

					box.screenCenter(X);
					// trace(box.y);
					box.y += 128;
					// trace(box.y);
					// portraitLeft.screenCenter(X);

					handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox', 'week6'));
					add(handSelect);

					if (!talkingRight)
					{
						// box.flipX = true;
					}

					dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
					dropText.font = 'Pixel Arial 11 Bold';
					dropText.color = 0xFFD89494;
					add(dropText);

					swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
					swagDialogue.font = 'Pixel Arial 11 Bold';
					swagDialogue.color = 0xFF3F2021;
					// swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dracotext'), 0.6)];
					add(swagDialogue);

					dialogue = new Alphabet(0, 80, "", false, true);
					// dialogue.x = 90;
					// add(dialogue);
			}
		}
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		// trace("J: " + hasDialog);
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null && curSong == 0)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
		if (hasDialog && curSong != 0)
		{
			// trace("dialogue should be opening about now!~");
			dialogueOpened = true;
		}

		if (dialogueOpened && !dialogueStarted)
		{
			// trace("dialogue should be starting about now!~");
			startDialogue();
			dialogueStarted = true;
		}

		if (TheBottomFuck > 0)
			TheBottomFuck -= 1;

		if (FlxG.keys.pressed.S && dialogueStarted == true && pauseInput == false)
		{
			TheBottomFuck += 2; 
			//SkipTextHighlight.clipRect = null;
			//trace(TheBottomFuck);
		}

		///var FuckOff:FlxRect = SkipTextHighlight.clipRect;
		//SkipTextHighlight.clipRect.x = SkipTextHighlight.x + this.TheBottomFuck;

		if (FlxG.keys.pressed.D && dialogueStarted == true && pauseInput == false)
		{
			trace(SkipTextHighlight.clipRect.x);
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true && pauseInput == false)
		{
			// trace("running more stuffs with dialogue!~");
			remove(dialogue);

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				BrutalMurder();
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				dialogueLine += 1;
				trace("dialogueLine = " + dialogueLine);
				startDialogue();
				// trace("J: dialogueList: " + dialogueList);
				// J: dialogueLine = 3 means that that's when Dracobot first speaks
				if (dialogueLine == 2 && StoryMenuState.curWeek == 7 && curSong == 1)
				{
					pauseInput = true;
					new FlxTimer().start(1.0, function(tmr:FlxTimer)
					{
						pauseInput = false;
					}, 1);
				}
				if (dialogueLine == 3 && StoryMenuState.curWeek == 7 && curSong == 1)
				{
					new FlxTimer().start(0.05, function(tmr:FlxTimer)
					{
						whiteScreen.visible = true;
						whiteScreen.alpha -= 1 / 64;
					}, 32);
				}
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function BrutalMurder():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			PlayState.blackScreen.visible = false;
			if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
				FlxG.sound.music.fadeOut(2.2, 0);
			if (StoryMenuState.curWeek == 6)
			{
				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					box.alpha -= 1 / 5;
					bgFade.alpha -= 1 / 5 * 0.7;
					portraitLeft.visible = false;
					portraitRight.visible = false;
					swagDialogue.alpha -= 1 / 5;
					dropText.alpha = swagDialogue.alpha;
				}, 5);
			}
			else
			{
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					box.alpha -= 1 / 64;
					// bgFade.alpha -= 1 / 64 * 0.7;
					// portraitLeft.visible = false;
					// portraitRight.visible = false;
					// portraitMid.visible = false;
					portraitLeft.alpha -= 1 / 64;
					portraitMid.alpha -= 1 / 64;
					portraitRight.alpha -= 1 / 64;
					spiritPortrait.alpha -= 1 / 64;
					swagDialogue.alpha -= 1 / 64;
					whiteScreen.alpha -= 1 / 128;
					dropText.alpha = swagDialogue.alpha;
				}, 64);
				if (curSong == 3)
				{
					iconP2 = new HealthIcon("angyDracobot", false);
				}
			}

			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				finishThing();
				kill();
			});

			if (StoryMenuState.curWeek == 7)
			{
				whiteScreen.visible = false;
			}
		}
	}

	function startDialogue():Void
	{
		// trace("dialogue started!~");
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		if (dialogueLine == 3 && curSong == 1)
		{
			PlayState.blackScreen.visible = false;
			portraitLeft.visible = true;
			portraitMid.visible = true;
			portraitRight.visible = true;
		}
		if (curSong > 1)
		{
			whiteScreen.visible = true;
			whiteScreen.alpha = 0.5;
			portraitLeft.visible = true;
			portraitMid.visible = true;
			portraitRight.visible = true;
		}
		if (curSong == 3)
		{
			switch (dialogueLine)
			{
				case 21:
					PlayState.dad.playAnim("singUP-alt");
				case 22:
					PlayState.dad.playAnim("idle");
				case 36:
					PlayState.dad.playAnim("singUP-alt");
				case 37:
					PlayState.dad.playAnim("idle");
				case 38:
					PlayState.dad.playAnim("singUP-alt");
				case 39:
					PlayState.dad.playAnim("idle");
			}
		}

		if (StoryMenuState.curWeek == 6)
		{
			switch (curCharacter) // J: SO THIS IS WHERE IT'S DECIDED, GOOD
			{ // J: this means that: gf portraits are the only things halting this now

				case 'dad':
					portraitRight.visible = false;
					if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				case 'bf':
					portraitLeft.visible = false;
					if (!portraitRight.visible)
					{
						portraitRight.visible = true;
						portraitRight.animation.play('enter');
					}
			}
		}
		if (StoryMenuState.curWeek > 6)
		{
			if (curSong != 1)
			{
				PlayState.blackScreen.visible = false;
			}
			if (spiritSpoke == true && curSong == 3)
			{
				iconP2 = new HealthIcon("spirit", false);
				portraitLeft.visible = false;
				spiritPortrait.visible = true;
			}
			else
			{
				iconP2 = new HealthIcon("dracobot", false);
				portraitLeft.visible = true;
				spiritPortrait.visible = false;
			}
			SkipText.setColorTransform(1, 1, 1, 1, 0, 0, 0);
			switch (curCharacter)
			{
				case 'dad':
					spiritSpoke = false;
					dracoGlitch = false;
					portraitLeft.visible = true;
					spiritPortrait.visible = false;
					portraitLeft.alpha = 1; // draco
					portraitMid.alpha = 0; // gf
					portraitRight.alpha = 0; // bf
					spiritPortrait.alpha = 0;
					if (curEmotion != '')
						switch (curEmotion)
						{
							case 'w':
								var Pibby:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

								var FuckShit:Int = 0;
								portraitLeft.loadGraphic(Paths.image('portraits/dracobot'));
								var RotationIndexShit:Int = 0;
								var CircleLol:FlxSprite = new FlxSprite(portraitLeft.x + 50, portraitLeft.y + portraitLeft.height * 0.2);
								CircleLol.frames = Paths.getSparrowAtlas('loading circle');
								CircleLol.animation.addByPrefix('fuckyou', 'circle lol', 12, true);
								CircleLol.animation.play('fuckyou');
								PlsDestroy.add(CircleLol);
							/*	for (i in 0...7)
								{
									var Barss = new FlxSprite(portraitLeft.x + (70 * Math.cos((45 * i) - 90)), portraitLeft.y + (70 * Math.sin((45 * i) - 90))).makeGraphic(20, 120, 0xFFFFFFFF);
									Barss.angle = i * 45;
									add(Barss);
									Pibby.members.push(Barss);
									trace(Barss.angle);
								} **/
								new FlxTimer().start(0.05, function(tmr:FlxTimer){
									portraitLeft.setColorTransform(1, 1, 1, 1, FuckShit, FuckShit, FuckShit);
									if (FuckShit != 145)
										FuckShit += 5;
									else
										add(CircleLol);
								}, 30);
							case 'killCircle':
								PlsDestroy.destroy();
								portraitLeft.setColorTransform(1, 1, 1, 1, 0, 0, 0);
							default:
								portraitLeft.loadGraphic(Paths.image('portraits/' + curEmotion));
						} 

					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dracotext'), 0.6)];
				case 'bf':
					portraitLeft.alpha = 0; // draco
					portraitMid.alpha = 0; // gf
					portraitRight.alpha = 1; // bf
					if (curEmotion != '')
						portraitRight.loadGraphic(Paths.image('portraits/' + curEmotion));

					if (curSong == 3)
					{
						spiritPortrait.alpha = 0;
					}
					if (curSong == 4)
					{
						spiritPortrait.alpha = 0;
					}
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
				case 'gf':
					{
						if (curEmotion != '')
							portraitMid.loadGraphic(Paths.image('portraits/' + curEmotion));
						portraitLeft.alpha = 0; // draco
						portraitMid.alpha = 1; // gf
						portraitRight.alpha = 0; // bf
						if (curSong == 3)
						{
							spiritPortrait.alpha = 0;
						}
						if (curSong == 4)
						{
							spiritPortrait.alpha = 0;
						}
						swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 1)];
					}
				case 'dark':
					{
						switch (dialogueLine)
						{
							case 0: swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 1)];
							case 1: swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
							case 2: swagDialogue.sounds = null;
						}
						// PlayState.camHUD.visible = false;
						PlayState.blackScreen.visible = true;
						SkipText.setColorTransform(1, 1, 1, 1, 40, 40, 40); // blackScreen.scrollFactor.set();
						portraitLeft.visible = false;
						portraitRight.visible = false;
						portraitMid.visible = false;
						// trace("J: blackScreen.visible = " + blackScreen.visible);
					}
				case 'spirit':
					{
						spiritSpoke = true;
						dracoGlitch = false;
						portraitLeft.visible = false;
						spiritPortrait.visible = true;
						portraitLeft.alpha = 0; // draco
						portraitMid.alpha = 0; // gf
						portraitRight.alpha = 0; // bf
						spiritPortrait.alpha = 1;

						swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 1)];
					}
				case 'shut':
					{ // portraitLeftG was here
						spiritSpoke = false;
						dracoGlitch = true;
						portraitLeft.visible = false;
						spiritPortrait.visible = false;
						portraitLeft.alpha = 0; // draco
						portraitMid.alpha = 0; // gf
						portraitRight.alpha = 0; // bf
						spiritPortrait.alpha = 0;
						swagDialogue.sounds = null;
					}
				case 'blank':
					portraitLeft.alpha = 0; // draco
					portraitMid.alpha = 0; // gf
					portraitRight.alpha = 0; // bf
					if (curSong == 3)
					{
						spiritPortrait.alpha = 0;
					}
					if (curSong == 4)
					{
						spiritPortrait.alpha = 0;
					}
					swagDialogue.sounds = null;
			}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curEmotion = splitName[0];
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[0].length + splitName[1].length + 2).trim();
	}
}
// 543 - 261 = 282

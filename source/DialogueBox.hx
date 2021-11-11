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

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

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

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH instance 1', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn instance 1', [11], "", 24);

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
	var dialogueEnded:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if(PlayerSettings.player1.controls.ACCEPT)
		{
			if (dialogueEnded)
			{
				remove(dialogue);
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
						FlxG.sound.play(Paths.sound('clickText'), 0.8);	

						if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
							FlxG.sound.music.fadeOut(1.5, 0);

						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							box.alpha -= 1 / 5;
							bgFade.alpha -= 1 / 5 * 0.7;
							portraitLeft.visible = false;
							portraitRight.visible = false;
							swagDialogue.alpha -= 1 / 5;
							handSelect.alpha -= 1 / 5;
							dropText.alpha = swagDialogue.alpha;
						}, 5);

						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
						});
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
				}
			}
			else if (dialogueStarted)
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
				swagDialogue.skip();
				
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		swagDialogue.completeCallback = function() {
			handSelect.visible = true;
			dialogueEnded = true;
		};

		handSelect.visible = false;
		dialogueEnded = false;
		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					if (PlayState.SONG.song.toLowerCase() == 'senpai') portraitLeft.visible = true;
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
		if(nextDialogueThing != null) {
			nextDialogueThing();
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

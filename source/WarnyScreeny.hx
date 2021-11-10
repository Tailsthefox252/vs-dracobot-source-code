package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.addons.display.FlxTiledSprite;
import flixel.FlxSprite;

class WarnyScreeny extends FlxState
{
	var FuckShit:FlxSound = new FlxSound().loadEmbedded(Paths.sound('pixelText', 'shared'));
	var WarningStrip:FlxTiledSprite;
    override public function create()
    {
		WarningStrip = new FlxTiledSprite(Paths.image('warning', 'shared'), FlxG.width, FlxG.height, true, false);
        WarningStrip.antialiasing = true;
		var WarningStripOverlay:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xBF000000);
		var TextWarning:FlxText = new FlxText(FlxG.width * 0.025, FlxG.height * 0.20, 0, "WARNING\n\nThis mod contains flashing lights and rapidly moving arrows\nfor the third song. You cannot turn them off so play \nat your own risk. Or watch at your own risk if someone is \n recording gameplay of this mod.\n\n To disable this warning, Press F. \n\n\n PRESS ESCAPE TO CONTINUE", 32);
        TextWarning.alignment = CENTER;
        add(WarningStrip);
        add(WarningStripOverlay);
        add(TextWarning);
        FuckShit.play();
    }
    override public function update(elapsed:Float)
    {
        WarningStrip.scrollX += 0.9;
		if(FlxG.keys.justPressed.ESCAPE)
		{
			FuckShit.loadEmbedded(Paths.sound('cancelMenu'));
            FuckShit.play();
            FlxG.switchState(new Caching());
        }
        if(FlxG.keys.justPressed.F)
        {
			FuckShit.loadEmbedded(Paths.sound('confirmMenu'));
			FlxG.save.data.warningScreen = false;
			FuckShit.play();
			FlxG.switchState(new Caching());
        }
    }
}
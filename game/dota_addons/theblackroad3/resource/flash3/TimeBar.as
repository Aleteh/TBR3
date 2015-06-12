package  {
       
    import flash.display.MovieClip
    import flash.display.Shape
    import fl.motion.Color
    import flash.geom.Transform
    import flash.geom.Rectangle
    import flash.events.Event

    import flash.display.*
    import flash.filters.*
    import flash.text.*
    import scaleform.clik.events.*
    import scaleform.gfx.TextFieldEx
    import ValveLib.Globals     
       
    public class TimeBar extends MovieClip {
        private var time:Number = 1.0           
        private var percent:Number = 1.0
        private var frameCount:int = 60
        private var percStep:Number = 1/60
        private var tint:Color = new Color()
		private var channelBarFill:Bitmap
        private var channelBarGlow:Bitmap
		private var barMask:Shape
		private var textBox:TextField
        private var txFormat:TextFormat
        public  var callback:Function;
                   
        public function TimeBar(time:Number, callback:Function, textColor:uint = 0xFFFFFF){
		    this.callback = callback
            this.time = time
               
            this.frameCount = time * 60
            this.percStep = 1 / frameCount
            
            // Black bar as background
            var channelBar:Bitmap = new Bitmap(new ChannelBarPNG())
            channelBar.width = 359
            channelBar.height = 24
            this.addChild(channelBar)

            // Blue Bar to draw on top
            channelBarFill = new Bitmap(new ChannelBarFillPNG())
            channelBarFill.x = 3
            channelBarFill.y = 3
            channelBarFill.width = 353
            channelBarFill.height = 18
            this.addChild(channelBarFill)
			
             // Mask fill
            barMask = new Shape
            barMask.graphics.beginFill(0x000000)
            barMask.graphics.drawRect(3, 3, this.channelBarFill.width, this.channelBarFill.height)
            barMask.graphics.endFill()
            this.addChild(barMask)
            channelBarFill.mask = barMask
			
			// Glow on the bar pos
            channelBarGlow = new Bitmap(new ChannelBarGlowPNG())
            channelBarGlow.x = channelBarFill.width - (channelBarGlow.width/2) + 1
			channelBarGlow.y = -1
			channelBarGlow.height = 24
            this.addChild(channelBarGlow)

            // "Remaining: Time" Text
            txFormat = new TextFormat()
            txFormat.align = TextFormatAlign.CENTER
            txFormat.font = "$TextFontBold"
            txFormat.size = 12
            txFormat.color = textColor
			
            textBox = new TextField()
            textBox.width = 359 
            textBox.height = 24
            textBox.text = Globals.instance.GameInterface.Translate("#ItemDrops_Time_Remaining") + time.toFixed(1)
            textBox.alpha = 0.9
            textBox.filters = [new GlowFilter(0x000000)]
            textBox.setTextFormat(txFormat)
            TextFieldEx.setVerticalAlign(textBox, TextFieldEx.VALIGN_CENTER)
            this.addChild(textBox)
               
            this.addEventListener(Event.ENTER_FRAME, frameEnter)
            frameEnter(null)

            trace("### TimeBar Start!")
        }
           
        public function frameEnter(e:Event){
            if (Globals.instance.Loader_overlay.movieClip.dota_paused.visible)
                return

			time -= 1/60
            percent -= percStep
            frameCount--
            var newWidth:Number = Math.floor(this.channelBarFill.width * percent)
            barMask.width = newWidth
            channelBarGlow.x = newWidth - (channelBarGlow.width/2) + 1 //Update the glow marker
            textBox.text = Globals.instance.GameInterface.Translate("#ItemDrops_Time_Remaining") + time.toFixed(1)
            textBox.setTextFormat(txFormat)
            
            if (frameCount < 0){
                this.removeEventListener(Event.ENTER_FRAME, frameEnter)
                if (this.parent) {
                    trace("[TimeBar] End")
                    this.parent.removeChild(this);
                    callback(true)
                }
                return
            }
        }
    }
       
}
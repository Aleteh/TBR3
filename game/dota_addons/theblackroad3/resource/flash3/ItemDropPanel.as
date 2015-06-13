//=====================================================================================================
// ItemDropsPanel.as
//=====================================================================================================
package {
	import ValveLib.Globals;
	import flash.events.*;
	import flash.display.MovieClip;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import flash.display.*;
    import flash.filters.*;
    import flash.text.*;
    import scaleform.clik.events.*;
    import vcomponents.*;

    import passButton;
    import needButton;
    import greedButton;
	import proTip;

	public class ItemDropPanel extends MovieClip{

		public var gameAPI:Object;
		public var panelIndex:String;
		private var passBtn:SimpleButton;
        private var needBtn:SimpleButton;
        private var greedBtn:SimpleButton;
		public  var callbackClose:Function; 
		private var tooltipPass:proTip = new proTip();
		private var tooltipNeed:proTip = new proTip();
		private var tooltipGreed:proTip = new proTip();

		// Constructor takes the item name, text and color
		public function ItemDropPanel(itemName:String, itemColor:Number, itemText:String, itemIndex:String, timeoutTime:Number, callback:Function, api:Object){
			this.callbackClose = callback;
			
			//trace("[ItemDrop] ItemDropPanel Start");
			//trace("[ItemDropPanel] Data: ",itemName,itemColor,itemText,itemIndex)
			this.gameAPI = api;
			this.panelIndex = itemIndex;

			var dropMC:MovieClip = new MovieClip;

			var itemDropMenu:Bitmap = new Bitmap(new ItemDropMenuPNG());
			dropMC.addChild(itemDropMenu);
			
			var itemIcon:ResourceIcon = new ResourceIcon(itemName.substr(5,itemName.length), true)
			itemIcon.x = 43
			itemIcon.y = 18
			itemIcon.width = 61
			itemIcon.height = 46
			itemIcon.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver)
			itemIcon.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut)
			dropMC.addChild(itemIcon)

			// Buttons
			// Pass
			this.passBtn = new passButton()
     		this.passBtn.x = 460
			this.passBtn.y = 5
			this.passBtn.width = 26
			this.passBtn.height = 26
			this.passBtn.addEventListener(MouseEvent.CLICK, onClickPass)
			this.passBtn.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverPass)
			this.passBtn.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutPass)	
			dropMC.addChild(this.passBtn)
			
			// Need
			this.needBtn = new needButton()
     		this.needBtn.x = 397
			this.needBtn.y = 8
			this.needBtn.addEventListener(MouseEvent.CLICK, onClickNeed)	
			this.needBtn.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverNeed)
			this.needBtn.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutNeed)
			dropMC.addChild(this.needBtn)

			// Greed
			this.greedBtn = new greedButton()
     		this.greedBtn.x = 397
			this.greedBtn.y = 54
			this.greedBtn.addEventListener(MouseEvent.CLICK, onClickGreed)
			this.greedBtn.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverGreed)
			this.greedBtn.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutGreed)
			dropMC.addChild(this.greedBtn)			

			// Text
			var txFormat:TextFormat = new TextFormat()
			txFormat.align = TextFormatAlign.CENTER
			txFormat.font = "$TextFont" //TitleFont
			txFormat.size = 20
			txFormat.color = itemColor

			var textBox:TextField = new TextField()
			textBox.x = 110
			textBox.y = 21
            textBox.width = 263 
            textBox.height = 70 
            textBox.multiline = true 
            textBox.wordWrap = true
            //textBox.border = true
            textBox.text = itemText //String passed by parameter
			textBox.alpha = 0.9
			textBox.filters = [new GlowFilter(0x000000)]

			textBox.setTextFormat(txFormat)
			dropMC.addChild(textBox)

			// Time Bar
			var timeBar:TimeBar = new TimeBar(timeoutTime, Timeout)
			timeBar.x = 29
            timeBar.y = 77
			dropMC.addChild(timeBar)
			
			//Tooltiperinos by zedlenaGomez
			dropMC.addChild(tooltipPass);
			dropMC.addChild(tooltipNeed);
			dropMC.addChild(tooltipGreed);

			// Finally, add the MovieClip to the stage
			this.addChild(dropMC);

			trace("[ItemDrops] ItemDropPanel Created");
		}

		public function onMouseRollOver(keys:MouseEvent){
       		var s:Object = keys.target;
            var lp:Point = s.localToGlobal(new Point(0, 0));
			//trace("Roll over ",s.getResourceName());

			// This one shows "Not enough gold" but it'll do good for now.
            Globals.instance.Loader_shop.gameAPI.ShowItemTooltip(lp.x, lp.y, s.getResourceName());
       	}
		
		public function onMouseRollOut(keys:MouseEvent){	
			Globals.instance.Loader_shop.gameAPI.HideItemTooltip();
		}

		public function onMouseRollOverPass(keys:MouseEvent){
			var s:Object = keys.target;
            var lp:Point = s.localToGlobal(new Point(0, 0));
			tooltipPass.kissAndTell(s.x-55, s.y - 3, 'Pass');
       	}
		
		public function onMouseRollOutPass(keys:MouseEvent){	
			tooltipPass.pleaseHideMeSenpai();
		}
		
		public function onMouseRollOverNeed(keys:MouseEvent){
			var s:Object = keys.target;
            var lp:Point = s.localToGlobal(new Point(0, 0));
			tooltipNeed.kissAndTell(s.x+40, s.y + needBtn.height/2 - tooltipNeed.height/2, 'Need');
       	}
		
		public function onMouseRollOutNeed(keys:MouseEvent){	
			tooltipNeed.pleaseHideMeSenpai();
		}
		
		public function onMouseRollOverGreed(keys:MouseEvent){
       		var s:Object = keys.target;
            var lp:Point = s.localToGlobal(new Point(0, 0));
			tooltipGreed.kissAndTell(s.x+40, s.y + greedBtn.height/2 - tooltipGreed.height/2, 'Greed');
       	}
		
		public function onMouseRollOutGreed(keys:MouseEvent){
			tooltipGreed.pleaseHideMeSenpai();
		}

		public function onClickPass(event:MouseEvent) {
			trace("[ItemDrops] Pass!");
			var pID:int = Globals.instance.Players.GetLocalPlayer();
			this.gameAPI.SendServerCommand("ItemDropsRoll "+pID+" pass "+panelIndex);
			this.visible = false;
			// How to gameAPI with Globals?
			
			callbackClose(this);
		}

		public function onClickNeed(event:MouseEvent) {
			trace("[ItemDrops] Need!");
			var pID:int = Globals.instance.Players.GetLocalPlayer();
			this.gameAPI.SendServerCommand("ItemDropsRoll "+pID+" need "+panelIndex);
			this.visible = false;
			
			callbackClose(this);
		}

		public function onClickGreed(event:MouseEvent) {
			trace("[ItemDrops] Greed!");
			var pID:int = Globals.instance.Players.GetLocalPlayer();
			this.gameAPI.SendServerCommand("ItemDropsRoll "+pID+" greed "+panelIndex);
			this.visible = false;
			
			callbackClose(this);
		}

		public function Timeout() {
			if (this.visible) {
				this.visible = false
				trace("[ItemDrops] Timeout");
				var pID:int = Globals.instance.Players.GetLocalPlayer();
				this.gameAPI.SendServerCommand("ItemDropsRoll "+pID+" pass "+panelIndex);
			}
			callbackClose(this);
		}
	}
}
﻿//=====================================================================================================
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

	public class ItemDropPanel extends MovieClip{

		public var gameAPI:Object;
		public var panelIndex:String;
		private var passBtn:SimpleButton;
        private var needBtn:SimpleButton;
        private var greedBtn:SimpleButton;

		// Constructor takes the item name, text and color
		public function ItemDropPanel(itemName:String, itemColor:Number, itemText:String, dropIndex:String, api:Object){

			trace("[ItemDrop] ItemDropPanel Start");
			trace("[ItemDropPanel] Data: ",itemName,itemColor,itemText,dropIndex)
			this.gameAPI = api;
			this.panelIndex = dropIndex;

			var dropMC:MovieClip = new MovieClip;

			var itemDropMenu:Bitmap = new Bitmap(new ItemDropMenuPNG());
			dropMC.addChild(itemDropMenu);

			trace("[ItemDrop] BitMap Ok");
			
			// Icon
			var itemIcon:ResourceIcon = new ResourceIcon(itemName.substr(5,itemName.length), true);
			itemIcon.x = 53;
			itemIcon.y = 28;
			itemIcon.width = 70;
			itemIcon.height = 45;
			itemIcon.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			itemIcon.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			dropMC.addChild(itemIcon);

			trace("[ItemDrop] ResourceIcon "+itemName.substr(5,itemName.length)+" Ok");

			// Buttons
			// Pass
			this.passBtn = new passButton();
     		this.passBtn.x = 471;
			this.passBtn.y = 16;
			this.passBtn.width = 25;
			this.passBtn.height = 26;
			this.passBtn.addEventListener(MouseEvent.CLICK, onClickPass);
			//itemIcon.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverPass);
			//itemIcon.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutPass);	
			dropMC.addChild(this.passBtn);
			
			// Need
			this.needBtn = new needButton();
     		this.needBtn.x = 410;
			this.needBtn.y = 18;
			this.needBtn.addEventListener(MouseEvent.CLICK, onClickNeed);	
			//itemIcon.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverNeed);
			//itemIcon.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutNeed);
			dropMC.addChild(this.needBtn);

			// Greed
			this.greedBtn = new greedButton();
     		this.greedBtn.x = 410;
			this.greedBtn.y = 62;
			this.greedBtn.addEventListener(MouseEvent.CLICK, onClickGreed);
			//itemIcon.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverGreed);
			//itemIcon.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutGreed);
			dropMC.addChild(this.greedBtn);			

			trace("[ItemDrop] Buttons Ok");

			// Text
			var txFormat:TextFormat = new TextFormat();
			txFormat.align = TextFormatAlign.CENTER;
			txFormat.font = "$TextFont"; //TitleFont
			txFormat.size = 20;

			trace("[ItemDrop] Format Ok");

			var textBox:TextField = new TextField();
			textBox.x = 128;
			textBox.y = 35;
            textBox.width = 263; 
            textBox.height = 37; 
            textBox.multiline = true; 
            textBox.wordWrap = true;
            //textBox.border = true;
            textBox.text = itemText; //String passed by parameter
			textBox.alpha = 0.9;
			textBox.filters = [new GlowFilter(0x000000)];

			trace("[ItemDrop] TextBox Ok");
           			
			txFormat.color = itemColor;

            trace("[ItemDrop] Colors Ok");

			textBox.setTextFormat(txFormat);
			dropMC.addChild(textBox);

			trace("[ItemDrop] addChild textBox Ok");

			// Time Bar


			// Finally, add the MovieClip to the stage
			this.addChild(dropMC);

			trace("[ItemDrops] ItemDropPanel Created");
		}

		public function onMouseRollOver(keys:MouseEvent){
       		var s:Object = keys.target;
            var lp:Point = s.localToGlobal(new Point(0, 0));
			trace("Roll over ",s.getResourceName());

			// This one shows "Not enough gold" but it'll do good for now.
            Globals.instance.Loader_shop.gameAPI.ShowItemTooltip(lp.x, lp.y, s.getResourceName());
       	}
		
		public function onMouseRollOut(keys:MouseEvent){	
			Globals.instance.Loader_shop.gameAPI.HideItemTooltip();
		}

		public function onClickPass(event:MouseEvent) {
			trace("[ItemDrops] Pass!");
			var pID:int = Globals.instance.Players.GetLocalPlayer();
			this.gameAPI.SendServerCommand("ItemDropsRoll "+pID+" pass "+panelIndex);
			this.visible = false;
			// How to gameAPI with Globals?
		}

		public function onClickNeed(event:MouseEvent) {
			trace("[ItemDrops] Need!");
			var pID:int = Globals.instance.Players.GetLocalPlayer();
			this.gameAPI.SendServerCommand("ItemDropsRoll "+pID+" need "+panelIndex);
			this.visible = false;
		}

		public function onClickGreed(event:MouseEvent) {
			trace("[ItemDrops] Greed!");
			var pID:int = Globals.instance.Players.GetLocalPlayer();
			this.gameAPI.SendServerCommand("ItemDropsRoll "+pID+" greed "+panelIndex);
			this.visible = false;
		}
	}
}
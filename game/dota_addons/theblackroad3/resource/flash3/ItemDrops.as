//=====================================================================================================
// ItemDrops.as
//=====================================================================================================
package {
	import flash.display.MovieClip;
	import flash.text.*;

	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;

	public class ItemDrops extends MovieClip {
		
		//these three variables are required by the engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;

		private var ScreenWidth:int;
		private var ScreenHeight:int;
		public var scaleRatioY:Number;
		public var maxDropsOnScreen:Number;

		public var itemKV:Object;
		public var itemDropsInfo:Object;
		
		public var panels:Array = new Array()

		// unused constructor
		public function ItemDrops() : void {
		}

		public function onLoaded() : void {
			//make this UI visible
			visible = true;

			// load values from KV
			loadItemKV();

			//let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);

			//events
			this.gameAPI.SubscribeToGameEvent("item_drop", this.createDropPanel);
			//this.gameAPI.SubscribeToGameEvent("item_won", this.createItemWonPanel);*/

			trace("[ItemDrops] Loaded");
			trace(elementName);
		}

		public function createDropPanel(args:Object) : void {
			trace("[ItemDrops] Creating Item Drop Panel");
			trace("[ItemDrops] Name: "+args.item_name+" - Index: "+args.item_index);
			
			var itemName:String = args.item_name; //Internal name of the item
			var itemIndex:String = args.item_index; //Entity index of the dropped item
			var itemQuality:String = itemKV[itemName].ItemQuality; //"ItemQuality" value
			if (itemQuality == null || itemQuality.length == 0){
				trace("[ItemDrops] Couldn't find an ItemQuality, defaulting to common");
				itemQuality = "common";
			}
			var color_from_string = itemDropsInfo["ItemQualityColors"][itemQuality]
			var itemColor:Number = Number(color_from_string.replace('#', '0x'));
			
			var itemText:String = Globals.instance.GameInterface.Translate("#DOTA_Tooltip_ability_"+itemName); //Full item name
			if (itemText == null || itemText.length == 0){
				trace("[ItemDrops] Couldn't find an Item Tooltip, defaulting to the itemName: "+itemName);
				itemText = itemName;
			}
			var timeoutTime:Number = itemDropsInfo["MaxTime"]
			maxDropsOnScreen = itemDropsInfo["MaxDropsOnScreen"]

			// After adding the child, add it to the array of ItemDropPanel
			var itemDrop = new ItemDropPanel(itemName, itemColor, itemText, itemIndex, timeoutTime, callbackClosePanel, gameAPI);
			this.addChild(itemDrop)
			panels.push(itemDrop)

			// Position it above the latest added panel
			var pos:Number = panels.indexOf(itemDrop) % 3
			itemDrop.x = ScreenWidth - itemDrop.width
			itemDrop.y = ScreenHeight * 0.6 - pos * itemDrop.height
		}

		// After closing a panel (Need/Greed/Pass/Timeout), remove it and reposition the panels
		private function callbackClosePanel(args:MovieClip){
			trace("callbackClosePanel");
			panels.splice(panels.indexOf(args),1)
			this.removeChild(args);
			for each (var elem in panels) {
			    var pos:Number = panels.indexOf(elem) % maxDropsOnScreen
			    elem.y = ScreenHeight * 0.6 - pos * elem.height
			    trace("[ItemDrops] Repositioned panel "+panels.indexOf(elem)+" at "+elem.y)
			}
		}

		// Load the item key values to find its quality for coloring
		private function loadItemKV() {
			itemKV = Globals.instance.GameInterface.LoadKVFile('scripts/npc/npc_items_custom.txt');
			itemDropsInfo = Globals.instance.GameInterface.LoadKVFile('scripts/kv/item_drops.kv');
			trace("[ItemDrops] KV Loaded!");
		}

		public function onResize(re:ResizeManager) : * {

			// calculate by what ratio the stage is scaling
			scaleRatioY = re.ScreenHeight/1080;
			
			trace("##### RESIZE #########");
					
			ScreenWidth = re.ScreenWidth;
			ScreenHeight = re.ScreenHeight;
		}
	}
}
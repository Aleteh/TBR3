//=====================================================================================================
// CustomUI.as
//=====================================================================================================
package {
	import flash.display.MovieClip;
	import flash.text.*;

	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	
	public class CustomUI extends MovieClip{
		
		//these three variables are required by the engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		
		//constructor, you usually will use onLoaded() instead
		public function CustomUI() : void {

		}
			
		//this function is called when the UI is loaded
		public function onLoaded() : void {			
			//make this UI visible
			visible = true;
			
			//let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);
			
			//pass the gameAPI on to the modules
			this.myModule.setup(this.gameAPI, this.globals);
			this.myResource.setup(this.gameAPI, this.globals);
			this.myUnlockAbility.setup(this.gameAPI, this.globals);
			
			//this.myResource.setMaterials("322"); //TEST
			
			//Listeners
			this.gameAPI.SubscribeToGameEvent("rpg_load", this.loadPlayerData);
			this.gameAPI.SubscribeToGameEvent("rpg_save", this.savePlayerData);
			
			//this is not needed, but it shows you your UI has loaded (needs 'scaleform_spew 1' in console)
			trace("Custom UI loaded!");
		}
		
		public function loadPlayerData(args:Object) : void {
			trace("[RPG]Starting to Load Player Data");
			
			// Get the player save for his heroID (if there is one)
			var pID:int = globals.Players.GetLocalPlayer();
			if (args.player_ID == pID) {
				trace("[RPG]Calling GetSave for player "+pID+" of heroID "+args.save_ID);
				globals.Loader_StatsCollectionRPG.movieClip.GetSave('07dac9699d6c9b7442f8ee7c18c18126', args.save_ID, playerDataCallback);
			}

			trace("#[RPG]Finished Loading Player Data ");
		}
		
		// With the acquired string we'll send the info back to lua??
		public function playerDataCallback(jsonData:Object) : void {
			trace("[RPG]playerDataCallback");
			
			for (var info in jsonData) {
				trace("jsonData." + info + " = " + jsonData[info]);
			}
			
			var pID:int = globals.Players.GetLocalPlayer();
			var hero_XP:int = jsonData["hero_XP"];
			var gold:int = jsonData["gold"];
			var materials:int = jsonData["materials"];
			var STR_points:int = jsonData["STR_points"];
			var AGI_points:int = jsonData["AGI_points"];
			var INT_points:int = jsonData["INT_points"];
			var unspent_points:int = jsonData["unspent_points"];
			var hero_items:String = jsonData["hero_items"];
			var ability_levels:String = jsonData["ability_levels"];
			
			var command:String = "Load "+pID+" "+hero_XP+" "+gold+" "+materials+" "+STR_points+" "+AGI_points+" "+INT_points+" "+unspent_points+" "+hero_items+" "+ability_levels;
			this.gameAPI.SendServerCommand(command);
			trace("[RPG]SendServerCommand "+command);			
			trace("[RPG]End playerDataCallback");
		}
		
		public function savePlayerData(args:Object) : void {
			trace("[RPG]Saving Player Data");
			
			// args.hero_level has a single value
			// args.hero_items has item0,item1,item2,empty,item4,empty
			
			var pID:int = globals.Players.GetLocalPlayer();
			if (args.player_ID == pID) {
				globals.Loader_StatsCollectionRPG.movieClip.SaveData('07dac9699d6c9b7442f8ee7c18c18126', args.save_ID, 
					{ 	"hero_XP":args.hero_XP,
						"gold":args.gold,
						"materials":args.materials,
						"STR_points":args.STR_points,
						"AGI_points":args.AGI_points,
						"INT_points":args.INT_points,
						"unspent_points":args.unspent_points,
					  	"hero_items":args.hero_items,
					  	"ability_levels":args.ability_levels }, "Save1", saveDataCallback);
			}
		}
		
		public function saveDataCallback(success:Boolean) {
			if (success) {
				trace("[RPG]Successfully saved the data for the player");
			}
			else{
				trace("[RPG]Something went wrong, save failed");
			}
		}
		
		//this handles the resizes
		public function onResize(re:ResizeManager) : * {
			var rm = Globals.instance.resizeManager;
			var currentRatio:Number =  re.ScreenWidth / re.ScreenHeight;
			var divided:Number;
		
			// Set this to your stage height, however, if your assets are too big/small for 1024x768, you can change it
			// This is just your original stage height
			var originalHeight:Number = 900;
					
			if(currentRatio < 1.5)
			{
				// 4:3
				divided = currentRatio / 1.333;
			}
			else if(re.Is16by9()){
				// 16:9
				divided = currentRatio / 1.7778;
			} else {
				// 16:10
				divided = currentRatio / 1.6;
			}
							
			 var correctedRatio:Number =  re.ScreenHeight / originalHeight * divided;
			
			//pass the resize event to our module, we pass the width and height of the screen, as well as the correctedRatio.
			//this.myModule.screenResize(re.ScreenWidth, re.ScreenHeight, correctedRatio);
		}
	}
}
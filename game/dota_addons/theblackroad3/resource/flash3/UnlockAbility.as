//=====================================================================================================
// UnlockAbility.as
//=====================================================================================================
package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;

	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import flash.geom.Point;
	
	public class UnlockAbility extends MovieClip {
		
		public var gameAPI:Object;
		public var globals:Object;
        public var ability_choices:Object;
		public var points:int;
		public var skill_choice:String;
		   
		public function UnlockAbility() {
		}
		
		//set initialise this instance's gameAPI
		public function setup(api:Object, globals:Object) {
			this.gameAPI = api;
			this.globals = globals;
			this.unlockAbilityMenu5.visible=false;
			this.unlockAbilityMenu6.visible=false;
			this.unlockAbility5Button.visible=false;
			this.unlockAbility6Button.visible=false;

			// load values from KV
			loadKV();

			//Listeners - Make the buttons visible after reaching the level required
			this.gameAPI.SubscribeToGameEvent("ability_5_unlocked", this.onAbility5Unlocked);
			this.gameAPI.SubscribeToGameEvent("ability_6_unlocked", this.onAbility6Unlocked);
	
			//Button
			this.unlockAbility5Button.addEventListener(MouseEvent.CLICK, onButton5Clicked);
			this.unlockAbility6Button.addEventListener(MouseEvent.CLICK, onButton6Clicked);
			
			trace("[UnlockAbility] Module Setup!");
		}

		public function onAbility5Unlocked(args:Object) : void {	
			trace("onAbility5Unlocked")
			// Show for this player
			var pID:int = globals.Players.GetLocalPlayer();
			if (args.player_ID == pID) {
				this.unlockAbility5Button.visible=true;
			}
		}

		public function onAbility6Unlocked(args:Object) : void {
		trace("onAbility6Unlocked")	
			// Show for this player
			var pID:int = globals.Players.GetLocalPlayer();
			if (args.player_ID == pID) {
				this.visible = true
				// Careful of dumb overlap
				this.unlockAbilityMenu5.visible=false;
				this.unlockAbility5Button.visible=false;

				this.unlockAbility6Button.visible=true;
			}
		}

		public function onButton5Clicked(event:MouseEvent) {
			this.unlockAbilityMenu5.visible=true;
			trace("onButton5Clicked");

			var pID:int = globals.Players.GetLocalPlayer();
			var heroName:String = globals.Players.GetPlayerSelectedHero( pID )

			// Dynamically add the abilities and tooltip text for each hero skills here.
			var journeyman1:ResourceIcon = new ResourceIcon(ability_choices[heroName][1]);
			journeyman1.x = -150;
			journeyman1.y = -72;
			journeyman1.scaleX = 1;
			journeyman1.scaleY = 1;
			journeyman1.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			journeyman1.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			journeyman1.addEventListener(MouseEvent.CLICK, onAbilityClick5);
			this.unlockAbilityMenu5.addChild(journeyman1);
						
			var journeyman2:ResourceIcon = new ResourceIcon(ability_choices[heroName][2]);
			journeyman2.x = 36;
			journeyman2.y = -72;
			journeyman1.scaleX = 1;
			journeyman1.scaleY = 1;
			journeyman2.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverRight);
			journeyman2.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			journeyman2.addEventListener(MouseEvent.CLICK, onAbilityClick5);
			this.unlockAbilityMenu5.addChild(journeyman2);		
		}

		public function onButton6Clicked(event:MouseEvent) {
			this.unlockAbilityMenu6.visible=true;
			trace("onButton6Clicked");

			var pID:int = globals.Players.GetLocalPlayer();
			var heroName:String = globals.Players.GetPlayerSelectedHero( pID )

			// Dynamically add the abilities and tooltip text for each hero skills here.
			var ultimate1:ResourceIcon = new ResourceIcon(ability_choices[heroName][3]);
			ultimate1.x = -150;
			ultimate1.y = -72;
			ultimate1.scaleX = 1;
			ultimate1.scaleY = 1;
			ultimate1.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			ultimate1.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			ultimate1.addEventListener(MouseEvent.CLICK, onAbilityClick6);
			this.unlockAbilityMenu6.addChild(ultimate1);
						
			var ultimate2:ResourceIcon = new ResourceIcon(ability_choices[heroName][4]);
			ultimate2.x = 36;
			ultimate2.y = -72;
			ultimate2.scaleX = 1;
			ultimate2.scaleY = 1;
			ultimate2.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverRight);
			ultimate2.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			ultimate2.addEventListener(MouseEvent.CLICK, onAbilityClick6);
			this.unlockAbilityMenu6.addChild(ultimate2);		
		}
		
		public function onMouseRollOver(keys:MouseEvent){
       		var s:Object = keys.target;
            var lp:Point = s.localToGlobal(new Point(0, 0));
            skill_choice = s.getResourceName();
			trace("Roll over ",s.getResourceName())
            globals.Loader_heroselection.gameAPI.OnSkillRollOver(lp.x, lp.y, skill_choice);
       	}
		
		public function onMouseRollOut(keys:MouseEvent){	
			globals.Loader_heroselection.gameAPI.OnSkillRollOut();
		}
		
		public function onMouseRollOverRight(keys:MouseEvent){
       		var s:Object = keys.target;
            var lp:Point = s.localToGlobal(new Point(0, 0));
			var offset:Number = 72;
			skill_choice = s.getResourceName();
           	globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(lp.x+offset, lp.y, skill_choice);
       	}

       	// Send the choice to Lua
       	public function onAbilityClick5(keys:MouseEvent){
        	this.visible = false;
        	trace("Chosen "+skill_choice+" as journeyman ability")
        	this.gameAPI.SendServerCommand("AbilityChoice 5 "+skill_choice);
			return;
       	}

       	public function onAbilityClick6(keys:MouseEvent){
        	this.visible = false;
        	trace("Chosen "+skill_choice+" as ultimate ability")
        	this.gameAPI.SendServerCommand("AbilityChoice 6 "+skill_choice);
			return;
       	}
	
		// load the abilities
		private function loadKV() {
			ability_choices = Globals.instance.GameInterface.LoadKVFile('scripts/kv/ability_choices.kv');
			trace("[UnlockAbility] KV Loaded");
		}
		
    		
		/*public function screenResize(stageX:int, stageY:int, scaleRatio:Number){
			this.x = stageX/2
			this.y = stageY/2;
		}*/
	}	
}
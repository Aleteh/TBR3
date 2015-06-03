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
          
		public var points:int;
		   
		public function UnlockAbility() {
		}
		
		//set initialise this instance's gameAPI
		public function setup(api:Object, globals:Object) {
			this.gameAPI = api;
			this.globals = globals;
			this.unlockAbilityMenu5.visible=false;
			
			//Listener
			//this.gameAPI.SubscribeToGameEvent("cgm_player_stat_points_changed", this.OnStatPointsChanged);
	
			//Button
			this.unlockAbility5Button.addEventListener(MouseEvent.CLICK, onButton5Clicked);
			
			trace("##Module Setup!");
		}

		public function onButton5Clicked(event:MouseEvent) {
			this.unlockAbilityMenu5.visible=true;
			trace("onButton5Clicked");
			
			// Dynamically add the abilities and tooltip text for each hero skills here.
			var journeyman1:ResourceIcon = new ResourceIcon("khaoschampion_requiem");
			trace(journeyman1.scaleX,journeyman1.scaleY, journeyman1.width, journeyman1.height);
			journeyman1.x = -150;
			journeyman1.y = -72;
			journeyman1.scaleX = 1;
			journeyman1.scaleY = 1;
			journeyman1.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			journeyman1.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			this.unlockAbilityMenu5.addChild(journeyman1);
						
			var journeyman2:ResourceIcon = new ResourceIcon("khaoschampion_terrorize");
			journeyman2.x = 36;
			journeyman2.y = -72;
			journeyman1.scaleX = 1;
			journeyman1.scaleY = 1;
			journeyman2.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOverRight);
			journeyman2.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			this.unlockAbilityMenu5.addChild(journeyman2);		
		}
		
		public function onMouseRollOver(keys:MouseEvent){
       		var s:Object = keys.target;
            var lp:Point = s.localToGlobal(new Point(0, 0));
			
            globals.Loader_heroselection.gameAPI.OnSkillRollOver(lp.x, lp.y, s.getResourceName());
       	}
		
		public function onMouseRollOut(keys:MouseEvent){	
			globals.Loader_heroselection.gameAPI.OnSkillRollOut();
		}
		
		public function onMouseRollOverRight(keys:MouseEvent){
       		var s:Object = keys.target;
            var lp:Point = s.localToGlobal(new Point(0, 0));
			var offset:Number = 72;
           	globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(lp.x+offset, lp.y, s.getResourceName());
       	}
	
		
		
    		
		/*public function screenResize(stageX:int, stageY:int, scaleRatio:Number){
			this.x = stageX/2
			this.y = stageY/2;
		}*/
	}	
}
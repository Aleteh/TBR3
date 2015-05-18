//=====================================================================================================
// ResourcePanel.as
//====================================================================================================
package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;

	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Sprite;
	
	//copied from VotingPanel.as source
	import flash.display.*;
    import flash.filters.*;
    import flash.text.*;
    import scaleform.clik.events.*;
    import vcomponents.*;

	
	
	public class ResourcePanel extends MovieClip {
		
		public var gameAPI:Object;
		public var globals:Object;
		
		//more shameless copy paste
		private var _btnYes:VButton;
        private var _btnNo:VButton;
		
		private var _loc_2:VComponent;
		
		public function ResourcePanel() {
			// constructor code
		}
		
		//set initialise this instance's gameAPI
		public function setup(api:Object, globals:Object) {
			this.gameAPI = api;
			this.globals = globals;
			
			//this is our listener for the event, OnHeroLevelUp() is the handler
			this.gameAPI.SubscribeToGameEvent("cgm_player_materials_changed", this.materialsEvent);
	
			//listener for button clicks
			this.tradeButton.addEventListener(MouseEvent.CLICK, onTradeButtonClicked);
			this.glyphButton.addEventListener(MouseEvent.CLICK, onGlyphButtonClicked);
			
			trace("##Module Setup!");
		}
		
		public function setMaterials(number): void {
			materialsCount.text = number;			
			trace("##ResourcePanel Set Materials to "+materialsCount.text);
		}
		
		public function materialsEvent(args:Object) : void {
			trace("##Event Firing Detected")
			trace("##Data: "+args.player_ID+" - "+args.materials);
			if (globals.Players.GetLocalPlayer() == args.player_ID)
			{
				this.setMaterials(args.materials);
			}
		}
		
		public function onTradeButtonClicked(event:MouseEvent) {
			trace("##Giff Materials!");
			//var _loc_2:* = new VComponent("bg_overlayBox");
			_loc_2 = new VComponent("bg_overlayBox");
            _loc_2.width = 400;
            _loc_2.height = 800;
            addChild(_loc_2);
			
			var _loc_3:* = Utils.CreateLabel("Trade Materials", FontType.TextFont);
            var _loc_4:* = new TextFormat();
            _loc_4.size = 24;
            _loc_4.align = TextFormatAlign.CENTER;
            _loc_4.color = 1202459; //#12591b
            _loc_4.font = FontType.TextFont;
            _loc_3.setTextFormat(_loc_4);
            _loc_3.y = 30;
            _loc_3.width = 400;
            _loc_3.alpha = 0.9;
            _loc_3.filters = [new GlowFilter()];
            addChild(_loc_3);
			
            this._btnYes = new VButton("chrome_button_primary", "10");
            this._btnYes.x = 125 + 4;
            this._btnYes.y = 95 + 2;
            addChild(this._btnYes);
			
            this._btnNo = new VButton("chrome_button_normal", "CLOSE");
            this._btnNo.x = 275;
            this._btnNo.y = 95;
            addChild(this._btnNo);
			
			this._btnYes.addEventListener(ButtonEvent.CLICK, this._onClickYes);
            this._btnNo.addEventListener(ButtonEvent.CLICK, this._onClickNo);
         		
		}
		
		private function _onClickYes(event:ButtonEvent) : void
        {
            this.gameAPI.SendServerCommand("ChangeMaterials 10");
			trace("##YES");
            return;
        }// end function

        private function _onClickNo(event:ButtonEvent) : void
        {
            //this.gameAPI.SendServerCommand("dotahs_vote_no");
			trace("##NO");
            this._close();
            return;
        }// end function

        private function _close() : void
        {
            removeChild(this._loc_2);
			removeChild(this._btnNo);
			removeChild(this._btnYes);
            return;
        }
		
		public function onGlyphButtonClicked(event:MouseEvent) {
			this.gameAPI.SendServerCommand("StartTeleport");
			trace("##TELEPORT");
		}
		
		//onScreenResize
	}
	
}

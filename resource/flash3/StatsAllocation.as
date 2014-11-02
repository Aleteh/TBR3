package  {
	
	import flash.display.MovieClip;
	import ValveLib.*;
	import scaleform.clik.controls.Button;
	import scaleform.clik.events.ButtonEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class StatsAllocation extends MovieClip {
		public var gameAPI:Object;
        public var globals:Object;
        public var elementName:String;
		
		public var StatsAllocationBtn:Button;
		public var StatsAllocationSTRBtn:Button;
		public var StatsAllocationAGIBtn:Button;
		public var StatsAllocationINTBtn:Button;		
		
		public function StatsAllocation() {
			
		}
		
		public function onLoaded():void{
			
			visible = true
			this.StatsAllocationBtn.addEventListener(MouseEvent.CLICK, StatsAllocationStart);
			this.StatsAllocationSTRBtn.addEventListener(MouseEvent.CLICK, StatsAllocationSTR);
			this.StatsAllocationAGIBtn.addEventListener(MouseEvent.CLICK, StatsAllocationAGI);
			this.StatsAllocationINTBtn.addEventListener(MouseEvent.CLICK, StatsAllocationINT);
			trace("Custom UI loaded!");
		}
		
		public function StatsAllocationStart():void
		{
			trace("Allocate stats")
			/*if(StatsAllocationed)
			{	StatsAllocationed = false;`
				Globals.instance.GameInterface.SetConvar("dota_camera_lock", "0");
				this.StatsAllocationBtn.label = Globals.instance.GameInterface.Translate("#camera_lock_off");
				trace("Camera Unlocked")
			}*/
			
		}
		
		public function StatsAllocationSTR():void
		{
			trace("Allocate STR")
		}
		
		public function StatsAllocationAGI():void
		{
			trace("Allocate AGI")
			
		}
		
		public function StatsAllocationINT():void
		{
			trace("Allocate INT")
			
		}
		
		/*public function lockCamera():void
		{
			StatsAllocation = true;
			Globals.instance.GameInterface.SetConvar("dota_camera_lock", "1");
			this.StatsAllocationBtn.label = Globals.instance.GameInterface.Translate("#camera_lock_on");
			trace("Camera Locked")			
		}*/
			
		public function OnPlayerLevelUp(keyValues:Object):void
		{
			
		}
		
		public function onScreenSizeChanged():void{
            this.scaleX = (this.globals.resizeManager.ScreenWidth / 1920);
            this.scaleY = (this.globals.resizeManager.ScreenHeight / 1080);
            x = 0;
            y = 0;
            trace(("fofitemdraft::onScreenSizeChanged stageWidth/Height = " + stage.stageWidth), stage.stageHeight);
            trace(("  stage.width/height = " + stage.width), stage.height);
            trace(("  rm.screenWidth/height = " + this.globals.resizeManager.ScreenWidth), this.globals.resizeManager.ScreenHeight);
        }
	}
	
}
package  {
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	
	public class proTip extends MovieClip {
		private var proClass:Class;
		private var proBg;
		private var proTextField:TextField;
		
		public function proTip() {
			proClass = getDefinitionByName('bg_overlayBox') as Class;
			proBg = new proClass;
			
			this.addChild(proBg);
			proSetupText();
			
			this.visible = false;
		}
		
		private function proSetupText():void {
			proTextField = new TextField;
			proTextField.x = 10;
			proTextField.y = 5;
			proTextField.height = 0;
			proTextField.autoSize = "left";
			proTextField.multiline = false;
			proTextField.wordWrap = false;
			proTextField.background = false;
			proTextField.selectable = false;
			
			
			var styleObj:Object = new Object;
			styleObj.color = '#FFFFFF';
			styleObj.fontSize = 15;
			styleObj.fontFamily = '$TextFontBold';
			
			var style:StyleSheet = new StyleSheet();
			style.setStyle(".pro", styleObj);
			proTextField.styleSheet = style;
			
			this.addChild(proTextField);
		}
		
		public function kissAndTell(proX:Number, proY:Number, proText:String):void {
			this.x = proX;
			this.y = proY;
			
			proTextField.width = 0;
			proTextField.htmlText = "<span class='pro'>"+proText+"</span>";
			
			proBg.width = proTextField.width + 20;
			proBg.height = proTextField.height + 10;
			
			this.visible = true;
		}
		
		public function pleaseHideMeSenpai():void {
			this.visible = false;
		}
	}
	
}
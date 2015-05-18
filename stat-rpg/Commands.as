		CreateSave
			gives you the next available saveID
			preferably call that just as you feed it into SaveData


		public function debugButton1Func(args:Object) {
			globals.Loader_StatsCollectionRPG.movieClip.SaveData("##TESTMODID##", 0, "{'This is' : 'real Data'}", "{'This is' : 'Meta data'}");
		}
		public function debugButton2Func(args:Object) {
			globals.Loader_StatsCollectionRPG.movieClip.DeleteSave("##TESTMODID##", 0);
		}
		public function debugButton3Func(args:Object) {
			globals.Loader_StatsCollectionRPG.movieClip.GetSave("##TESTMODID##", 0, getSaveCallbackTest);
		}
		public function debugButton4Func(args:Object) {
			globals.Loader_StatsCollectionRPG.movieClip.GetList("##TESTMODID##", getListCallbackTest);
		}
		public function getSaveCallbackTest(jsonData:String) {
			trace("##OMGOMGOMG "+jsonData);
		}
		public function getListCallbackTest(jsonData:Object) {
			trace("##YAYYAYYAY "+jsonData);
		}
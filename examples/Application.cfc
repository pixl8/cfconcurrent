component{

	this.name = "cfconcurrentexamples";
	root = getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings[ "/cfconcurrent" ] = ExpandPath( root & "/../cfconcurrent" );


	function onApplicationStart(){
	}

	function onRequestStart(){
		if( structKeyExists(url, "reinit") ){
			applicationStop();
			onApplicationStop();

		}
	}

	function onApplicationStop(){
	}

}
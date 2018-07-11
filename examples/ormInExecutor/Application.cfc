component{

	this.name = "cfconcurrent_ormInExecutor";
	root = getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings[ "/cfconcurrent" ] = ExpandPath( root & "/../.." );

	//for ORM tests and examples
	this.ormEnabled = true;
	this.datasource = "cfartgallery";
	this.ormSettings = {flushAtRequestEnd = false, automanageSession = false, logsql = true};


	function onApplicationStart(){
		application.executorCompletionService = createObject("component", "cfconcurrent.ExecutorCompletionService").init("ormInExecutor", 0, 2);
		application.completionTask = createObject("component", "cfconcurrent.examples.ormInExecutor.model.CompletionTask");
		application.executorCompletionService.setCompletionQueueProcessTask( application.completionTask );
		application.executorCompletionService.start();
	}

	function onRequestStart(){
		if( structKeyExists(url, "stop") OR structKeyExists(url, "reinit") ){
			applicationStop();
			onApplicationStop();
		}

		if( structKeyExists(url, "reinit") ){
			location( "index.cfm", false );
		}
	}

	function onApplicationStop(){
		application.executorCompletionService.stop();
	}

}
component{

	this.name = "cfconcurrent_ScheduledThreadPoolExecutor";
	root = getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings[ "/cfconcurrent" ] = ExpandPath( root & "/../.." );


	function onApplicationStart(){
		application.executorService = createObject("component", "cfconcurrent.ScheduledThreadPoolExecutor")
			.init( serviceName = "ScheduledThreadPoolExecutorExample", maxConcurrent = 0 );
		application.executorService.setLoggingEnabled( true );
		application.executorService.start();

		//now schedule a runnable task to run every few seconds
		application.task1 = createObject("component", "SimpleRunnableTask").init( "task1" );
		application.executorService.scheduleAtFixedRate("task1", application.task1, 0, 2, application.executorService.getObjectFactory().SECONDS);
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
		application.executorService.stop();
	}

}
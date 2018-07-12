/**
 * Custom thread factory for thread pools allows
 * us to extend default Java Thread factory
 * by renaming threads to our own liking and
 * also wrap any runnables in our own proxy to set
 * common settings like Lucee fixes, etc. (see ThreadFactoryRunnableProxy)
 *
 */
component {

	public any function init( required string threadNamePattern, required any objectFactory ) {
		variables.threadNamePattern    = arguments.threadNamePattern;
		variables.defaultThreadFactory = CreateObject( "java", "java.util.concurrent.Executors" ).defaultThreadFactory();
		variables.objectFactory        = arguments.objectFactory;
	}

	public any function newThread( required any runnable ) {
		var proxy           = objectFactory.createThreadFactoryRunnableProxy( runnable );
		var theThread       = defaultThreadFactory.newThread( proxy );
		var threadName      = theThread.getName();
		var originalPattern = "^pool\-([0-9]+)\-thread\-([0-9]+)$";
		var poolNumber      = ReReplaceNoCase( threadName, originalPattern, "\1" );
		var threadNumber    = ReReplaceNoCase( threadName, originalPattern, "\2" );

		var newName = ReplaceNoCase( threadNamePattern, "${poolno}"  , poolNumber  , "all" );
		    newName = ReplaceNoCase( newName          , "${threadno}", threadNumber, "all" );

		theThread.setName( newName );

		return theThread;
	}

}
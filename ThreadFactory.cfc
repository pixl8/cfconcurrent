/**
 * Custom thread factory for thread pools allows
 * us to extend default Java Thread factory
 * by renaming threads to our own liking and
 * also wrap any runnables in our own proxy to set
 * common settings like Lucee fixes, etc. (see ThreadFactoryRunnableProxy)
 *
 */
component {

	public any function init( required string threadPoolName, required any objectFactory ) {
		variables.threadPoolName       = arguments.threadPoolName;
		variables.defaultThreadFactory = CreateObject( "java", "java.util.concurrent.Executors" ).defaultThreadFactory();
		variables.objectFactory        = arguments.objectFactory;
	}

	public any function newThread( required any runnable ) {
		var proxy      = objectFactory.createThreadFactoryRunnableProxy( runnable );
		var theThread  = defaultThreadFactory.newThread( proxy );
		var threadName = theThread.getName();

		theThread.setName( reReplaceNoCase( threadName, "^pool", threadPoolName ) );

		return theThread;
	}

}
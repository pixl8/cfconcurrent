component output="false" accessors="true"{

	property name="cfcDynamicProxy";

	callableInterfaces = ["java.util.concurrent.Callable"];
	runnableInterfaces = ["java.lang.Runnable"];
	threadFactoryInterfaces = ["java.util.concurrent.ThreadFactory"];
	timeUnit = createTimeUnit();

	//conveniences... we work a lot with timeunit so let's make it a bit easier
	this.nanoseconds = timeUnit.NANOSECONDS;
	this.microseconds = timeUnit.MICROSECONDS;
	this.milliseconds = timeUnit.MILLISECONDS;
	this.seconds = timeUnit.SECONDS;
	this.minutes = timeUnit.MINUTES;
	this.hours = timeUnit.HOURS;
	this.days = timeUnit.DAYS;

	public function init(){
		return this;
	}

	public function getProcessorCount(){
		return createObject("java", "java.lang.Runtime").getRuntime().availableProcessors();
	}

	public function createTimeUnit(){
		return createObject( "java", "java.util.concurrent.TimeUnit" );
	}

	public function createQueue( maxQueueSize, queueClass="java.util.concurrent.LinkedBlockingQueue" ){
		return createObject("java", queueClass).init( maxQueueSize );
	}

	public function createThreadPoolExecutor( maxConcurrent, workQueue, rejectionPolicy="DiscardPolicy", threadNamePattern="CFConcurrentPool-${poolno}-Thread-${threadno}" ){
		return createObject("java", "java.util.concurrent.ThreadPoolExecutor").init(
			maxConcurrent,
			maxConcurrent,
			0,
			timeUnit.SECONDS,
			workQueue,
			createThreadFactory( threadNamePattern ),
			createRejectionPolicyByName( rejectionPolicy )
		);
	}

	public function createThreadFactory( threadNamePattern ) {
		return CreateProxy( new ThreadFactory( arguments.threadNamePattern, this ), threadFactoryInterfaces );
	}

	public function createThreadFactoryRunnableProxy( required any runnable ) {
		return CreateProxy( new ThreadFactoryRunnableProxy( runnable ), runnableInterfaces );
	}

	public function createScheduledThreadPoolExecutor( maxConcurrent=1, rejectionPolicy="DiscardPolicy", threadNamePattern="CFConcurrentScheduledPool-${poolno}-Thread-${threadno}" ){
		return createObject("java", "java.util.concurrent.ScheduledThreadPoolExecutor").init(
			maxConcurrent,
			createThreadFactory( threadNamePattern ),
			createRejectionPolicyByName( rejectionPolicy )
		);
	}

	public function createCompletionService( executor, completionQueue ){
		return createObject("java", "java.util.concurrent.ExecutorCompletionService").init( executor, completionQueue );
	}

	public function createRejectionPolicyByName( name ){
		return createObject("java", "java.util.concurrent.ThreadPoolExecutor$#name#").init();
	}

	public function createDiscardPolicy(){
		return createRejectionPolicyByName("DiscardPolicy");
	}

	public function createDiscardOldestPolicy(){
		return createRejectionPolicyByName("DiscardOldestPolicy");
	}

	public function createAbortPolicy(){
		return createRejectionPolicyByName("AbortPolicy");
	}

	public function createCallerRunsPolicy(){
		return createRejectionPolicyByName("CallerRunsPolicy");
	}

	public function createSubmittableProxy( object, hostname=cgi.server_name ){
		if( isCallable( object ) ){
			if ( _isLucee5() ) {
				return createLuceeCallableProxy( object, hostname );
			}
			return createProxy( object, callableInterfaces );
		}
		if( isRunnable( object ) ){
			if ( _isLucee5() ) {
				return createLuceeRunnableProxy( object, hostname );
			}
			return createProxy( object, runnableInterfaces );
		}

		throw("Task must have either a call() or run() method", "TaskNotSubmittable");
	}

	public function createRunnableProxy( object, hostname=cgi.server_name ){
		ensureRunnableTask( object );
		if ( _isLucee5() ) {
			return createLuceeRunnableProxy( object, hostname );
		}
		return createProxy( object, runnableInterfaces );
	}

	public function createCallableProxy( object, hostname=cgi.server_name ){
		ensureCallableTask( object );
		if ( _isLucee5() ) {
			return createLuceeCallableProxy( object, hostname );
		}
		return createProxy( object, callableInterfaces );
	}

	public function createProxy( object, interfaces ){
		return createDynamicProxy( arguments.object, arguments.interfaces );
	}

	public function createLuceeRunnableProxy( object, string hostname=cgi.server_name ) {
		return CreateObject( "java", "org.pixl8.cfconcurrent.LuceeRunnable", _getLuceeLib() ).init(
			  arguments.object                         // runnableCfc
			, ExpandPath( "/" )                        // contextRoot
			, getPageContext().getApplicationContext() // appContext
			, arguments.hostName                       // host
		);
	}

	public function createLuceeCallableProxy( object, string hostname=cgi.server_name ) {
		return CreateObject( "java", "org.pixl8.cfconcurrent.LuceeCallable", _getLuceeLib() ).init(
			  arguments.object                         // runnableCfc
			, ExpandPath( "/" )                        // contextRoot
			, getPageContext().getApplicationContext() // appContext
			, arguments.hostName                       // host
		);
	}

	public function ensureRunnableTask( task ){
		if( NOT isRunnable( task ) ){
			throw("Task does not have a run() method", "TaskNotRunnable")
		}
	}

	public function ensureCallableTask( task ){
		if( NOT isCallable( task ) ){
			throw("Task does not have a call() method", "TaskNotCallable")
		}
	}

	public function isCallable( object ){
		return isObject( object ) AND structKeyExists( object, "call" );
	}

	public function isRunnable( object ){
		return isObject( object ) AND structKeyExists( object, "run" );
	}

// helpers
	private boolean function _isLucee5() {
		return StructKeyExists( server, "lucee" ) && Val( ListFirst( server.lucee.version ?: "", "." ) ) >= 5;
	}

	private array function _getLuceeLib() {
		return DirectoryList( GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/luceelib", false, "path", "*.jar" );
	}
}
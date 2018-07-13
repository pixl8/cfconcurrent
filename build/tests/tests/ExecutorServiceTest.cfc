component extends="testbox.system.BaseSpec"{

	function run(){
		describe( "Executor Service", function(){
			beforeEach( function(){
				service = new cfconcurrent.ExecutorService(serviceName="unittest", threadNamePattern="testpool-${poolno}-testthread-${threadno}");
				objectFactory = service.getObjectFactory();
				service.setLoggingEnabled( true );
				service.start();
			} );

			afterEach( function(){
				service.stop(1);
			} );

			it( "should default max concurrent threads to CPU count + 1", function(){
				var cpus = service.getProcessorCount();
				expect( service.getMaxConcurrent() ).toBe(  cpus + 1  );
			} );

			it( "should return a future when submitting a callable", function(){
				var task = new fixture.SimpleCallableTask(1);
				var future = service.submit( task );
				var result = future.get();

				expect( structIsEmpty( result.error ) ).toBeTrue();
				expect( result.id ).toBe( 1 );
				expect( future.isDone() ).toBeTrue();
			} );

			it( "should return a runnable future when submitting a runnable", function(){
				var task = new fixture.SimpleRunnableTask(1);
				var future = service.submit( task );
				var result = future.get();

				expect( IsNull(result) ).toBeTrue();
				expect( future.isDone() ).toBeTrue();
			} );

			it( "should return an array of futures when using invokeAll()", function(){
				var tasks = [];
				for( var i = 1; i LTE 10; i++ ){
					ArrayAppend( tasks, new fixture.SimpleCallableTask(i) );
				}

				var results = service.invokeAll( tasks );

				expect( results ).toBeArray();
				for( var i = 1; i LTE 10; i++ ){
					var future = results[i];
					expect( future.isDone() ).toBeTrue();
					var result = future.get();
					expect( result.id ).toBe( i );
				}
			} );

			it( "should honor timeouts when invoking all", function(){
				var tasks = [];

				//create tasks that will sleep for 50 milliseconds
				for( var i = 1; i LTE 10; i++ ){
					arrayAppend( tasks, new fixture.SimpleCallableTask(i, 50) );
				}

				//invokeAll with a 20-ms timeout
				var results = service.invokeAll( tasks, 20, objectFactory.MILLISECONDS );

				for( future in results ){
					if( !future.isCancelled() ){
						fail("Task should have been cancelled b/c it did not complete by the timeout");
					}
				}
			} );

			it( "should return a single result from invokeAny()", function(){
				var tasks = [];
				for( var i = 1; i LTE 10; i++ ){
					arrayAppend( tasks, new fixture.SimpleCallableTask(i) );
				}

				var result = service.invokeAny( tasks );
				expect( result.id >= 1 && result.id <= 10 ).toBe( true ); //the order in which tasks are run is indeterminate
			} );

			it( "should honor timeout when using invokeAny()", function(){
				expect( function(){
					var tasks = [];
					//create tasks that will sleep for 50 milliseconds
					for( var i = 1; i LTE 10; i++ ){
						arrayAppend( tasks, new fixture.SimpleCallableTask(i, 50) );
					}

					//invokeAny with a 20-ms timeout
					var results = service.invokeAny( tasks, 20, objectFactory.MILLISECONDS );

				} ).toThrow( "java.util.concurrent.TimeoutException" );
			} );

			it( "should execute task", function(){
				var task = new fixture.SimpleRunnableTask(1);
				//guard
				expect( task.getResults().runCount ).toBe( 0 );

				service.execute( task );
				sleep(1000);

				expect( task.getResults().runCount ).toBe( 1 );
			} );

			it( "should allow customization of thread names", function(){
				var task = new fixture.ThreadNameTestTask();
				var future = service.submit( task );
				var result = future.get();

				expect( structIsEmpty( result.error ) ).toBeTrue();
				expect( ReFindNoCase( "testpool\-[0-9]+-testthread\-[0-9]+", result.threadName ) > 0 ).toBeTrue();
				expect( future.isDone() ).toBeTrue();
			} );
		} );
	}
}
component extends="testbox.system.BaseSpec"{

	function run(){
		describe( "Executor Service", function(){
			beforeEach( function(){
				service = new cfconcurrent.ScheduledThreadPoolExecutor( serviceName="unittest" );
				service.setLoggingEnabled( true );
				objectFactory = service.getObjectFactory();
			} );

			afterEach( function(){
				service.stop();
			} );

			it( "should default max concurrent threads to CPU count + 1", function(){
				var cpus = service.getProcessorCount();
				expect( service.getMaxConcurrent() ).toBe(  cpus + 1  );
			} );

			it( "should add executors to storage once started", function(){
				service.start();
				expect( service.isStarted() ).toBeTrue();

				var storage = service.getThisStorageScope();

				expect( StructCount( storage ) ).toBe( 1 );
			} );

			it( "should clear storage when stopped", function(){
				service.start();
				service.stop();

				expect( StructCount( service.getThisStorageScope() ) ).toBe( 0 );
			} );

			it( "should schedule tasks at a fixed rate", function(){
				service.start();
				var task1 = new fixture.SimpleRunnableTask("task1");
				var task2 = new fixture.SimpleRunnableTask("task2");
				var future1 = service.scheduleAtFixedRate("task1", task1, 0, 100, objectFactory.MILLISECONDS);
				var future2 = service.scheduleAtFixedRate("task2", task2, 1, 100, objectFactory.MILLISECONDS);

				sleep(500);
				var task1Results = task1.getResults();
				var task2Results = task2.getResults();
				expect( task1Results.runCount >= 5 and task1Results.runCount <= 10 ).toBeTrue();
				expect( task2Results.runCount >= 5 and task2Results.runCount <= 10 ).toBeTrue();

				sleep(200);
				var queue = service.getScheduledExecutor().getQueue();
				expect( StructCount( service.getStoredTasks() ) ).toBe( 2 );

				var cancelled1 = service.cancelTask( "task1" );
				var cancelled2 = service.cancelTask( "task2" );

				expect( cancelled1.future.isCancelled() ).toBeTrue();
				expect( cancelled2.future.isCancelled() ).toBeTrue();

				expect( ArrayLen( queue.toArray() ) ).toBe( 0 );
				expect( StructCount( service.getStoredTasks() ) ).toBe( 0 );
			} );

			it( title="should schedule tasks with the hostname 'lucee'", skip=_notLucee5OrGreater, body=function(){
				service.start();
				var task1 = new fixture.SimpleRunnableTask("task1");
				var future1 = service.scheduleAtFixedRate("task1", task1, 0, 100, objectFactory.MILLISECONDS );

				sleep(500);
				var task1Results = task1.getResults();
				expect( task1Results.hostname ).toBe( "lucee" );
			} );
		} );
	}

	private boolean function _notLucee5OrGreater() {
		var isLucee5OrGreater = StructKeyExists( server, "lucee" ) && Val( ListFirst( server.lucee.version ?: "", "." ) ) >= 5;

		return !isLucee5OrGreater;
	}
}
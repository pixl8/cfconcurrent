component extends="testbox.system.BaseSpec"{

	function run(){
		describe( "Abstract Executor Service", function(){
			beforeEach( function(){
				service = new cfconcurrent.AbstractExecutorService("unittest");
			} );

			afterEach( function(){
				service.stop();
			} );

			it( "should be stopped when initialized", function(){
				expect( service.isStopped() ).toBeTrue();
			} );

			it( "should be safe to call stop() multiple times", function(){
				service.start();

				service.stop();
				service.stop();
				service.stop();

				expect( service.isStopped() ).toBeTrue();
			} );

			it( "should report that it has started when started", function(){
				service.start();

				expect( service.isStarted() ).toBeTrue();
			} );

			it( "should report that it has paused when paused", function(){
				service.pause();

				expect( service.isPaused() ).toBeTrue();
			} );

			it( "should return a struct when calling getStorageScope()", function(){
				var scope = service.getThisStorageScope();

				expect( scope ).toBeStruct();
			} );

			it( "should return positive number for processor count", function(){
				var count = service.getProcessorCount();

				expect( count ).toBeGte( 1 );
			} );
		} );
	}
}
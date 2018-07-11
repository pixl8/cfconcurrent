component extends="testbox.system.BaseSpec"{

	function run(){
		describe( "Executor Completion Service", function(){
			beforeEach( function(){
				service = new cfconcurrent.ExecutorCompletionService(serviceName="unittest", completionQueueProcessFrequency=1);
				service.setLoggingEnabled( true );
				completionTask = new fixture.VariablesCollectingTaskFixture();
				service.setCompletionQueueProcessTask( completionTask );
			} );

			afterEach( function(){
				service.stop();
			} );

			it( "should default CPU max concurrent threads to CPU count + one", function(){
				var cpus = service.getProcessorCount();
				expect( service.getMaxConcurrent() ).toBe( cpus + 1 );
			} );

			it( "should add executors to storage when started", function(){
				service.start();
				expect( service.isStarted() ).toBe( true );

				var storage = service.getThisStorageScope();
				expect( StructCount( storage ) ).toBe( 2 );

			} );

			it( "should clear storage when stopped", function(){
				service.start();
				service.stop();

				var storage = service.getThisStorageScope();
				expect( StructCount( storage ) ).toBe( 0 );
			} );

			it( "should publish finished tasks", function(){
				service.start();

				var task1 = new fixture.SimpleCallableTask("task1");
				var task2 = new fixture.SimpleCallableTask("task2");
				var future1 = service.submit(task1);
				var future2 = service.submit(task2);

				//we know the unit test is set to publish every second
				sleep(1100);

				expect( arrayLen(completionTask.getAllCollected() ) ).toBe( 2 );
			} );

			it( title="should allow entitySave() to work on entity passed into task in executor", skip=true, body=function() {
				ormReload();
				entityLoadByPk("Artist", 1);
				service.start();

				var task1 = new fixture.SimpleCallableORMTask(1);
				var future1 = service.submit(task1);
				sleep(1100);

				var result = future1.get();

				expect( result.entity.getThePassword() ).toBe( result.password );
				expect( result.saved ).toBeTrue();
				expect( structIsEmpty(result.error) ).toBeTrue();
			} );

			it( "should allow createObject to work in executors", function(){
				service.start();
				var task1 = new fixture.ObjectCreatingCallableTask(1);
				var future1 = service.submit(task1);
				sleep(1100);

				var result = future1.get();
				debug(result);

				expect( isSimpleValue(result.anObject) ).toBeFalse();
			} );
		} );
	}
}
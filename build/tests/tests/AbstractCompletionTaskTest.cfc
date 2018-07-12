component extends="testbox.system.BaseSpec"{

	function run(){
		describe( "Abstract Completion Task", function(){
			beforeEach( function(){
				executorCompletionService = new cfconcurrent.ExecutorCompletionService("unittest");
				executorCompletionService.start();

		 		javaCompletionService = executorCompletionService.getExecutorCompletionService();
				completionTask = new fixture.VariablesCollectingTaskFixture( javaCompletionService );
			} );

			afterEach( function(){
				executorCompletionService.stop();
			} );

			it( "should poll completed tasks", function(){
				var task1 = new fixture.SimpleCallableTask("task1");
				var task2 = new fixture.SimpleCallableTask("task2");
				var factory = executorCompletionService.getObjectFactory();

				var proxy1 = factory.createSubmittableProxy(task1);
				var proxy2 = factory.createSubmittableProxy(task2);

				javaCompletionService.submit(proxy1);
				javaCompletionService.submit(proxy2);

				sleep( 1000 );

				completionTask.run();

				expect( ArrayLen( completionTask.getAllCollected() ) ).toBe( 2 );
			} );

			it( "should capture the last error", function(){
				var task1 = new fixture.ErrorThrowingTask("task1");
				var factory = executorCompletionService.getObjectFactory();
				var proxy1 = factory.createSubmittableProxy(task1);
				javaCompletionService.submit(proxy1);
				sleep(1000);
				completionTask.run();
				sleep(1000);

				var lastError = completionTask.getLastError();
				expect( FindNoCase( "intentional error", lastError.message ) ).toBeTrue();
			} );
		} );
	}

}
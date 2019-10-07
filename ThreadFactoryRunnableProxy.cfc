component {

	public any function init( runnable ) {
		variables.runnable        = arguments.runnable;
		variables.oneHundredYears = ( 60 * 60 * 24 * 365 * 100 );
	}

	public any function run() {
		cfsetting( requesttimeout=oneHundredYears );

		runnable.run();
	}

}
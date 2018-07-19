component {

	public any function init( runnable ) {
		variables.runnable        = arguments.runnable;
		variables.isLucee         = StructKeyExists( server, "lucee" );
		variables.oneHundredYears = ( 60 * 60 * 24 * 365 * 100 );

		if ( isLucee ) {
			variables.appContext = getPageContext().getApplicationContext();
		}
	}

	public any function run() {
		if ( isLucee ) {
			getPageContext().setApplicationContext( variables.appContext );
		}

		cfsetting( requesttimeout=oneHundredYears );

		runnable.run();
	}

}
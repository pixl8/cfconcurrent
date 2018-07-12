component {

	public any function init( runnable ) {
		variables.runnable       = arguments.runnable;
		variables.isLucee        = StructKeyExists( server, "lucee" );
		variables.requesttimeout = ( 60 * 60 * 24 * 365 * 100 ); // one hundred years

		// we have trouble with losing various mappings set with this.mappings
		// store them here then restore them when we run
		if ( isLucee ) {
			variables.mappings = getApplicationSettings().mappings;
		}
	}

	public any function run() {
		// set a really high request timeout for
		// all threads run here. Avoids Lucee (and potentially ACF)
		// trying to kill thread pool threads which it doesn't own
		// and can't kill
		cfsetting( requesttimeout=requesttimeout );

		if ( isLucee ) {
			cfapplication( action="update", mappings=mappings );
		}

		runnable.run();
	}

}
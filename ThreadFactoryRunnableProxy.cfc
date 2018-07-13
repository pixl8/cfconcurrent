component {

	public any function init( runnable ) {
		variables.runnable        = arguments.runnable;
		variables.isLucee         = StructKeyExists( server, "lucee" );
		variables.oneHundredYears = ( 60 * 60 * 24 * 365 * 100 );

		if ( isLucee ) {
			variables.pc = _cloneLuceePageContext();
		}
	}

	public any function run() {
		if ( isLucee ) {
			pc.copyStateTo( getPageContext() );
		}

		cfsetting( requesttimeout=oneHundredYears );

		runnable.run();
	}

	private any function _cloneLuceePageContext() {
		var threadUtil = CreateObject( "java", "lucee.runtime.thread.ThreadUtil" );
		var os         = CreateObject( "java", "java.io.ByteArrayOutputStream" ).init();

		return threadUtil.clonePageContext(
			  getPageContext() // pageContext
			, os               // output stream
			, true             // stateless
			, false            // register PC
			, false            // is child
		);
	}

}
<cfparam name="url.reporter" default="simple" />
<cfscript>
	testbox = new testbox.system.TestBox( options={}, reporter=url.reporter, directory={
		  recurse  = true
		, mapping  = "tests"
		, filter   = function( required path ){ return true; }
	} );

	results = Trim( testbox.run() );

	content reset=true; WriteOutput( results ); abort;
</cfscript>
<cfparam name="url.reporter" default="simple" />
<cfscript>
	testbox = new testbox.system.TestBox( options={}, reporter=url.reporter, directory={
		  recurse  = true
		, mapping  = "tests"
		, filter   = function( required path ){ return true; }
	} );

	results = Trim( testbox.run() );

</cfscript>
<cfcontent reset=true />
<cfoutput>#results#</cfoutput>
component{

	this.name = "cfconcurrent_testsuite";

	root = getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings[ "/cfconcurrent" ] = ExpandPath( root & "/../../cfconcurrent" );
	this.mappings[ "/fixture" ]      = ExpandPath( root & "/fixture" );
}


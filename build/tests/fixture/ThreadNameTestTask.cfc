component{

	results = { created = now(), createTS = getTickCount(), error={} };

	function init(){
		return this;
	}

	function call(){
		try{
			results.threadName = createObject( "java", "java.lang.Thread" ).currentThread().getName();
		} catch( any e ){
			writeLog("OH NOES!!!!! #e.message#; #e.detail#");
			results.error = e;
		}
		results.endTS = getTickCount();

		return results;
	}

}
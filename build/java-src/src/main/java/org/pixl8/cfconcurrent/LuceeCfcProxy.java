package org.pixl8.cfconcurrent;

import java.io.File;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;

import lucee.loader.engine.*;
import lucee.runtime.exp.PageException;
import lucee.runtime.Component;
import lucee.runtime.PageContext;
import lucee.runtime.listener.ApplicationContext;
import java.util.HashMap;

public class LuceeCfcProxy {
	private CFMLEngine         lucee;
	private Component          proxiedCfc;
	private File               contextRoot;
	private ApplicationContext appContext;
	private Long               oneHundredYearsInMs;
	private String             host;

// CONSTRUCTOR
	public LuceeCfcProxy( Component proxiedCfc, String contextRoot, ApplicationContext appContext, String host ) throws PageException, ServletException {
		this.lucee               = CFMLEngineFactory.getInstance();
		this.proxiedCfc          = proxiedCfc;
		this.contextRoot         = new File( contextRoot );
		this.appContext          = appContext;
		this.oneHundredYearsInMs = Long.valueOf( 1000 * 60 * 60 * 24 * 356 * 100 );
		this.host                = host;
	}

// PUBLIC METHODS
	public Object callMethod( String methodName ) throws PageException, ServletException  {
		return callMethod( methodName, new Object[0] );
	}

	public Object callMethod( String methodName, Object[] args ) throws PageException, ServletException {
		return proxiedCfc.call( _getPageContext(), methodName, args );
	}

// PRIVATE HELPERS
	private PageContext _getPageContext() throws ServletException {
		javax.servlet.http.Cookie[] cookies = new Cookie[]{};

		PageContext pc = lucee.createPageContext(
			  contextRoot
			, host              // host
			, "/"                 // script name
			, ""                  // query string
			, cookies		      // cookies
			, null                // headers
			, new HashMap()       // parameters
			, new HashMap()       // attributes
			, System.out          // response stream where the output is written to
			, oneHundredYearsInMs // timeout for the simulated request in milli seconds
			, true                // register the pc to the thread
		);

		pc.setApplicationContext( appContext );

		return pc;
	}
}

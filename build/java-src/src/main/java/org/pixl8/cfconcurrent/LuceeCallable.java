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
import java.util.concurrent.Callable;

public class LuceeCallable implements Callable {
	private CFMLEngine         lucee;
	private Component          callableCfc;
	private File               contextRoot;
	private Long               timeout;
	private ApplicationContext appContext;

// CONSTRUCTOR
	public LuceeCallable(
		  Component          callableCfc
		, String             contextRoot
		, ApplicationContext appContext
		, Long               timeout
	) throws PageException, ServletException {
		this.lucee       = CFMLEngineFactory.getInstance();
		this.callableCfc = callableCfc;
		this.contextRoot = new File( contextRoot );
		this.timeout     = timeout;
		this.appContext  = appContext;
	}

// THE RUNNABLE BIT
	@Override
	public Object call() throws Exception {
		return callableCfc.call( _getPageContext(), "call", new Object[0] );
	}

// PRIVATE HELPERS
	private PageContext _getPageContext() throws ServletException {
		PageContext pc = lucee.getThreadPageContext();

		if ( pc != null ) {
			return pc;
		}

		javax.servlet.http.Cookie[] cookies = new Cookie[]{};

		pc = lucee.createPageContext(
			  contextRoot
			, "localhost"    // host
			, "/"            // script name
			, ""             // query string
			, cookies		 // cookies
			, null           // headers
			, new HashMap()  // parameters
			, new HashMap()  // attributes
			, System.out     // response stream where the output is written to
			, timeout        // timeout for the simulated request in milli seconds
			, true           // register the pc to the thread
		);

		pc.setApplicationContext( appContext );

		return pc;
	}
}

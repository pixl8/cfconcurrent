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

public class LuceeRunnable implements Runnable {
	private CFMLEngine         lucee;
	private Component          runnableCfc;
	private File               contextRoot;
	private Long               timeout;
	private ApplicationContext appContext;

// CONSTRUCTOR
	public LuceeRunnable(
		  Component          runnableCfc
		, String             contextRoot
		, ApplicationContext appContext
		, Long               timeout
	) throws PageException, ServletException {
		this.lucee       = CFMLEngineFactory.getInstance();
		this.runnableCfc = runnableCfc;
		this.contextRoot = new File( contextRoot );
		this.timeout     = timeout;
		this.appContext  = appContext;
	}

// THE RUNNABLE BIT
	@Override
	public void run() {
		try {
			runnableCfc.call( _getPageContext(), "run", new Object[0] );
		} catch( PageException e ) {
			e.printStackTrace();
		} catch( ServletException e ) {
			e.printStackTrace();
		}
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

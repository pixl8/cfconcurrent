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

// CONSTRUCTOR
	public LuceeCfcProxy( Component proxiedCfc ) throws PageException, ServletException {
		this.lucee      = CFMLEngineFactory.getInstance();
		this.proxiedCfc = proxiedCfc;
	}

// PUBLIC METHODS
	public Object callMethod( String methodName ) throws PageException, ServletException  {
		return callMethod( methodName, new Object[0] );
	}

	public Object callMethod( String methodName, Object[] args ) throws PageException, ServletException {
		return proxiedCfc.call( lucee.getThreadPageContext(), methodName, args );
	}
}

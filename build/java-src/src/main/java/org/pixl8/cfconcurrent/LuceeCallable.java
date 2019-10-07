package org.pixl8.cfconcurrent;

import javax.servlet.ServletException;
import lucee.runtime.exp.PageException;
import lucee.runtime.Component;
import lucee.runtime.listener.ApplicationContext;
import java.util.concurrent.Callable;

public class LuceeCallable implements Callable {
	private LuceeCfcProxy proxy;

// CONSTRUCTOR
	public LuceeCallable( Component callableCfc, String contextRoot, ApplicationContext appContext ) throws PageException, ServletException {
		this.proxy = new LuceeCfcProxy( callableCfc, contextRoot, appContext );
	}

// THE RUNNABLE BIT
	@Override
	public Object call() throws Exception {
		return proxy.callMethod( "call" );
	}

}

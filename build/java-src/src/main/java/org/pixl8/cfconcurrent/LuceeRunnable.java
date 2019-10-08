package org.pixl8.cfconcurrent;

import javax.servlet.ServletException;
import lucee.runtime.exp.PageException;
import lucee.runtime.Component;
import lucee.runtime.listener.ApplicationContext;

public class LuceeRunnable implements Runnable {
	private LuceeCfcProxy proxy;

// CONSTRUCTOR
	public LuceeRunnable( Component runnableCfc, String contextRoot, ApplicationContext appContext, String host ) throws PageException, ServletException {
		this.proxy = new LuceeCfcProxy( runnableCfc, contextRoot, appContext, host );
	}

// THE RUNNABLE BIT
	@Override
	public void run() {
		try {
			proxy.callMethod( "run" );
		} catch( PageException e ) {
			e.printStackTrace();
		} catch( ServletException e ) {
			e.printStackTrace();
		}
	}
}

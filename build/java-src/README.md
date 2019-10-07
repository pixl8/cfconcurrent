# Lucee Runnable Helper

This package provides a helper Java object to use components as Java runnables.

## Why not use CreateDynamicProxy()?

The purpose of `CreateDynamicProxy()` is allow cfc's to be used as instances of Java interfaces (e.g. a runnable). However, there are issues with this due to things like the Lucee page context and scope sharing.

This package allows you to run java threads that run CF code in the context of your application, without holding on to the page contexts of the request threads that start them.

## Building the jars

Ensure you have maven installed and then run: 

* `mvn package` will build the jars which can then be found in the `./artifacts` directory.
* `mvn clean` will remove all temporary files and built dist files.
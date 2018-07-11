Welcome to CFConcurent
======================

[![Build Status](https://travis-ci.org/pixl8/cfconcurrent.svg?branch=stable "Stable")](https://travis-ci.org/pixl8/cfconcurrent)

CFConcurrent simplifies the use of the Java Concurrency Framework
([java tutorial](http://docs.oracle.com/javase/tutorial/essential/concurrency/executors.html) | [javadoc](http://docs.oracle.com/javase/7/docs/api/java/util/concurrent/package-summary.html))
in ColdFusion applications. 

CFConcurrent runs on **CF10+** and **Lucee 4.5.5**.

### THIS IS A FORK

This is a fork of Marc Esher's original and awesome library found here: [https://github.com/marcesher/cfconcurrent](https://github.com/marcesher/cfconcurrent). All credits for the code and hard work go to Marc. The reason for this fork are:

* The original repo hasn't been updated in 5 years as of 2018 and we believe Marc is busy on other things other than CFML
* We wanted to include this library in our Projects and wanted a "modern" way to include it using Forgebox packages
* We wanted to allow development to continue

We have, of course, reached out to Marc who sent us his blessing via tweet:

> Have at it! Good luck and Godspeed.

### Warnings

**ColdFusion 9**: A user recently discovered that a massive memory leak exists when running this on CF9. Therefore, **it is not safe to use this library on Adobe ColdFusion 9**. The problem is not in the library but in the interaction between Java executors and ColdFusion. I will attempt to work with Adobe to identify a fix.  ColdFusion 10 is unaffected and behaves as expected.

**LUCEE 5**: As of Lucee 5.2.7, CFConcurrent does not work due to the Lucee bug [LDEV-1778](https://luceeserver.atlassian.net/browse/LDEV-1778). When this is resolved, CFConcurrent should work perfectly with Lucee 5.


# Preamble

Although CFThread is suitable for management-free fire-and-forget concurrency, robust production applications
require higher-level abstractions and a greater degree of control.
The Java Concurrency Framework (JCF) provides such improvements, and you can take advantage of it using **100% CFML**.

You create CFCs that act as "tasks" that return results.
You submit those tasks to the JCF for execution.
You can then retrieve the execution results immediately when they are available,
or you can create a periodic "polling" task which processes the completed results.

In addition, you can easily create cancelable, pausable scheduled tasks directly in your code (think: heartbeats, daemons),
freeing you from the 1-minute limitation of ColdFusion's scheduled task implementation.

CFConcurrent's goals are:

* Simplify Java object and proxy creation
* Expose common patterns as generic services
* Expose extensible base components
* Do not over-reach
* Limit protectionist tendencies

CFConcurrent is not a "wrapper" library, nor does it hide the Java Concurrency Framework from you.

Why?
----

I started writing concurrent programs in Java in 2004. This library represents what I wish I had in ColdFusion since learning to write concurrent programs.

For CF developers, Concurrency trends thusly: 1) Lob it into CFThread and hope it works. 2) OMG it's hard to do correctly. Let's eat cake. 3) Spend an inordinate amount of time with locks, app and server-scoped based data sharing schemes, and brittle thread-cancelling mechanisms.

I want this library to expose safe, correct concurrency abstractions that enable high-quality concurrent programming in ColdFusion applications.

Usage
--------

CFConcurrent ships with running examples and a suite of tests. Docs are in the wiki: https://github.com/pixl8/cfconcurrent/wiki. To run the examples, open up a web browser.

Installation
------------

Either:

```box install cfconcurrent```

Or, download/clone the repository directly. 

You may need to create a `/cfconcurrent` mapping if the installation directory is not directly beneath your webroot.


Gratitude
---------

CFConcurrent owes a great deal to [Mark Mandel](http://www.compoundtheory.com/) and JavaLoader. While CFConcurrent uses native Java proxy object creation on CF10, it requires JavaLoader on CF9. This project would not be possible today without JavaLoader.

History
-------

Doug Lea began `util.concurrent` in 1998, just a few years after the release of both Java and CF version 1. In 2004, with Java 5, `util.concurrent` was brought into the JDK as an official package, named `java.util.concurrent`. Thus, 3 years before ColdFusion received multithreading capabilities via CFThread (in CF8), Java provided a vastly superior approach to concurrency. Unfortunately, CF developers could not take advantage of java.util.concurrent because of the inability to pass ColdFusion Component (CFC) instances to a Java library.

This changed in 2011, when Mark Mandel tweaked the Java proxy object creation facility available in JavaLoader to enable CFC instances to be passed to invocation methods in the Java concurrency framework. With this ability, "concurrency as it should be" is now possible in ColdFusion. 

In 2018, Pixl8 have forked this repository in order to help maintain it and better package it for applications that work with ForgeBox / CommandBox.


Support or Contact
------------------

Post issues to https://github.com/pixl8/cfconcurrent/issues. 
Pull requests should ideally have accompanying tests (see `build/tests`).

License
--------

CFConcurrent is published under the MIT license.

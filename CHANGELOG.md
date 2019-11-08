# Changelog

## 2.1.3

* Add ability for Lucee 5 or greater to specify a hostname that will be set for any runnable or callable.

## 2.1.2

* Always use cgi.server_name when setting host for Lucee runnable and callables (not cgi.host_name)

## 2.1.1

* Make cgi.host_name for any runnable/callable Lucee threads match the original thread's hostname

## 2.1.0

* Update README
* Only run our new proxy on Lucee 5
* No longer need to pass timeout to lucee proxy
* Refactor to reduce duplication and simplify calling slightly
* Ensure Lucee callable/runnable proxies are used when getting a 'submittable' proxy
* Do not catch errors when running java callables - calling code is responsible for that
* Remove examples from the built version
* Add java build for safe callable and runnable proxies for Lucee
* Add Lucee 5 into list of engines to run tests against

## 2.0.5

* Simpler and more reliable method to ensure application context is available to threads started within cfconcurrent

## 2.0.4

* Remove no longer used files

## 2.0.3

* #1 release cloned page context once we are done with it to prevent thread reference issues

## 2.0.2

* Bump build number!

## 2.0.1

* Add ACF2018 to the test suite :)
* Add test case for custom naming of threads in the thread pool
* #4 Clone page context from original thread and copy its state into new threads' page contexts
* Make test pass more reliably on slower machines
* #1 change thread name customization from being just a pool name to a pattern used to construct the thread name
* Add missing thread name var
* Fix the cfinclude tag to be engine compatiable and look to the right helper cfm :)
* Separate out Lucee specific syntax into a separate cfm only included when running on Lucee
* Ignore generated log directories from Adobe CF engine
* Remove JavaLoader. As CFCOncurrent works with ACF10+ and not 9 - JL not required.
* Add a custom thread factory to allow us to customize thread names + create global work arounds for engine issues - i.e. stop requests timeouts from kill thread pool threads
* Ensure application.applicationName is not used when not available

## 1.x.x

* Initial import from Mark Mandel's project
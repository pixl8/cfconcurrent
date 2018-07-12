<!---
	Included in a separate file here because the ACF
	compiler chokes if including this code directly
	in a CFC (even if never run). Updates
	Lucee mappings with a mappings struct. A required
	work around for mappings going missing inside
	thread pool threads.
--->
<cfapplication action="update" mappings="#mappings#"/>
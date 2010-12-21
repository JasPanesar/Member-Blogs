<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<cffunction name="onGlobalRequestStart" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<!--- TODO: Auto-Generated method stub --->
	</cffunction>
	
	<cffunction name="onSiteRequestStart" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<cfset onGlobalRequestStart(arguments.event) />
	</cffunction>
	
	<cffunction name="onAdminModuleNav" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<!--- TODO: Auto-Generated method stub --->
	</cffunction>
	
	<cffunction name="onAddMemberBlogRequest" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<!--- TODO: Write the codez! --->
	</cffunction>

</cfcomponent>
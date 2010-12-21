<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<cffunction name="onGlobalRequestStart" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<cfif structKeyExists(session,'siteid') && !structKeyExists(session,'memberblogs')>
			<cfset initSettings() />
		</cfif>
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
	
	<cffunction name="initSettings" access="private" returntype="void" output="false">
		<cfset var local = {} />
		<cfset local['settings'] = {} />
		<cfset local.settings['useModeration'] = true />
		<cfset local.settings['requireLogin'] = true />
		<cfset local.settings['allowEdit'] = true />
		<cfset local.settings['moderateEdits'] = false />
		
		<cfif fileExists(expandPath('.') & '/' & hash(session.siteid) & '.cfm')>
			<cffile action="read" file="#expandPath('.')#/#hash(session.siteid)#.cfm" variable="local.settingsFile" />
			<cfset local.settings = deserializejson(local.settingsFile) />
			<cftry>
				<cfcatch><!--- We do nothing for now ---></cfcatch>
			</cftry>
		<cfelse>
			<cffile action="write" file="#expandPath('.')#/#hash(session.siteid)#.cfm" output="#serializejson(local.settings)#" />
		</cfif>
		
		<cfset session.memberblogs = local.settings />
	</cffunction>

</cfcomponent>
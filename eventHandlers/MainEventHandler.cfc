<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<cffunction name="onApplicationLoad" access="public" returntype="void" output="false">
		<cfif structKeyExists(session,'memberblogs')>
			<cfset structDelete(session,'memberblogs') />
		</cfif>
	</cffunction>
	
	<cffunction name="onGlobalRequestStart" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<cfset var local = {} />
		<cfif structKeyExists(session,'siteid')>
		<cfset local.key = hash(session.siteid) />
			<cfif !structKeyExists(variables,local.key)>
				<cfset initSettings() />
			</cfif>
			<cfset arguments.event.setValue(local.key, variables[local.key]) />
		</cfif>
	</cffunction>
	
	<cffunction name="onSiteRequestStart" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<cfset onGlobalRequestStart(arguments.event) />
	</cffunction>
	
	<cffunction name="onAdminModuleNav" access="public" returntype="string" output="false">
		<cfargument name="event" />
		<cfreturn '<li><a href="#variables.configBean.getContext()#/plugins/#variables.pluginConfig.getDirectory()#/">Member Blogs</a></li>' />
	</cffunction>
	
	<cffunction name="onRetrieveMBSettings" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<cfset var local = {} />
		<cfset local.key = hash(session.siteid) />
		<cfset arguments.event.setValue(local.key, variables[local.key]) />
	</cffunction>
	
	<cffunction name="onAddMemberBlogRequest" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<!--- TODO: Write the codez! --->
	</cffunction>
	
	<cffunction name="onSaveMBPluginSettings" access="public" returntype="void" output="false">
		<cfargument name="event" />
		<cfset var local = {} />
		<cfset local.key = hash(session.siteid) />
		<cfif isValid("Struct",event.getValue(local.key))>
			<cfset initSettings(event.getValue(local.key)) />
		</cfif>
		<cfset arguments.event.setValue(local.key, variables[local.key]) />
	</cffunction>
	
	<cffunction name="initSettings" access="private" returntype="void" output="false">
		<cfargument name="settings" type="struct" required="false" default="#StructNew()#" />
		
		<cfset var local = {} />
		<cfset local.key = hash(session.siteid) />
		<cfset local.filePath = expandPath(variables.configBean.getContext() & '/plugins/' & variables.pluginConfig.getDirectory() & '/configFiles') />
		<cfset local.fileName = local.key & '.cfm' />
		<cfset local.fullPath = local.filePath & '/' & local.fileName />
		<cfset local['settings'] = {} />
		<cfset local.settings['useModeration'] = true />
		<cfset local.settings['requireLogin'] = true />
		<cfset local.settings['allowEdit'] = true />
		<cfset local.settings['moderateEdits'] = false />
		
		<cfif len(structKeyList(arguments.settings))>
			<cfset local.newKeys = structKeyList(arguments.settings) />
			<cfset local.defaultKeys = structKeyList(local.settings) />
			
			<cfloop list="#local.newKeys#" index="local.key">
				<cfset local.settings[local.key] = arguments.settings[local.key] />
			</cfloop>
		</cfif>
		
		<cfif !directoryExists(local.filePath)>
			<cfdirectory action="create" directory="#local.filePath#" />
			<cfset local.abortTag = "<cfabort />" />
			<cfsavecontent variable="local.appCFM">
				<cfoutput>#local.abortTag#</cfoutput>
			</cfsavecontent>
			<cffile action="write" file="#local.filePath#/Application.cfm" output="#trim(local.appCFM)#" />
		</cfif>
		
		<cfif fileExists(local.fullPath) && !len(structKeyList(arguments.settings))>
			<cffile action="read" file="#local.fullPath#" variable="local.settingsFile" />
			<cfset local.settings = deserializejson(local.settingsFile) />
			<cftry>
				<cfcatch><!--- We do nothing for now ---></cfcatch>
			</cftry>
		<cfelse>
			<cffile action="write" file="#local.fullPath#" output="#serializejson(local.settings)#" />
		</cfif>
		
		<cfset variables[local.key] = local.settings />
	</cffunction>

</cfcomponent>
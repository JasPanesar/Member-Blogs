<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<cffunction name="onApplicationLoad" access="public" returntype="void" output="false">
		<cfset var local = {} />
		<cfset cacheRemove("memberblogs_settingsservice",false) />
		<cfset local.settingsService = createObject("component","memberblogs.org.stevegood.settings.SettingsService").init(expandPath(variables.configBean.getContext() & '/plugins/' & variables.pluginConfig.getDirectory() & '/configFiles')) />
		
		<cfset local['settings'] = {} />
		<cfset local.settings['useModeration'] = true />
		<cfset local.settings['requireLogin'] = true />
		<cfset local.settings['allowEdit'] = true />
		<cfset local.settings['moderateEdits'] = false />
		<cfset local.settings['parentid'] = "" />
		
		<cfset local.settingsService.setValue('defaultSettings',local.settings) />
		<cfset cachePut('memberblogs_settingsservice',local.settingsService) />
	</cffunction>
	
	<cffunction name="onSiteRequestStart" access="public" returntype="void" output="false">
		<cfargument name="event" />
		
		<cfset var local = {} />
		<cfset local.settingsService = cacheGet("memberblogs_settingsservice") />
		<cfset local.key = hash(request.siteid) />
		<cfset arguments.event.setValue(local.key, local.settingsService.getValue(local.key)) />
	</cffunction>
	
	<cffunction name="onAdminModuleNav" access="public" returntype="string" output="false">
		<cfargument name="event" />
		<cfreturn '<li><a href="#variables.configBean.getContext()#/plugins/#variables.pluginConfig.getDirectory()#/">Member Blogs</a></li>' />
	</cffunction>
	
	<cffunction name="onRetrieveMBSettings" access="public" returntype="void" output="false">
		<cfargument name="event" />
		
		<cfset var local = {} />
		<cfset local.settingsService = cacheGet("memberblogs_settingsservice") />
		<cfset local.key = hash(session.siteid) />
		<cfset arguments.event.setValue(local.key, local.settingsService.getValue(local.key)) />
	</cffunction>
	
	<cffunction name="onSaveMBPluginSettings" access="public" returntype="void" output="false">
		<cfargument name="event" />
		
		<cfset var local = {} />
		<cfset local.key = 'mb_' & hash(session.siteid) />
		<cfif isValid("Struct",event.getValue(local.key))>
			<cfset saveSettings(event.getValue(local.key)) />
		</cfif>
	</cffunction>
	
	<cffunction name="saveSettings" access="private" returntype="void" output="false">
		<cfargument name="newSettings" type="struct" required="true" />
		
		<cfset var local = {} />
		<cfset local.key = hash(session.siteid) />
		<cfset local.settingsService = cacheGet("memberblogs_settingsservice") />
		
		<cfset local.settings = duplicate(local.settingsService.getValue('defaultSettings')) />
		
		<cfset local.newKeys = structKeyList(arguments.newSettings) />
		<cfset local.defaultKeys = structKeyList(local.settings) />
		
		<cfloop list="#local.newKeys#" index="local.settings_key">
			<cfset local.settings[local.settings_key] = arguments.newSettings[local.settings_key] />
		</cfloop>
		
		<cfset local.settingsService.setValue(local.key,local.settings,true) />
		<cfset cachePut("memberblogs_settingsservice",local.settingsService) />
	</cffunction>
	
	<cffunction name="onAddMemberBlogRequest" access="public" returntype="void" output="false">
		<cfargument name="event" />
		
		<cfset var local = {} />
		<cfset local.settingsService = cacheGet('memberblogs_settingsservice') />
		<cfset local.settings = local.settingsService.getValue(hash(session.siteid)) />
		<cfset local.contentBean = application.contentManager.getBean() />
		
		<cfset local.contentBean.setSiteID(session.siteid) />
		<cfset local.contentBean.setApproved(local.settings.useModeration ? 0 : 1) />
		<cfset local.contentBean.setDisplay(local.settings.useModeration ? 0 : 1) />
		<cfset local.contentBean.setTitle(arguments.event.getValue('title')) />
		<cfset local.contentBean.setParentID(local.settings.parentid) />
		<cfset local.contentBean.setFileName(arguments.event.getValue('burl')) />
		<cfset local.contentBean.setSummary('<p>' & arguments.event.getValue('summary') & '</p>') />
		<cfset local.contentBean.setType('Link') />
		<cfset local.contentBean.setTarget('_blank') />
		<cfset local.contentBean.save() />
	</cffunction>
	
	<cffunction name="onMemberBlogApprove" access="public" returntype="void" output="false">
		<cfargument name="event" />
		
		<cfset var local = {} />
		<cfset local.content = application.contentManager.read(contentid=arguments.event.getValue('contentid'),siteid=session.siteid) />
		<cfset local.content.setDisplay(1) />
		<cfset local.content.save() />
	</cffunction>
	
	<cffunction name="onMemberBlogRevoke" access="public" returntype="void" output="false">
		<cfargument name="event" />
		
		<cfset var local = {} />
		<cfset local.content = application.contentManager.read(contentid=arguments.event.getValue('contentid'),siteid=session.siteid) />
		<cfset local.content.setDisplay(0) />
		<cfset local.content.save() />
	</cffunction>
	
	<cffunction name="onMemberBlogDelete" access="public" returntype="void" output="false">
		<cfargument name="event" />
		
		<cfset var local = {} />
		<cfset local.content = application.contentManager.read(contentid=arguments.event.getValue('contentid'),siteid=session.siteid) />
		<cfset local.content.delete() />
	</cffunction>
	
</cfcomponent>
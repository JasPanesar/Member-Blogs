<!--- 
	Plugin: Member Blogs
 --->

<cfinclude template="plugin/config.cfm" />

<cfsilent>
	<cfset $ = application.serviceFactory.getBean('MuraScope') />
	<cfset getSettingsEvent = createObject("component","mura.event").init() />
	<cfset $.setEvent(getSettingsEvent) />
	<cfset $.announceEvent('onRetrieveMBSettings',getSettingsEvent) />
	<cfset siteSettings = getSettingsEvent.getValue(hash(session.siteid)) />
	<cfset settings = {} />
	<cfset settings[hash(session.siteid)] = {useModeration=true} />
	<cfset saveSettingsEvent = createObject('component','mura.event').init(settings) />
	<cfset $.setEvent(saveSettingsEvent) />
	<cfset $.announceEvent('onSaveMBPluginSettings',saveSettingsEvent) />
</cfsilent>

<cfdump var="#siteSettings#" abort />

<cfsavecontent variable="variables.body">
	<cfoutput>
	<h2>#request.pluginConfig.getName()#</h2>
	<!--- TODO: Implement code... --->
	</cfoutput>
</cfsavecontent>

<cfoutput>#application.pluginManager.renderAdminTemplate(body=variables.body,pageTitle=request.pluginConfig.getName())#</cfoutput>
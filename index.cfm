<!--- 
	Plugin: Member Blogs
 --->

<cfinclude template="plugin/config.cfm" />

<cfsilent>
	<cfset $ = application.serviceFactory.getBean('MuraScope') />
	<cfif structKeyExists(form,'submit')>
		<cfparam name="form.useModeration" default="false" />
		<cfparam name="form.allowEdit" default="false" />
		<cfparam name="form.moderateEdits" default="false" />
		<cfparam name="form.requireLogin" default="false" />
		<cfparam name="form.parentid" default="" />
		
		<cfset settings = {} />
		<cfset settings['mb_' & hash(session.siteid)] = {useModeration=form.useModeration,allowEdit=form.allowEdit,moderateEdits=form.moderateEdits,requireLogin=form.requireLogin,parentid=form.parentid} />
		<cfset saveSettingsEvent = createObject('component','mura.event').init(settings) />
		<cfset $.setEvent(saveSettingsEvent) />
		<cfset $.announceEvent('onSaveMBPluginSettings',saveSettingsEvent) />
		<cflocation url="#application.configBean.getContext()#/plugins/#request.pluginConfig.getDirectory()#/" addtoken="false" />
	<cfelse>
		<cfif structKeyExists(url,'action')>
			<cfset eventData = {contentid=url.contentid} />
			<cfset actionEvent = createObject("component","mura.event").init(eventData) />
			<cfset $.setEvent(actionEvent) />
			<cfset $.announceEvent('onMemberBlog#url.action#',actionEvent) />
		</cfif>
		
		<cfset getSettingsEvent = createObject("component","mura.event").init() />
		<cfset $.setEvent(getSettingsEvent) />
		<cfset $.announceEvent('onRetrieveMBSettings',getSettingsEvent) />
		<cfset siteSettings = getSettingsEvent.getValue(hash(session.siteid)) />
		
		<cfif len(siteSettings.parentid) && isValid("UUID",siteSettings.parentid)>
			<cfset kids = application.contentManager.read(contentid=sitesettings.parentid,siteid=session.siteid).getKidsIterator(false) />
		</cfif>
		
	</cfif>
</cfsilent>

<cfsavecontent variable="variables.body">
	<cfoutput>
	<h2>#request.pluginConfig.getName()#</h2>
	
	<div id="settings_form">
		<form name="test" action="" method="post">
			<ol>
				<li>
					<input type="checkbox" name="useModeration" id="useModeration" #siteSettings.useModeration ? "checked=checked" : ""# value="true" />
					<label for="useModeration">Moderate Requests</label>
				</li>
				<li>
					<input type="checkbox" name="requirelogin" id="requireLogin" #siteSettings.requireLogin ? "checked=checked" : ""# value="true" />
					<label for="requireLogin">Require Login to Add</label>
				</li>
				<li>
					<input type="checkbox" name="allowEdit" id="allowEdit" #siteSettings.allowEdit ? "checked=checked" : ""# value="true" />
					<label for="allowEdit">Allow User Editing</label>
				</li>
				<li>
					<input type="checkbox" name="moderateEdits" id="moderateEdits" #siteSettings.moderateEdits ? "checked=checked" : ""# value="true" />
					<label for="moderateEdits">Moderate User Edits</label>
				</li>
				<li>
					<label for="parentid">Parent Content ID</label>
					<input type="text" class="text" id="parentid" name="parentid" value="#siteSettings.parentid#" />
				</li>
			</ol>
			<div class="buttons">
				<input type="submit" name="submit" value="Save" class="submit" />
			</div>
		</form>
	</div>
	
	<cfif len(siteSettings.parentid) && isValid("UUID",siteSettings.parentid)>
		<div id="memberBlogs">
			<ul style="list-style:none;">
				<cfloop condition="kids.hasNext()">
					<cfset kid = kids.next() />
					<li style="padding: 5px 5px 5px 5px;background: url(#application.configBean.getContext()#/admin/images/rule_dotted.gif) repeat-x scroll left top transparent; background-color:###kid.getDisplay() ? 'fff' : 'fe0' #;">
						<div><a href="#kid.getFileName()#"><strong>#kid.getTitle()#</strong> (#kid.getFileName()#)</a></div>
						<div>#kid.getSummary()#</div>
						<cfif kid.getDisplay()>
							<cfset action = "Revoke" />
						<cfelse>
							<cfset action = "Approve" />
						</cfif>
						<div><a href="?action=#lCase(action)#&contentid=#kid.getContentID()#"><small>#action#</small></a>
						 | <a href="?action=delete&contentid=#kid.getContentID()#"><small>Delete</small></a></div>
					</li>
				</cfloop>
			</ul>
		</div>
	</cfif>
		
	</cfoutput>
</cfsavecontent>

<cfoutput>#application.pluginManager.renderAdminTemplate(body=variables.body,pageTitle=request.pluginConfig.getName())#</cfoutput>
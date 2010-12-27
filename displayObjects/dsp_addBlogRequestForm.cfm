<!--- 
	Plugin: Member Blogs
	Display Object: Add Blog Request Form
 --->

<cfsilent>
	
	<cfset settings = $.event(hash(session.siteid)) />
	
	<cfset canHazAccess = false />
	<cfif !canHazAccess && settings.requireLogin && $.currentUser().isLoggedIn()>
		<cfset canHazAccess = true />
	</cfif>
	<cfif !canHazAccess && !settings.requireLogin>
		<cfset canHazAccess = true />
	</cfif>
	
	<cfif structKeyExists(form,'title') && canHazAccess>
		<cfset saveEvent = createObject("component","mura.event").init(form)>
		<cfset $.announceEvent('onAddMemberBlogRequest',saveEvent) />
		<cfset session.memberblogs.submitted_blog = true />
		<cflocation url="#$.currentURL()#" addtoken="false" />
	</cfif>
	
	<cfset $.loadJSLib() />
	
	<cfset message = "" />
	<cfif structKeyExists(session, 'memberblogs') && structKeyExists(session.memberblogs,'submitted_blog') && session.memberblogs.submitted_blog>
		<cfif settings.useModeration>
			<cfset message = "Your submission has been recorded and is awaiting moderation. Thank you!" />
		<cfelse>
			<cfset message = "Your blog has been added!" />
		</cfif>
	</cfif>
</cfsilent>
<div class="gadget" id="memberBlogs">
<cfif canHazAccess>
	<a href="javascript:void(0);" id="addlink" class="button">Add Your Blog</a>
<cfelse>
	<a href="?display=login">Login</a> to add your blog
</cfif>
</div>

<cfif canHazAccess>
<cfoutput>
<div id="addMemberBlogForm" class="hidden" style="display:none;">
	<form action="" method="post">
		<ol>
			<li>
				<label for="title">Your Name</label>
				<input type="text" name="title" id="title" class="text" value="#$.currentUser().getFName()# #$.currentUser().getLName()#" />
			</li>
			<li>
				<label for="burl">URL (including http://)</label>
				<input type="text" name="burl" id="burl" class="text" value="http://" />
			</li>
			<li>
				<label for="summary">Description</label>
				<textarea id="summary" name="summary"></textarea>
			</li>
			<li>
				<input type="submit" class="button" value="Add Blog" />
			</li>
		</ol>
	</form>
	<p>&nbsp;</p>
</div>
</cfoutput>
<link href="<cfoutput>#$.siteConfig('context')#/admin/css/jquery/default/jquery.ui.all.css</cfoutput>" rel="stylesheet" />
<script src="<cfoutput>#$.siteConfig('context')#/admin/js/jquery/jquery-ui.js</cfoutput>" type="text/javascript"></script>
<script type="text/javascript">
jQuery(function($){
	$('.button').button();
	$('#addlink').click(function(){
		$('#addMemberBlogForm').dialog({
			modal:true,
			title:"Add Your Blog",
			width:515
		});
	});
	<cfif len(message)>
	alert(<cfoutput>"#message#"</cfoutput>);
	</cfif>
});
</script>
</cfif>
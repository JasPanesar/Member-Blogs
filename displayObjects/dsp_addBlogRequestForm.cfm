<!--- 
	Plugin: Member Blogs
	Display Object: Add Blog Request Form
 --->

<cfsilent>
	
	<cfif structKeyExists(form,'title')>
		<cfset saveEvent = createObject("component","mura.event").init(form)>
		<cfset $.announceEvent('onAddMemberBlogRequest',saveEvent) />
	</cfif>
	
	<cfset $.loadJSLib() />
	<cfset settings = $.event(hash(session.siteid)) />
</cfsilent>
<div class="gadget" id="memberBlogs">
<cfif settings.requireLogin && $.currentUser().isLoggedIn()>
	<a href="javascript:void(0);" id="addlink" class="button">Add Your Blog</a>
<cfelse>
	<a href="?display=login">Login</a> to add your blog
</cfif>
</div>
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
});
</script>